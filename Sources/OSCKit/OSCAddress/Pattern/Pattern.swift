//
//  OSCAddress Pattern.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCAddress {
    
    /// A tokenized pattern of an individual path component in an OSC address pattern.
    public struct Pattern {
        
        var tokens: [Token] = []
        
        public init() {
            
        }
        
    }
    
}
