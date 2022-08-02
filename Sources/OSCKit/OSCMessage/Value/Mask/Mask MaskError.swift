//
//  Mask MaskError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCMessage.Value.Mask {
    /// Error thrown by OSC value mask methods.
    public enum MaskError: Error {
        case invalidCount
        case mismatchedTypes
    }
}
