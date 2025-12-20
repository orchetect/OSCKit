//
//  OSCAddressSpace.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
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
public actor OSCAddressSpace {
    var root: Node = .rootNodeFactory()
    
    public init() { }
}
