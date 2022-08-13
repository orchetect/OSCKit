//
//  OSCSerializationError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public enum OSCSerializationError: Error {
    /// One more static tags associated with the type's tag identity are already registered.
    case tagAlreadyRegistered
}
