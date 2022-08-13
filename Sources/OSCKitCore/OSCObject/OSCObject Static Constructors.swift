//
//  OSCObject Static Constructors.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

// MARK: - OSCMessage

extension OSCObject where Self == OSCMessage {
    /// OSC Message.
    @inlinable
    public static func message(
        _ addressPattern: String,
        values: OSCValues = []
    ) -> Self {
        OSCMessage(
            OSCAddressPattern(addressPattern),
            values: values
        )
    }
    
    /// OSC Message.
    @inlinable
    public static func message(
        _ addressPattern: OSCAddressPattern,
        values: OSCValues = []
    ) -> Self {
        OSCMessage(
            addressPattern,
            values: values
        )
    }
    
    // MARK: - Variadic Values
    
    /// OSC Message.
    @inlinable
    public static func message(
        _ addressPattern: String,
        values: AnyOSCValue...
    ) -> Self {
        OSCMessage(
            OSCAddressPattern(addressPattern),
            values: values
        )
    }
    
    /// OSC Message.
    @inlinable
    public static func message(
        _ addressPattern: OSCAddressPattern,
        values: AnyOSCValue...
    ) -> Self {
        OSCMessage(
            addressPattern,
            values: values
        )
    }
}

// MARK: - OSCBundle

extension OSCObject where Self == OSCBundle {
    /// OSC Bundle.
    @inlinable
    public static func bundle(
        timeTag: OSCTimeTag? = nil,
        _ elements: [any OSCObject]
    ) -> Self {
        OSCBundle(
            timeTag: timeTag,
            elements
        )
    }
    
    // MARK: - Variadic Values
    
    /// OSC Bundle.
    @inlinable
    public static func bundle(
        timeTag: OSCTimeTag? = nil,
        _ elements: (any OSCObject)...
    ) -> Self {
        OSCBundle(
            timeTag: timeTag,
            elements
        )
    }
}
