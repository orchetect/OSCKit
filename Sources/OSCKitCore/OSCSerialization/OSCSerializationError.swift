//
//  OSCSerializationError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import protocol Foundation.LocalizedError
#else
import protocol Foundation.LocalizedError
#endif

/// Error type returned by ``OSCSerialization`` methods.
public enum OSCSerializationError: LocalizedError {
    /// One more static tags associated with the type's tag identity are already registered.
    case tagAlreadyRegistered
    
    public var errorDescription: String? {
        switch self {
        case .tagAlreadyRegistered:
            "Tag already registered"
        }
    }
}
