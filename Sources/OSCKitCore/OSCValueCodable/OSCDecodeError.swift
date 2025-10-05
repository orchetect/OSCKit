//
//  OSCDecodeError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Error type thrown from OSC decode methods.
public enum OSCDecodeError: LocalizedError {
    /// Malformed data. `verboseError` contains the specific reason.
    case malformed(_ verboseError: String)
        
    /// An unexpected OSC-value type was encountered in the data.
    /// `tag` contains the OSC Type Tag encountered.
    case unexpectedType(tag: Character)
    
    /// Error encountered while decoding an OSC value.
    /// `verboseError` contains the specific reason.
    case valueDecodingError(_ verboseError: String)
    
    /// Internal inconsistency; decoding logic is in an unexpected state and cannot continue.
    /// `verboseError` contains the specific reason.
    case internalInconsistency(_ verboseError: String)
    
    public var errorDescription: String? {
        switch self {
        case let .malformed(verboseError): "Malformed data: \(verboseError)"
        case let .unexpectedType(tag: tag): "Unexpected OSC Type Tag: \(tag)"
        case let .valueDecodingError(verboseError): "OSC value decoding error: \(verboseError)"
        case let .internalInconsistency(verboseError): "Internal inconsistency: \(verboseError)"
        }
    }
}
