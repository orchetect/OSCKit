//
//  Mask MaskError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension OSCMessage.Value.Mask {
    
    /// Error thrown by OSC value mask methods.
    enum MaskError: Error {
        
        case invalidCount
        case mismatchedTypes
        
    }
    
}
