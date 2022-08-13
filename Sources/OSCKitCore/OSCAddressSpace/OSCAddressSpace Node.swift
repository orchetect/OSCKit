//
//  OSCAddressSpace Node.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

extension OSCAddressSpace {
    /// Represents an OSC address space container or method.
    class Node {
        public let id = MethodID()
        
        public let name: String
        
        public var children: [Node] = []
        
        public init(_ name: any StringProtocol) {
            // sanitize name
            self.name = String(name)
        }
    }
}

extension OSCAddressSpace.Node: Equatable {
    static func == (
        lhs: OSCAddressSpace.Node,
        rhs: OSCAddressSpace.Node
    ) -> Bool {
        lhs.id == rhs.id
    }
}

extension OSCAddressSpace.Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension OSCAddressSpace.Node {
    /// Validates an OSC address space node name b invalid characters.
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
    static func validate(
        name: any StringProtocol,
        strict: Bool = false
    ) -> Bool {
        guard !name.isEmpty else { return false }
        
        // if the name results in a pattern other than a single contiguous string,
        // then it's invalid
        let tokens = OSCAddressPattern.Component(string: String(name)).tokens
        guard tokens.count == 1,
              let singleToken = tokens.first,
              case let .literal(str) = singleToken
        else { return false }
        
        // forward slash is illegal since it is used to separate address path components
        guard !str.contains("/") else { return false }
        
        // some characters are still possible to be used but only cause invalidation
        // with opt-in strict validation
        if strict {
            guard !str.contains(anyCharacters: " #}]")
            else { return false }
        }
        
        return true
    }
}
