//
//  OSCDispatcher.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

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
public class OSCDispatcher {
    var root: Node = .init("")
    
    public init() { }
}

// MARK: - Address Registration

extension OSCDispatcher {
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
    public func register(address: OSCAddress) -> MethodID {
        register(address: address.pathComponents)
    }
    
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
    public func register<S>(address pathComponents: S) -> MethodID
        where S: BidirectionalCollection,
        S.Element: StringProtocol
    {
        guard !pathComponents.isEmpty else {
            // instead of returning nil, return a bogus ID
            return MethodID()
        }
        
        return createMethodNode(
            path: pathComponents,
            replaceExisting: true
        )
        .id
    }
    
    /// Unregister an OSC address.
    @discardableResult
    public func unregister(address: OSCAddress) -> Bool {
        removeMethodNode(
            path: address.pathComponents,
            forceNonEmptyMethodRemoval: false
        )
    }
    
    /// Unregister an OSC address.
    @discardableResult
    public func unregister<S>(address pathComponents: S) -> Bool
        where S: BidirectionalCollection,
        S.Element: StringProtocol
    {
        removeMethodNode(
            path: pathComponents,
            forceNonEmptyMethodRemoval: false
        )
    }
    
    /// Unregister all OSC addresses.
    public func unregisterAll() {
        root = Node("")
    }
}

// MARK: - Matches

extension OSCDispatcher {
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
