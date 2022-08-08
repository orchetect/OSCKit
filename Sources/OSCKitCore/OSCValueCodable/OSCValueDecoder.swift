//
//  OSCValueDecoder.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

private let defaultContextSingleton = OSCSerialization()

public struct OSCValueDecoder {
    weak var context: OSCSerialization?
    
    let data: Data
    var remainingData: Data {
        data[pos...]
    }
    
    var pos: Int = 0
    
    /// Initialize with default context or custom context.
    init(data: Data,
         context: OSCSerialization? = nil) {
        self.data = data
        self.context = context ?? defaultContextSingleton
    }
}

extension OSCValueDecoder {
    /// Returns number of available bytes left in the data stream.
    public var remainingByteCount: Int {
        data.count - pos
    }
    
    /// Manually advance data read position.
    /// This functionality will be automatically handled by local `read*()` methods if they succeed. This method is only provided for custom parsing needs.
    ///
    /// - Throws: Error if position is advanced past the end of the available number of bytes.
    public mutating func advancePosition(by numberOfBytes: Int) throws {
        guard numberOfBytes < remainingByteCount else {
            throw OSCDecodeError.malformed(
                "Attempted to advance byte read position past end of available bytes."
            )
        }
        pos += numberOfBytes
    }
}

extension OSCValueDecoder {
    /// Read an encoded `Int32` value.
    /// (32-bit big-endian two's complement integer.)
    public mutating func readInt32() throws -> Int32 {
        if remainingData.count < 4 {
            throw OSCDecodeError.malformed(
                "Not enough bytes while reading Int32 data chunk."
            )
        }
        
        let chunk = remainingData.subdata(in: 0 ..< 4)
        
        guard let value = chunk.toInt32(from: .bigEndian)
        else {
            throw OSCDecodeError.malformed(
                "Failed to construct Int32 from chunk data."
            )
        }
        
        let byteCount = chunk.count
        try advancePosition(by: byteCount)
        
        return value
    }
    
    /// Read an encoded `Int64` value.
    /// (64-bit big-endian two's complement integer.)
    public mutating func readInt64() throws -> Int64 {
        if remainingData.count < 8 {
            throw OSCDecodeError.malformed(
                "Not enough bytes while reading Int64 data chunk."
            )
        }
        
        let chunk = remainingData.subdata(in: 0 ..< 8)
        
        guard let value = chunk.toInt64(from: .bigEndian)
        else {
            throw OSCDecodeError.malformed(
                "Failed to construct Int64 from chunk data."
            )
        }
        
        let byteCount = chunk.count
        try advancePosition(by: byteCount)
        
        return value
    }
    
    /// Read an encoded `UInt64` value.
    /// (64-bit big-endian fixed-point integer.)
    public mutating func readUInt64() throws -> UInt64 {
        if remainingData.count < 8 {
            throw OSCDecodeError.malformed(
                "Not enough bytes while reading UInt64 data chunk."
            )
        }
        
        let chunk = remainingData.subdata(in: 0 ..< 8)
        
        guard let value = chunk.toUInt64(from: .bigEndian)
        else {
            throw OSCDecodeError.malformed(
                "Failed to construct UInt64 from chunk data."
            )
        }
        
        let byteCount = chunk.count
        try advancePosition(by: byteCount)
        
        return value
    }
    
    /// Read an encoded `Float32` value.
    /// a.k.a. "Float"
    /// (32-bit big-endian IEEE 754 floating point number)
    public mutating func readFloat32() throws -> Float32 {
        if remainingData.count < 4 {
            throw OSCDecodeError.malformed(
                "Not enough bytes while reading Float32 data chunk."
            )
        }
        
        let chunk = remainingData.subdata(in: 0 ..< 4)
        
        guard let value = chunk.toFloat32(from: .bigEndian)
        else {
            throw OSCDecodeError.malformed(
                "Failed to construct Float32 from chunk data."
            )
        }
        
        let byteCount = chunk.count
        try advancePosition(by: byteCount)
        
        return value
    }
    
    /// Read an encoded `Double` value.
    /// a.k.a. "Float64"
    /// (64-bit ("double") IEEE 754 floating point number)
    public mutating func readDouble() throws -> Double {
        if remainingData.count < 8 {
            throw OSCDecodeError.malformed(
                "Not enough bytes while reading Double data chunk."
            )
        }
        
        let chunk = remainingData.subdata(in: 0 ..< 8)
        
        guard let value = chunk.toDouble(from: .bigEndian)
        else {
            throw OSCDecodeError.malformed(
                "Failed to construct Double from chunk data."
            )
        }
        
        let byteCount = chunk.count
        try advancePosition(by: byteCount)
        
        return value
    }
    
