//
//  OSCSerializationError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Error type returned by ``OSCSerialization`` methods.
public enum OSCSerializationError: Error {
    /// One more static tags associated with the type's tag identity are already registered.
    case tagAlreadyRegistered
}
