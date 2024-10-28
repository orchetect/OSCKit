//
//  OSCEncodeError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Error type thrown from OSC encode methods.
public enum OSCEncodeError: LocalizedError {
    case general
    case unexpectedEncoder
    
    public var errorDescription: String? {
        switch self {
        case .general: return "General error."
        case .unexpectedEncoder: return "Unexpected encoder type."
        }
    }
}
