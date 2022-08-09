//
//  OSCValueMaskError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// Error thrown by `OSCValues.masked()` methods.
public enum OSCValueMaskError: Error {
    case invalidCount
    case mismatchedTypes
}
