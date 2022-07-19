//
//  Pattern evaluate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCAddress.Pattern {
    
    /// Evaluate pattern matching against a single path component in an OSC address.
    ///
    /// - Parameters:
    ///   - name: OSC address path component
    /// - Returns: true if the path component pattern matches the supplied path component string.
    public func evaluate(matches name: String) -> Bool {
        
        #warning("> TODO: write new parser")
        
        // TODO: Fall through case for just ‘*’ or just .literal()
        
        return false
        
    }
    
}
