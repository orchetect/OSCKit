//
//  OSCAddressSpace Methods.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Address Registration

extension OSCAddressSpace {
    /// A closure executed when an inbound OSC message address pattern matches a local OSC method.
    public typealias MethodBlock = @Sendable (_ values: OSCValues, _ host: String, _ port: UInt16) async -> Void
    
    /// Register an OSC address.
    /// Returns a unique identifier assigned to the address's method.
    /// Replaces existing reference if one exists for that method already.
    /// Optionally supply a closure that will be invoked when calling ``dispatch(message:host:port:)``.
    ///
    /// > OSC Methods:
    /// >
    /// > An OSC Method is defined as being the last path component in the address. OSC Methods are the
    /// > potential destinations of OSC messages received by the OSC server and correspond to each of the
    /// > points of control that the application makes available.
    /// >
    /// > The `methodname` path component is the method name in the following address examples:
    /// >
    /// >     /methodname
    /// >     /container1/container2/methodname
    /// >
    /// > Any other path components besides the last are referred to as _containers_.
    /// >
    /// > A container may also be a method. Simply register it the same way as other methods.
    @discardableResult
    public func register(
        localAddress address: String,
        block: MethodBlock? = nil
    ) -> MethodID where MethodID == UUID {
        register(localAddress: OSCAddressPattern(address).pathComponents, block: block)
    }
    
    /// Register an OSC address, associating a custom unique identifier assigned to the address's method.
    /// Replaces existing reference if one exists for that method already.
    /// Optionally supply a closure that will be invoked when calling ``dispatch(message:host:port:)``.
    ///
    /// > OSC Methods:
    /// >
    /// > An OSC Method is defined as being the last path component in the address. OSC Methods are the
    /// > potential destinations of OSC messages received by the OSC server and correspond to each of the
    /// > points of control that the application makes available.
    /// >
    /// > The `methodname` path component is the method name in the following address examples:
    /// >
    /// >     /methodname
    /// >     /container1/container2/methodname
    /// >
    /// > Any other path components besides the last are referred to as _containers_.
    /// >
    /// > A container may also be a method. Simply register it the same way as other methods.
    public func register(
        localAddress address: String,
        id: MethodID,
        block: MethodBlock? = nil
    ) {
        register(localAddress: OSCAddressPattern(address).pathComponents, id: id, block: block)
    }
    
    /// Register an OSC address.
    /// Returns a unique identifier assigned to the address's method.
    /// Replaces existing reference if one exists for that method already.
    /// Optionally supply a closure that will be invoked when calling ``dispatch(message:host:port:)``.
    ///
    /// > OSC Methods:
    /// >
    /// > An OSC Method is defined as being the last path component in the address. OSC Methods are the
    /// > potential destinations of OSC messages received by the OSC server and correspond to each of the
    /// > points of control that the application makes available.
    /// >
    /// > The `methodname` path component is the method name in the following address examples:
    /// >
    /// >     /methodname
    /// >     /container1/container2/methodname
    /// >
    /// > Any other path components besides the last are referred to as _containers_.
    /// >
    /// > A container may also be a method. Simply register it the same way as other methods.
    @discardableResult
    public func register<S>(
        localAddress pathComponents: S,
        block: MethodBlock? = nil
    ) -> MethodID where MethodID == UUID, S: BidirectionalCollection, S.Element: StringProtocol {
        guard !pathComponents.isEmpty else {
            // instead of returning nil, return a bogus ID
            assertionFailure(
                "Local address is empty and cannot be registered. Returning random method ID as failsafe that will never be matched."
            )
            return MethodID()
        }
        
        guard let node = createMethodNode(
            path: pathComponents,
            id: MethodID(),
            block: block
        ),
            case let .method(id: returnedID, block: _) = node.nodeType
        else {
            assertionFailure(
                "Local address failed to register. Returning random method ID as failsafe that will never be matched."
            )
            return MethodID()
        }

        return returnedID
    }
    
