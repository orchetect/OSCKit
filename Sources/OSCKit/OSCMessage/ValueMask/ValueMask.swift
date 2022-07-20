//
//  OSCMessage ValueMask.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCMessage {
    
    /// OSC message values mask.
    /// Contains a sequence of value type tokens, including optional variants and meta types.
    public struct ValueMask {
        
        /// Ordered array of value mask tokens.
        public var tokens: [Token]
        
    }
    
}
