//
//  OSCValueMaskError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Error thrown by `OSCValues.masked()` methods.
public enum OSCValueMaskError: Error {
    case invalidCount
    case mismatchedTypes
}