    /// Read a 4-byte aligned null-terminated ASCII string chunk.
    ///
    /// The string is validated and an error is thrown if it contains non-ASCII characters which may be a sign the data is malformed. (OSC string encoding allows only ASCII characters.)
    public mutating func read4ByteAlignedNullTerminatedASCIIString() throws -> String {
        // read4ByteAlignedNullTerminatedData takes care of data size validation so we don't need to do it here
        guard let chunk = try? read4ByteAlignedNullTerminatedData()
        else {
            throw OSCDecodeError.malformed(
                "Not enough bytes in 4-byte aligned null-terminated ASCII string chunk."
            )
        }
        
        guard let value = ASCIIString(exactly: chunk.data)?.stringValue
        else {
            throw OSCDecodeError.malformed(
                "Failed to form valid ASCII string from 4-byte aligned null-terminated ASCII string chunk. Non-ASCII characters may be present or the data is malformed."
            )
        }
        
        // advancePosition() was already called by read4ByteAlignedNullTerminatedData()
        
        return value
    }
    
    /// Read a 4-byte aligned null-terminated data chunk.
    public mutating func read4ByteAlignedNullTerminatedData() throws -> Data {
        // ensure minimum of 4 bytes to work with
        if remainingData.count < 4 {
            throw OSCDecodeError.malformed(
                "Not enough bytes in 4-byte aligned null-terminated data chunk."
            )
        }
        
        // check for first null
        guard let nullFound: Int = remainingData.range(of: Data([0x00]))?.lowerBound
        else {
            throw OSCDecodeError.malformed(
                "4-byte aligned null-terminated data chunk does not terminate in null bytes as expected."
            )
        }
        
        // calculate theoretical position after first null that is a multiple of 4 bytes
        let byteCount = nullFound + (4 - (nullFound % 4))
        
        // check to see if there actually are enough bytes
        guard remainingData.count >= byteCount else {
            throw OSCDecodeError.malformed(
                "Not enough bytes in 4-byte aligned null-terminated data chunk."
            )
        }
        
        // check to see if any pad bytes are all nulls
        guard remainingData[nullFound ..< byteCount]
            .allSatisfy({ $0 == 0x00 })
        else {
            throw OSCDecodeError.malformed(
                "4-byte aligned null-terminated data chunk does not terminate in null bytes as expected."
            )
        }
        
        try advancePosition(by: byteCount)
        
        return remainingData.subdata(in: 0 ..< nullFound)
    }
    
    /// Read an OSC blob data chunk.
    public mutating func readBlob() throws -> Data {
        // check for int32 length chunk
        guard let blobSize = try? readInt32().int else {
            throw OSCDecodeError.malformed(
                "Failed to read Int32 length chunk at start of 4-byte aligned null-terminated blob data chunk."
            )
        }
        
        // blob OSC chunk length
        let blobRawSize = (remainingData.count - 4).roundedUp(toMultiplesOf: 4)
        
        // check if data is indeed at least as long as the int32 length claims it is
        if (blobRawSize > remainingData.count - 4) {
            throw OSCDecodeError.malformed(
                "Not enough bytes in 4-byte aligned null-terminated blob data chunk."
            )
        }
        
        // check to see if any pad bytes are all nulls
        guard data[4 + blobSize ..< 4 + blobRawSize]
            .allSatisfy({ $0 == 0x00 })
        else {
            throw OSCDecodeError.malformed(
                "Expected 4-byte null terminated data but expected null bytes were not found."
            )
        }
        
        let chunk = data.subdata(in: 4 ..< 4 + blobSize)
        
        let byteCount = blobRawSize
        try advancePosition(by: byteCount)
        
        return chunk
    }
    
    /// Read an arbitrary number of bytes from the data stream.
    public mutating func read(byteLength: Int) throws -> Data {
        guard byteLength > 0 else { return Data() }
        
        guard byteLength < remainingByteCount else {
            throw OSCDecodeError.malformed(
                "Not enough bytes remain in data stream. Attempted to read \(byteLength) bytes "
            )
        }
        
        try advancePosition(by: byteLength)
        
        return remainingData[0 ..< byteLength]
    }
}
