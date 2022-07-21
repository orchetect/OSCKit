//
//  Dispatcher Node.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

extension OSCAddress.Dispatcher {
    
    /// Represents an OSC address space container or method.
    class Node {
        
        public let id = MethodID()
        
        public let name: String
        
        public var children: [Node] = []
        
        public init<S>(_ name: S) where S : StringProtocol {
            
            // sanitize name
            self.name = Self.sanitize(name: name)
            
        }
    }
    
}

extension OSCAddress.Dispatcher.Node: Equatable {
    static func == (lhs: OSCAddress.Dispatcher.Node,
                    rhs: OSCAddress.Dispatcher.Node) -> Bool {
        lhs.id == rhs.id
    }
}

extension OSCAddress.Dispatcher.Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension OSCAddress.Dispatcher.Node {
    
    /// Sanitizes an OSC address space node name by removing invalid characters.
    ///
    /// Invalid characters:
    ///
    ///     ’ ’ space               ASCII char 32
    ///     #   number sign         ASCII char 35
    ///     /   forward slash       ASCII char 47
    ///
    /// Invalid characters, reserved for pattern matching:
    ///
    ///     !   exclamation point   ASCII char 33
    ///     *   asterisk            ASCII char 42
    ///     ,   comma               ASCII char 44
    ///     ?   question mark       ASCII char 63
    ///     [   open bracket        ASCII char 91
    ///     ]   close bracket       ASCII char 93
    ///     {   open curly brace    ASCII char 123
    ///     }   close curly brace   ASCII char 125
    ///
    static func sanitize(name: ASCIIString) -> ASCIIString {
        
        Self.sanitize(name: name.stringValue)
            .asciiStringLossy
        
    }
    
    /// Sanitizes an OSC address space node name by removing invalid characters.
    ///
    /// Invalid characters:
    ///
    ///     ’ ’ space               ASCII char 32
    ///     #   number sign         ASCII char 35
    ///     /   forward slash       ASCII char 47
    ///
    /// Invalid characters, reserved for pattern matching:
    ///
    ///     !   exclamation point   ASCII char 33
    ///     *   asterisk            ASCII char 42
    ///     ,   comma               ASCII char 44
    ///     ?   question mark       ASCII char 63
    ///     [   open bracket        ASCII char 91
    ///     ]   close bracket       ASCII char 93
    ///     {   open curly brace    ASCII char 123
    ///     }   close curly brace   ASCII char 125
    ///
    static func sanitize<S>(name: S) -> String where S : StringProtocol {
        
        let sanitized = name
            .onlyAlphanumerics
            .regexMatches(pattern: #"[\s\#\!\*\,/\?\[\]\{\}]"#,
                          replacementTemplate: "")
        ?? "_"
        
        return sanitized.isEmpty ? "_" : sanitized
        
    }
    
}
