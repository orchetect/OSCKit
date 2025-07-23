//
//  Size Preamble Coding.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data {
    /// Returns the data encoded as a size-count-preamble framed datagram.
    func sizePreambleEncoded() -> Data {
        let length = UInt32(count)
            .toData(.platformDefault) // TODO: not sure if int type and endianness is correct
        return length + self
    }
    
    /// Decodes data that may contain one or more size-count-preamble framed datagrams.
    ///
    /// The structure is one or more of: a UInt32 length value followed by a sequence of bytes of that length.
    func sizePreambleDecoded() throws -> [Data] {
        var sequences: [SubSequence] = []
        
        var offset: Index = startIndex
        
        while offset < endIndex {
            let lengthFieldRange = offset ..< index(offset, offsetBy: 4)
            guard indices.contains(lengthFieldRange) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
            }
            
            guard let length = self[lengthFieldRange]
                .toUInt32(from: .platformDefault) // TODO: not sure if int type and endianness is correct
            else {
                throw SizePreambleDecodingError.notEnoughBytes
            }
            
            offset = lengthFieldRange.endIndex
            
            let packetRange = offset ..< index(offset, offsetBy: Int(length))
            guard indices.contains(packetRange) else {
                throw SizePreambleDecodingError.notEnoughBytes
            }
            
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
