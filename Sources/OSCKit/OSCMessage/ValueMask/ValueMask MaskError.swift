//
//  ValueMask MaskError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension OSCMessage.ValueMask {
    
    /// Error thrown by OSC value mask methods.
    enum MaskError: Error {
        
        case invalidCount
        case mismatchedTypes
        
    }
    
}