    /// Register an OSC address, associating a custom unique identifier assigned to the address's method.
    /// Replaces existing reference if one exists for that method already.
    /// Optionally supply a closure that will be invoked when calling ``dispatch(message:host:port:)``.
    ///
    /// > OSC Methods:
    /// >
    /// > An OSC Method is defined as being the last path component in the address. OSC Methods are the
    /// > potential destinations of OSC messages received by the OSC server and correspond to each of the
    /// > points of control that the application makes available.
    /// >
    /// > The `methodname` path component is the method name in the following address examples:
    /// >
    /// >     /methodname
    /// >     /container1/container2/methodname
    /// >
    /// > Any other path components besides the last are referred to as _containers_.
    /// >
    /// > A container may also be a method. Simply register it the same way as other methods.
    public func register<S>(
        localAddress pathComponents: S,
        id: MethodID,
        block: MethodBlock? = nil
    ) where S: BidirectionalCollection, S.Element: StringProtocol {
        guard !pathComponents.isEmpty else {
            // instead of returning nil, return a bogus ID
            assertionFailure(
                "Local address is empty and cannot be registered."
            )
            return
        }
        
        _ = createMethodNode(
            path: pathComponents,
            id: id,
            block: block
        )
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
    
    /// Unregister an OSC address with the given method ID.
    ///
    /// - Returns: `true` if the operation was successful, `false` if unsuccessful or the method ID does
    ///   not exist.
    @discardableResult
    public func unregister(methodID: MethodID) -> Bool {
        removeMethodNode(
            methodID: methodID
        )
    }
    
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
        root.removeAll()
    }
}

// MARK: - Matches

extension OSCAddressSpace {
    /// Returns all OSC address nodes matching the address pattern.
    ///
    /// > Note:
    /// >
    /// > This will not automatically execute the closure blocks that may be associated with
    /// > the methods. To execute the closures, invoke the ``dispatch(message:host:port:)`` function
    /// > instead.
    ///
    /// > OSC Methods:
    /// >
    /// > An OSC Method is defined as being the last path component in the address. OSC Methods are the
    /// > potential destinations of OSC messages received by the OSC server and correspond to each of the
    /// > points of control that the application makes available.
    /// >
    /// > The `methodname` path component is the method name in the following address examples:
    /// >
    /// >     /methodname
    /// >     /container1/container2/methodname
    /// >
    /// > Any other path components besides the last are referred to as _containers_.
    /// >
    /// > A container may also be a method. Simply register it the same way as other methods.
    public func methods(matching address: OSCAddressPattern) -> [MethodID] {
        methodNodes(patternMatching: address)
            .compactMap {
                guard case let .method(id: id, block: _) = $0.nodeType else { return nil }
                return id
            }
    }
}

// MARK: - Dispatch

extension OSCAddressSpace {
    /// Executes the closure blocks (and passes the OSC message values to them) for all local OSC
    /// address nodes matching the address pattern in the OSC message.
    ///
    /// > OSC Methods:
    /// >
    /// > An OSC Method is defined as being the last path component in the address. OSC Methods are the
    /// > potential destinations of OSC messages received by the OSC server and correspond to each of the
    /// > points of control that the application makes available.
    /// >
    /// > The `methodname` path component is the method name in the following address examples:
    /// >
    /// >     /methodname
    /// >     /container1/container2/methodname
    /// >
    /// > Any other path components besides the last are referred to as _containers_.
    /// >
    /// > A container may also be a method. Simply register it the same way as other methods.
    ///
    /// - Returns: The OSC method IDs that were matched (the same as calling
    ///   ``methods(matching:)``).
    @discardableResult
    public func dispatch(
        message: OSCMessage,
        host: String,
        port: UInt16
    ) -> [MethodID] {
        let nodes = methodNodes(patternMatching: message.addressPattern)
        
        for node in nodes {
            guard case let .method(id: _, block: block) = node.nodeType, let block else { continue }
            Task { await block(message.values, host, port) }
        }
        
        return nodes
            .compactMap {
                guard case let .method(id: id, block: _) = $0.nodeType else { return nil }
                return id
            }
    }
}
