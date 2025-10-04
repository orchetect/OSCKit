//
//  OSCEncodeError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Error type thrown from OSC encode methods.
public enum OSCEncodeError: LocalizedError {
    /// General encoding error.
    case general(_ verboseError: String)
    
    /// Error encountered while encoding an OSC value.
    /// `verboseError` contains the specific reason.
    case valueEncodingError(_ verboseError: String)
    
    /// Internal inconsistency; encoding logic is in an unexpected state and cannot continue.
    /// `verboseError` contains the specific reason.
    case internalInconsistency(_ verboseError: String)
    
    public var errorDescription: String? {
        switch self {
        case let .general(verboseError): "Encoding error: \(verboseError)"
        case let .valueEncodingError(verboseError): "OSC value encoding error: \(verboseError)"
        case let .internalInconsistency(verboseError): "Internal inconsistency: \(verboseError)"
        }
    }
}
