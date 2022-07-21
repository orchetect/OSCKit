//
//  OSCPayload.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// OSC payload types.
public enum OSCPayload {
    
    /// OSC Message.
    case message(OSCMessage)
    
    /// OSC Bundle, containing one or more OSC bundle(s) and/or OSC message(s).
    case bundle(OSCBundle)
    
}

// MARK: - CustomStringConvertible

extension OSCPayload: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .message(let element):
            return element.description
            
        case .bundle(let element):
            return element.description
            
        }
        
    }
    
}
