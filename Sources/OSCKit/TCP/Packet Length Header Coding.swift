//
//  Packet Length Header Coding.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data {
    /// Returns the data encoded as a packet-length header framed datagram.
    func packetLengthHeaderEncoded(endianness: NumberEndianness = .platformDefault) -> Data {
        let length = UInt32(count)
            .toData(endianness)
        return length + self
    }
    
    /// Decodes data that may contain one or more packet-length header framed datagrams.
    ///
    /// The structure is one or more of: a UInt32 length value followed by a sequence of bytes of that length.
    func packetLengthHeaderDecoded(endianness: NumberEndianness = .platformDefault) throws -> [Data] {
        var sequences: [SubSequence] = []
        
        var offset: Index = startIndex
        
        while offset < endIndex {
            guard offset + 4 <= endIndex else {
                throw SizePreambleDecodingError.notEnoughBytes
            }
            let lengthFieldRange = offset ..< offset + 4
            
            guard let length = self[lengthFieldRange]
                .toUInt32(from: endianness)
            else {
                throw SizePreambleDecodingError.notEnoughBytes
            }
            
            offset = lengthFieldRange.endIndex
            
            guard offset + Int(length) <= endIndex else {
                throw SizePreambleDecodingError.notEnoughBytes
            }
            let packetRange = offset ..< offset + Int(length)
            
            offset = packetRange.endIndex
            
            let sequence: SubSequence = self[packetRange]
            sequences.append(sequence)
        }
        
        return sequences
    }
}

/// Error cases thrown while decoding packet data encoded with the SLIP protocol (RFC 1055).
public enum SizePreambleDecodingError: LocalizedError, Equatable, Hashable {
    case notEnoughBytes
    
    public var errorDescription: String? {
        switch self {
        case .notEnoughBytes:
            "Note enough bytes."
        }
    }
}
