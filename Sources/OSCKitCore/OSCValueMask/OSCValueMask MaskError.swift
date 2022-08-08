//
//  OSCValueMask MaskError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCValueMask {
    /// Error thrown by OSC value mask methods.
    public enum MaskError: Error {
        case invalidCount
        case mismatchedTypes
    }
}
