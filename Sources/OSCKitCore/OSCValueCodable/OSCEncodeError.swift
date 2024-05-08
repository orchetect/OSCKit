//
//  OSCEncodeError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

/// Error type thrown from OSC encode methods.
public enum OSCEncodeError: Error {
    case general
    case unexpectedEncoder
}
