//
//  SLIP Coding.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data {
    /// SLIP protocol (RFC 1055) byte codes.
    ///
    /// See https://www.rfc-editor.org/rfc/rfc1055.txt
    enum SLIPByte: UInt8, Sendable {
        /// END (Packet end byte)
        case end = 0xC0
        
        /// ESC (Packet escape end)
        case esc = 0xDB
        
        /// ESC_END (Escaped 'end' byte)
        case escEnd = 0xDC
        
        /// ESC_ESC (Escaped 'escape' byte)
        case escEsc = 0xDD
    }
    
    /// Returns the data encoded as a SLIP packet.
    func slipEncoded() -> Data {
        var output = Data()
        
        output.append(SLIPByte.end.rawValue)
        
        for byte in self {
            switch byte {
            case SLIPByte.end.rawValue:
                output.append(SLIPByte.esc.rawValue)
                output.append(SLIPByte.escEnd.rawValue)
            case SLIPByte.esc.rawValue:
                output.append(SLIPByte.esc.rawValue)
                output.append(SLIPByte.escEsc.rawValue)
            default:
                output.append(byte)
            }
        }
        
        output.append(SLIPByte.end.rawValue)
        
        return output
    }
    
    /// Returns an array of SLIP-encoded packets stripped of their SLIP encoding.
    ///
    /// This can accommodate one or more packets in the same data stream. Each packet is
    /// returned as an element in the array.
    func slipDecoded() throws -> [Data] {
        var packets: [Data] = []
        
        var currentPacketData = Data()
        var isEscaped = false
        
        for index in indices {
            switch self[index] {
            case SLIPByte.end.rawValue:
                // END should never come after the escape char preamble
                guard !isEscaped else { throw SLIPDecodingError.missingEscapedCharacter}
                
                // consider the END byte the end of the current packet
                if !currentPacketData.isEmpty {
                    packets.append(currentPacketData)
                    currentPacketData = Data()
                }
                
                // discard one or more sequential END bytes before, between, and after each packet
                
            case SLIPByte.esc.rawValue:
                // we should never get more than one consecutive ESC byte
                guard !isEscaped else { throw SLIPDecodingError.doubleEscapeBytes}
                
                isEscaped = true
                
            case SLIPByte.escEnd.rawValue:
                // must follow an ESC byte
                guard isEscaped else { throw SLIPDecodingError.missingEscapeByte}
                isEscaped = false // reset ESC
                
                currentPacketData.append(SLIPByte.end.rawValue)
                
            case SLIPByte.escEsc.rawValue:
                // must follow an ESC byte
                guard isEscaped else { throw SLIPDecodingError.missingEscapeByte}
                isEscaped = false // reset ESC
                
                currentPacketData.append(SLIPByte.esc.rawValue)
                
            default:
                // the only two bytes that should follow an ESC byte are ESC_END and ESC_ESC
                guard !isEscaped else { throw SLIPDecodingError.missingEscapedCharacter}
                
                currentPacketData.append(self[index])
            }
        }
        
        // failsafe: ensure we are not ending while escaped (check if final byte was ESC)
        guard !isEscaped else { throw SLIPDecodingError.missingEscapedCharacter}
        
        // add final packet if needed
        if !currentPacketData.isEmpty {
            packets.append(currentPacketData)
        }
        
        return packets
    }
}

/// Error cases thrown while decoding packet data encoded with the SLIP protocol (RFC 1055).
public enum SLIPDecodingError: LocalizedError, Equatable, Hashable {
    case doubleEscapeBytes
    case missingEscapeByte
    case missingEscapedCharacter
    
    public var errorDescription: String? {
        switch self {
        case .doubleEscapeBytes:
            "SLIP packet data is malformed. Double escape bytes encountered."
        case .missingEscapeByte:
            "SLIP packet data is malformed. Encountered an escaped character but missing preceding escape byte."
        case .missingEscapedCharacter:
            "SLIP packet data is malformed. Encountered an escape byte but missing subsequent escaped character."
        }
    }
}
