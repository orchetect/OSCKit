//
//  OSCTCPSLIPDecodingError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import protocol Foundation.LocalizedError
#else
import protocol Foundation.LocalizedError
#endif

/// Error cases thrown while decoding packet data encoded with the SLIP protocol (RFC 1055).
public enum OSCTCPSLIPDecodingError: LocalizedError, Equatable, Hashable {
    case doubleEscapeBytes
    case missingEscapedCharacter
    
    public var errorDescription: String? {
        switch self {
        case .doubleEscapeBytes:
            "SLIP packet data is malformed. Double escape bytes encountered."
        case .missingEscapedCharacter:
            "SLIP packet data is malformed. Encountered an escape byte but missing subsequent escaped character."
        }
    }
}
