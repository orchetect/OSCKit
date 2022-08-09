//
//  OSCObject Static Constructors.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCObject where Self == OSCMessage {
    /// OSC Message.
    @inlinable
    public static func message(
        address: String,
        values: OSCValues = []
    ) -> Self {
        OSCMessage(
            address: OSCAddressPattern(address),
            values: values
        )
    }
    
    /// OSC Message.
    @inlinable
    public static func message(
        address: OSCAddressPattern,
        values: OSCValues = []
    ) -> Self {
        OSCMessage(
            address: address,
            values: values
        )
    }
}

extension OSCObject where Self == OSCBundle {
    /// OSC Bundle.
    @inlinable
    public static func bundle(
        elements: [any OSCObject],
        timeTag: OSCTimeTag? = nil
    ) -> Self {
        OSCBundle(
            elements: elements,
            timeTag: timeTag
        )
    }
}
