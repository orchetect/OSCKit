//
//  Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import SwiftASCII

// MARK: - Data methods

extension Data {
    /// Internal helper function.
    @inlinable
    internal func extractInt32() -> (
        int32Value: Int32,
        byteLength: Int
    )? {
        if self.count < 4 { return nil }
        
        let chunk = self.subdata(in: 0 ..< 4)
        
        guard let value = chunk.toInt32(from: .bigEndian)
        else { return nil }
        
        return (value, chunk.count)
    }
    
    /// Internal helper function.
    @inlinable
    internal func extractInt64() -> (
        int64Value: Int64,
        byteLength: Int
    )? {
        if self.count < 8 { return nil }
        
        let chunk = self.subdata(in: 0 ..< 8)
        
        guard let value = chunk.toInt64(from: .bigEndian)
        else { return nil }
        
        return (value, chunk.count)
    }
    
    /// Internal helper function.
    /// aka Float
    @inlinable
    internal func extractFloat32() -> (
        float32Value: Float32,
        byteLength: Int
    )? {
        if self.count < 4 { return nil }
        
        let chunk = self.subdata(in: 0 ..< 4)
        
        guard let value = chunk.toFloat32(from: .bigEndian)
        else { return nil }
        
        return (value, chunk.count)
    }
    
    /// Internal helper function.
    /// aka Float64
    @inlinable
    internal func extractDouble() -> (
        doubleValue: Double,
        byteLength: Int
    )? {
        if self.count < 8 { return nil }
        
        let chunk = self.subdata(in: 0 ..< 8)
        
        guard let value = chunk.toDouble(from: .bigEndian)
        else { return nil }
        
        return (value, chunk.count)
    }
    
    /// Internal helper function.
    @inlinable
    internal func extractNull4ByteTerminatedASCIIString() -> (
        asciiStringValue: ASCIIString,
        byteLength: Int
    )? {
        // extractNull4ByteTerminatedData takes care of data size validation so we don't need to do it here
        guard let chunk = self.extractNull4ByteTerminatedData()
        else { return nil }
        
        guard let string = ASCIIString(exactly: chunk.data)
        else { return nil }
        
        return (string, chunk.byteLength)
    }
    
    /// Internal helper function.
    @inlinable
    internal func extractNull4ByteTerminatedData() -> (
        data: Data,
        byteLength: Int
    )? {
        // ensure minimum of 4 bytes to work with
        if self.count < 4 { return nil }
        
        // check for first null
        guard let nullFound: Int = self.range(of: Data([0x00]))?.lowerBound
        else { return nil }
        
        // calculate theoretical position after first null that is a multiple of 4 bytes
        let byteCount = nullFound + (4 - (nullFound % 4))
        
        // check to see if there actually are enough bytes
        guard self.count >= byteCount else { return nil }
        
        // check to see if any pad bytes are all nulls
        guard self[nullFound ..< byteCount].allSatisfy({ $0 == 0x00 })
        else { return nil }
        
        return (self.subdata(in: 0 ..< nullFound), byteCount)
    }
    
    /// Internal helper function.
    @inlinable
    internal func extractBlob() -> (
        blobValue: Data,
        byteLength: Int
    )? {
        // check for int32 length chunk
        guard let pull = self.extractInt32()
        else { return nil }
        
        let blobSize = Int(pull.int32Value) // blob byte length
        
        // blob OSC chunk length
        let blobRawSize = (self.count - 4).roundedUp(toMultiplesOf: 4)
        
        // check if data is indeed at least as long as the int32 length claims it is
        if (blobRawSize > self.count - 4) { return nil }
        
        // check to see if any pad bytes are all nulls
        guard self[4 + blobSize ..< 4 + blobRawSize].allSatisfy({ $0 == 0x00 })
        else { return nil }
        
        let chunk = self.subdata(in: 4 ..< 4 + blobSize)
        
        return (chunk, blobRawSize)
    }
    
    /// Internal helper function.
    @inlinable
    internal func extract(byteLength: Int) -> Data? {
        if byteLength < 0 || byteLength > self.count { return nil }
        
        return self[0 ..< byteLength]
    }
}

extension Data {
    /// Internal helper function.
    /// Conforms a data bock representing a string to 4-byte null-padded OSC-string formatting
    @inlinable
    internal var fourNullBytePadded: Data {
        var retval = self
        let appendval = Data([UInt8](
            repeating: 00,
            count: (4 - (self.count % 4))
        ))
        retval += appendval
        
        return retval
        
    }
    
}
