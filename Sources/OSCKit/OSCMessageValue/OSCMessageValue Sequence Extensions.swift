//
//  OSCMessageValue Sequence Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension Sequence where Iterator.Element == OSCMessageValue {
    
    /// Convenience: maps a sequence of `OSCMessageValue`s to a flat string, for logging/debug purposes.
    func mapDebugString(withLabel: Bool = true, separator: String = ", ") -> String {
        
        self.map { $0.stringValue(withLabel: withLabel) }
            .joined(separator: separator)
        
    }
    
}
