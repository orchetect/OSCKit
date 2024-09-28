//
//  OSCAddressSpace.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC address space populated with a local address tree by registering OSC methods, offering
/// methods to match and dispatch against received OSC address patterns.
///
/// This object is typically instanced once and stored globally in an application.
///
/// Received OSC messages can have their address patterns passed to the ``methods(matching:)``
/// method which will return all OSC Methods that match.
///
/// An OSC Method is defined as being the last path component in the address. OSC Methods are the
/// potential destinations of OSC messages received by the OSC server and correspond to each of the
/// points of control that the application makes available.
///
/// The `methodname` path component is the method name in the following address examples:
///
///     /methodname
///     /container1/container2/methodname
///
///  Any other path components besides the last are referred to as _containers_.
///
///  A container may also be a method. Simply register it the same way as other methods.
///
public final class OSCAddressSpace {
    var root: Node = .rootNodeFactory()
    
    public init() { }
}

// MARK: - Address Registration

extension OSCAddressSpace {
    /// Register an OSC address.
    /// Returns a unique identifier assigned to the address's method.
    /// Replaces existing reference if one exists for that method already.
    /// Optionally supply a closure that will be invoked when calling ``methods(matching:)``.
    ///
    /// - Remark: An OSC _method_ is defined as being the last path component in the address.
    ///
    /// `methodname` is the method name in the following address examples:
    ///
    ///     /methodname
    ///     /container1/container2/methodname
    ///
    ///  Any other path components besides the last are referred to as _containers_.
    ///
    @discardableResult
    public func register(
        localAddress address: String,
        block: MethodBlock? = nil
    ) -> MethodID {
        register(localAddress: OSCAddressPattern(address).pathComponents, block: block)
    }
    
    /// Register an OSC address.
    /// Returns a unique identifier assigned to the address's method.
    /// Replaces existing reference if one exists for that method already.
    /// Optionally supply a closure that will be invoked when calling ``methods(matching:)``.
    ///
    /// - Remark: An OSC _method_ is defined as being the last path component in the address.
    ///
    /// `methodname` is the method name in the following address examples:
    ///
    ///     /methodname
    ///     /container1/container2/methodname
    ///
    ///  Any other path components besides the last are referred to as _containers_.
    ///
    @discardableResult
    public func register<S>(
        localAddress pathComponents: S,
        block: MethodBlock? = nil
    ) -> MethodID where S: BidirectionalCollection, S.Element: StringProtocol {
        guard !pathComponents.isEmpty else {
            // instead of returning nil, return a bogus ID
            assertionFailure(
                "Local address is empty and cannot be registered. Returning random method ID as failsafe that will never be matched."
            )
            return MethodID()
        }
        
        return createMethodNode(
            path: pathComponents,
            block: block
        )
        .id
    }
    
    /// Unregister an OSC address.
    ///
    /// - Returns: `true` if the operation was successful, `false` if unsuccessful or the path does
    ///   not exist.
    @discardableResult
    public func unregister(localAddress address: String) -> Bool {
        removeMethodNode(
            path: OSCAddressPattern(address).pathComponents
        )
    }
    
    // TODO: add unregister(methodID: MethodID) method
    
    /// Unregister an OSC method by supplying its local address.
    ///
    /// - Returns: `true` if the operation was successful, `false` if unsuccessful or the path does
    ///   not exist.
    @discardableResult
    public func unregister<S>(
        localAddress pathComponents: S
    ) -> Bool where S: BidirectionalCollection, S.Element: StringProtocol {
        removeMethodNode(
            path: pathComponents
        )
    }
    
    /// Unregister all registered OSC methods.
    public func unregisterAll() {
        root = Node.rootNodeFactory()
    }
}

// MARK: - Matches

extension OSCAddressSpace {
    /// Returns all OSC address nodes matching the address pattern.
    ///
    /// - Note: This will not automatically execute the closure blocks that may be associated with
    ///   the methods. To execute the closures, invoke the ``dispatch(_:on:)`` function instead.
    ///
    /// - Remark: An OSC Method is defined as being the last path component in the address. OSC
    ///   Methods are the potential destinations of OSC messages received by the OSC server and
    ///   correspond to each of the points of control that the application makes available.
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
        methodNodes(patternMatching: address)
            .map { $0.id }
    }
}

// MARK: - Dispatch

extension OSCAddressSpace {
    /// Executes the closure blocks (and passes the OSC message values to them) for all local OSC
    /// address nodes matching the address pattern in the OSC message.
    /// If a `queue` is supplied, blocks will be dispatched on the `queue` with its default QoS.
    /// If no `queue` is supplied, the closures are dispatched synchronously on the current queue.
    ///
    /// - Remark: An OSC Method is defined as being the last path component in the address. OSC
    ///   Methods are the potential destinations of OSC messages received by the OSC server and
    ///   correspond to each of the points of control that the application makes available.
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
    /// - Returns: The OSC method IDs that were matched (the same as calling
    /// ``methods(matching:)``).
    ///
    @discardableResult
    public func dispatch(
        _ message: OSCMessage,
        on queue: DispatchQueue? = nil
    ) -> [MethodID] {
        let nodes = methodNodes(patternMatching: message.addressPattern)
        
        func runBlocks() {
            nodes.forEach { $0.block?(message.values) }
        }
        
        if let queue {
            queue.async { runBlocks() }
        } else {
            runBlocks()
        }
        
        return nodes
            .map { $0.id }
    }
}
