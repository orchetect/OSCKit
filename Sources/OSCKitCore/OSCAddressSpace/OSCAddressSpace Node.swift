//
//  OSCAddressSpace Node.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCAddressSpace {
    /// Internal:
    /// Represents an OSC address space container or method.
    final class Node {
        var nodeType: NodeType
        
        let id = MethodID()
        
        let name: String
        
        var block: MethodBlock?
        
        var children: [Node] = []
        
        required init(
            name: any StringProtocol,
            type nodeType: NodeType,
            block: MethodBlock? = nil
        ) {
            self.name = String(name)
            self.block = block
            self.nodeType = nodeType
        }
        
        /// Returns `true` if node is a method.
        /// (Note that a method can also be a container if it has children.)
        var isMethod: Bool {
            nodeType == .method
        }
    }
}

// MARK: - Equatable

extension OSCAddressSpace.Node: Equatable {
    static func == (
        lhs: OSCAddressSpace.Node,
        rhs: OSCAddressSpace.Node
    ) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension OSCAddressSpace.Node: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Methods

extension OSCAddressSpace.Node {
    /// Internal:
    /// Returns a new root node.
    static func rootNodeFactory() -> Self {
        .init(name: "", type: .container)
    }
    
    /// Internal:
    /// Converts the node to a container.
    /// Children remain unaffected.
    func convertToContainer() {
        nodeType = .container
        block = nil
    }
    
    /// Internal:
    /// Converts the node to a method.
    /// Children remain unaffected.
    func convertToMethod(
        block: OSCAddressSpace.MethodBlock? = nil
    ) {
        nodeType = .method
        self.block = block
    }
    
    /// Internal:
    /// Filters ``children`` that match the given path component OSC address pattern.
    func children(
        matching pattern: OSCAddressPattern.Component
    ) -> [OSCAddressSpace.Node] {
        children.filter { pattern.evaluate(matching: $0.name) }
    }
    
    /// Internal:
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

// MARK: - NodeType

extension OSCAddressSpace.Node {
    /// Node type.
    /// A container does not carry a method ID since it is not a method.
    /// A container may become a method if it is also registered as one.
    enum NodeType: Equatable, Hashable {
        case container
        case method
    }
}
