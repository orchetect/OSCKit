//
//  OSCSerializationError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Error type returned by ``OSCSerialization`` methods.
public enum OSCSerializationError: LocalizedError {
    /// One more static tags associated with the type's tag identity are already registered.
    case tagAlreadyRegistered
    
    public var errorDescription: String? {
        switch self {
        case .tagAlreadyRegistered:
            return "Tag already registered"
        }
    }
}
