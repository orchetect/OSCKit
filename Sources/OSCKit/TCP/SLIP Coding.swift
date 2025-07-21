//
//  SLIP Coding.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Error cases thrown while decoding packet data encoded with the SLIP protocol (RFC 1055).
public enum SLIPDecodingError: LocalizedError, Equatable, Hashable {
    case doubleEscapeBytes
    case missingEscapeByte
    case missingEscapedCharacter
    case unexpectedEndByte
    
    public var errorDescription: String? {
        switch self {
        case .doubleEscapeBytes:
            "SLIP packet data is malformed. Double escape bytes encountered."
        case .missingEscapeByte:
            "SLIP packet data is malformed. Encountered an escaped character but missing preceding escape byte."
        case .missingEscapedCharacter:
            "SLIP packet data is malformed. Encountered an escape byte but missing subsequent escaped character."
        case .unexpectedEndByte:
            "SLIP packet data is malformed. Unexpected end byte encountered before end of SLIP packet."
        }
    }
}

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
    
    /// Returns the SLIP-encoded packet data stripped of its SLIP encoding.
    func slipDecoded() throws -> Data {
        let endStrippedData = slipDoubleEndStripped()
        
        var output = Data()
        var isEscaped = false
        
        for index in endStrippedData.indices {
            switch endStrippedData[index] {
            case SLIPByte.end.rawValue:
                // END should never come after the escape char preamble
                guard !isEscaped else { throw SLIPDecodingError.missingEscapedCharacter}
                
                // as a failsafe, allow one or more sequential END bytes, but only at the start or end of the packet
                
                // allow at start of packet
                if output.isEmpty { break }
                
                // allow at end of packet
                guard endStrippedData[index...].allSatisfy({ $0 == SLIPByte.end.rawValue }) else {
                    throw SLIPDecodingError.unexpectedEndByte
                }
                break
                
            case SLIPByte.esc.rawValue:
                // we should never get more than one consecutive ESC byte
                guard !isEscaped else { throw SLIPDecodingError.doubleEscapeBytes}
                
                isEscaped = true
                
            case SLIPByte.escEnd.rawValue:
                // must follow an ESC byte
                guard isEscaped else { throw SLIPDecodingError.missingEscapeByte}
                isEscaped = false // reset ESC
                
                output.append(SLIPByte.end.rawValue)
                
            case SLIPByte.escEsc.rawValue:
                // must follow an ESC byte
                guard isEscaped else { throw SLIPDecodingError.missingEscapeByte}
                isEscaped = false // reset ESC
                
                output.append(SLIPByte.esc.rawValue)
                
            default:
                // the only two bytes that should follow an ESC byte are ESC_END and ESC_ESC
                guard !isEscaped else { throw SLIPDecodingError.missingEscapedCharacter}
                
                output.append(endStrippedData[index])
            }
        }
        
        // failsafe: ensure we are not ending while escaped (check if final byte was ESC)
        guard !isEscaped else { throw SLIPDecodingError.missingEscapedCharacter}
        
        return output
    }
    
    /// Returns the SLIP-encoded packet data stripped of its leading and trailing SLIP END characters, if any.
    func slipDoubleEndStripped() -> Data {
        guard count >= 2 else { return self }
        
        guard first == SLIPByte.end.rawValue,
              last == SLIPByte.end.rawValue
        else { return self }
        
        return dropFirst().dropLast()
    }
}
