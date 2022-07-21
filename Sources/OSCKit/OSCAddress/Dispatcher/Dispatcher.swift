//
//  Dispatcher.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

extension OSCAddress {
    
    /// OSC Address Dispatcher.
    /// Populated with an address tree by registering OSC methods.
    /// The `matches(_:)` method returns all methods that match a given address.
    ///
    /// An OSC _method_ is defined as being the last path component in the address.
    ///
    /// `methodname` is the method name in the following address examples:
    ///
    ///     /methodname
    ///     /container1/container2/methodname
    ///
    ///  Any other path components besides the last are referred to as _containers_.
    ///
    public class Dispatcher {
        
        var root: Node = Node("--ROOT--")
        
        public init() { }
        
    }
    
}

// MARK: - Address Registration

extension OSCAddress.Dispatcher {
    
    /// Register an OSC address.
    /// Returns a unique identifier assigned to the address's method.
    /// Replaces existing reference if one exists for that method already.
    ///
    /// An OSC _method_ is defined as being the last path component in the address.
    ///
    /// `methodname` is the method name in the following address examples:
    ///
    ///     /methodname
    ///     /container1/container2/methodname
    ///
    ///  Any other path components besides the last are referred to as _containers_.
    ///
    public func register(_ address: OSCAddress) -> MethodID? {
        
        let path = address.pathComponents
        
        guard !path.isEmpty else { return nil }
        
        return createMethodNode(path: path,
                                replaceExisting: true)
        .id
        
    }
    
    /// Unregister an OSC address.
    @discardableResult
    public func unregister(_ address: OSCAddress) -> Bool {
        
        removeMethodNode(path: address.pathComponents,
                         forceNonEmptyMethodRemoval: false)
        
    }
    
}

// MARK: - Matches

extension OSCAddress.Dispatcher {
    
    /// Returns all OSC address nodes matching the address pattern.
    ///
    /// An OSC _method_ is defined as being the last path component in the address.
    ///
    /// `methodname` is the method name in the following address examples:
    ///
    ///     /methodname
    ///     /container1/container2/methodname
    ///
    ///  Any other path components besides the last are referred to as _containers_.
    ///
    public func methods(matching address: OSCAddress) -> [MethodID] {
        
        let pattern = address.pattern
        guard !pattern.isEmpty else { return [] }
        
        var nodes: [Node] = [root]
        var idx = 0
        repeat {
            nodes = nodes.reduce(into: [Node]()) {
                let m = findPatternMatches(node: $1, pattern: pattern[idx])
                $0.append(contentsOf: m)
            }
            idx += 1
        } while idx < pattern.count
        
        return nodes.map { $0.id }
        
    }
    
}
