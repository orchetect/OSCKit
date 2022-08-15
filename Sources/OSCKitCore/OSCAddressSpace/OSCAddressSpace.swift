//
//  OSCAddressSpace.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

/// OSC Address Space.
/// Populated with a local address tree by registering OSC methods.
/// This object is typically instanced once and stored globally in an application.
/// Received OSC messages can have their address patterns passed to the `matches(_:)` method which will return all OSC Methods that match.
///
/// An OSC Method is defined as being the last path component in the address. OSC Methods are the potential destinations of OSC messages received by the OSC server and correspond to each of the points of control that the application makes available.
///
/// `methodname` is the method name in the following address examples:
///
///     /methodname
///     /container1/container2/methodname
///
///  Any other path components besides the last are referred to as _containers_.
///
///  A container may also be a method. Simply register it the same way as other methods.
///
public class OSCAddressSpace {
    var root: Node = .init("")
    
    public init() { }
}

// MARK: - Address Registration

extension OSCAddressSpace {
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
    public func register(localAddress address: String) -> MethodID {
        register(localAddress: OSCAddressPattern(address).pathComponents)
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
    public func register(
        localAddress pathComponents: some BidirectionalCollection<some StringProtocol>
    ) -> MethodID {
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
    public func unregister(localAddress address: String) -> Bool {
        removeMethodNode(
            path: OSCAddressPattern(address).pathComponents,
            forceNonEmptyMethodRemoval: false
        )
    }
    
    /// Unregister an OSC address.
    @discardableResult
    public func unregister(
        localAddress pathComponents: some BidirectionalCollection<some StringProtocol>
    ) -> Bool {
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

extension OSCAddressSpace {
    /// Returns all OSC address nodes matching the address pattern.
    ///
    /// An OSC Method is defined as being the last path component in the address. OSC Methods are the potential destinations of OSC messages received by the OSC server and correspond to each of the points of control that the application makes available.
    ///
    /// `methodname` is the method name in the following address examples:
    ///
    ///     /methodname
    ///     /container1/container2/methodname
    ///
    ///  Any other path components besides the last are referred to as _containers_.
    ///
    ///  A container may also be a method. Simply register it the same way as other methods.
    ///
    public func methods(matching address: OSCAddressPattern) -> [MethodID] {
        let patternComponents = address.components
        guard !patternComponents.isEmpty else { return [] }
        
        var nodes: [Node] = [root]
        var idx = 0
        repeat {
            nodes = nodes.reduce(into: [Node]()) {
                let m = findPatternMatches(node: $1, pattern: patternComponents[idx])
                $0.append(contentsOf: m)
            }
            idx += 1
        } while idx < patternComponents.count
        
        return nodes.map { $0.id }
    }
}
