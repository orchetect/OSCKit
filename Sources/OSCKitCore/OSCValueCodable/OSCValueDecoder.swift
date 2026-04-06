//
//  OSCValueDecoder.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
import protocol Foundation.DataProtocol
#else
import struct FoundationEssentials.Data
import protocol FoundationEssentials.DataProtocol
#endif

internal import SwiftASCII // ASCIIString
import SwiftDataParsing

/// ``OSCValue`` decoder.
public typealias OSCValueDecoder = PointerDataParser<Data>

extension OSCValueDecoder {
    /// Read an encoded `Int32` value.
    /// (32-bit big-endian two's complement integer.)
    public mutating func readOSCInt32() throws(OSCDecodeError) -> Int32 {
        let chunk = try readOSC(bytes: 4)
        
        guard let value = chunk.toInt32(from: .bigEndian)
        else {
            throw .malformed(
                "Failed to construct Int32 from chunk data."
            )
        }
        
        return value
    }
    
    /// Read an encoded `Int64` value.
    /// (64-bit big-endian two's complement integer.)
    public mutating func readOSCInt64() throws(OSCDecodeError) -> Int64 {
        let chunk = try readOSC(bytes: 8)
        
        guard let value = chunk.toInt64(from: .bigEndian)
        else {
            throw .malformed(
                "Failed to construct Int64 from chunk data."
            )
        }
        
        return value
    }
    
    /// Read an encoded `UInt64` value.
    /// (64-bit big-endian fixed-point integer.)
    public mutating func readOSCUInt64() throws(OSCDecodeError) -> UInt64 {
        let chunk = try readOSC(bytes: 8)
        
        guard let value = chunk.toUInt64(from: .bigEndian)
        else {
            throw .malformed(
                "Failed to construct UInt64 from chunk data."
            )
        }
        
        return value
    }
    
    /// Read an encoded `Float32` value.
    /// a.k.a. "Float"
    /// (32-bit big-endian IEEE 754 floating point number)
    public mutating func readOSCFloat32() throws(OSCDecodeError) -> Float32 {
        let chunk = try readOSC(bytes: 4)
        
        guard let value = chunk.toFloat32(from: .bigEndian)
        else {
            throw .malformed(
                "Failed to construct Float32 from chunk data."
            )
        }
        
        return value
    }
    
    /// Read an encoded `Double` value.
    /// a.k.a. "Float64"
    /// (64-bit ("double") IEEE 754 floating point number)
    public mutating func readOSCDouble() throws(OSCDecodeError) -> Double {
        let chunk = try readOSC(bytes: 8)
        
        guard let value = chunk.toDouble(from: .bigEndian)
        else {
            throw .malformed(
                "Failed to construct Double from chunk data."
            )
        }
        
        return value
    }
    
    /// Read a 4-byte padded null-terminated ASCII string chunk.
    ///
    /// The string is validated and an error is thrown if it contains non-ASCII characters which may
    /// be a sign the data is malformed. (OSC string encoding allows only ASCII characters.)
    public mutating func readOSCNullTerminatedString() throws(OSCDecodeError) -> String {
        // readOSCNullTerminatedData takes care of data size validation so we don't need to do it here
        let chunk = try readOSCNullTerminatedData()
        
        guard let value = ASCIIString(exactly: chunk.toData())?.stringValue
        else {
            throw .malformed(
                "Failed to form valid ASCII string from 4-byte aligned null-terminated ASCII string chunk."
                    + " Non-ASCII characters may be present or the data is malformed."
            )
        }
        
        return value
    }
    
    /// Read a 4-byte padded null-terminated data chunk.
    public mutating func readOSCNullTerminatedData() throws(OSCDecodeError) -> DataRange {
        // ensure minimum of 4 bytes to work with
        if remainingByteCount < 4 {
            throw .malformed(
                "Not enough bytes in 4-byte aligned null-terminated data chunk."
            )
        }
        
        let data = try readOSC(advance: false)
        assert(data.startIndex == 0)
        
        // check for first null
        guard let nullIndex = data
            .firstIndex(of: 0x00)
        else {
            throw .malformed(
                "4-byte aligned null-terminated data chunk does not terminate in null bytes as expected."
            )
        }
        
        // grab data bytes
        let dataBytes = try readOSC(bytes: nullIndex)
        
        // calculate theoretical position after first null that is a multiple of 4 bytes
        let nullBytePaddingCount = 4 - (nullIndex % 4)
        assert((1 ... 4).contains(nullBytePaddingCount))
        if nullBytePaddingCount > 0 {
            // check to see if pad bytes are all nulls
            let nullBytes = try readOSC(bytes: nullBytePaddingCount)
            guard nullBytes
                .allSatisfy({ $0 == 0x00 })
            else {
                throw .malformed(
                    "4-byte aligned null-terminated data chunk does not terminate in null bytes as expected."
                )
            }
        }
        
        return dataBytes
    }
    
    /// Read an OSC blob data chunk.
    public mutating func readOSCBlob() throws(OSCDecodeError) -> DataRange {
        // check for int32 length chunk
        // note: theoretical max IPv4 UDP packet size is 65507.
        // this not a definitive check but can at least protect against malformed data
        guard let blobDataSize = try? readOSCInt32().int, blobDataSize < 65507 else {
            throw .malformed(
                "Failed to read Int32 length chunk at start of 4-byte aligned null-terminated blob data chunk."
            )
        }
        
        // blob OSC chunk length
        let paddedBlobDataSize = blobDataSize.roundedUp(toMultiplesOf: 4)
        
        // check if data is at least as long as the int32 length claims it is
        if paddedBlobDataSize > remainingByteCount {
            throw .malformed(
                "Not enough bytes in 4-byte aligned null-terminated blob data chunk."
            )
        }
        
        // grab data bytes
        let dataBytes = try readOSC(bytes: blobDataSize)
        
        // sanity check to guard against crash
        guard blobDataSize <= paddedBlobDataSize else {
            throw .malformed(
                "Encoded blob chunk length is greater than the available data length."
            )
        }
        
        // check to see if any pad bytes are all nulls
        let nullBytePaddingCount = paddedBlobDataSize - blobDataSize
        assert((0 ... 3).contains(nullBytePaddingCount))
        if nullBytePaddingCount > 0 {
            let nullBytes = try readOSC(bytes: nullBytePaddingCount)
            guard nullBytes
                .allSatisfy({ $0 == 0x00 })
            else {
                throw .malformed(
                    "Expected 4-byte null terminated data but expected null bytes were not found."
                )
            }
        }
        
        return dataBytes
    }
}

extension OSCValueDecoder {
    public mutating func readOSC(advance: Bool) throws(OSCDecodeError) -> DataRange {
        do throws(DataParserError) {
            return try read(advance: advance)
        } catch {
            throw .malformed(error.localizedDescription)
        }
    }
    
    public mutating func readOSC(bytes count: Int?) throws(OSCDecodeError) -> DataRange {
        do throws(DataParserError) {
            return try read(bytes: count)
        } catch {
            throw .malformed(error.localizedDescription)
        }
    }
    
    public mutating func seekOSC(by count: Int) throws(OSCDecodeError) {
        do throws(DataParserError) {
            return try seek(by: count)
        } catch {
            throw .malformed(error.localizedDescription)
        }
    }
}
