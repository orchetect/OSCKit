//
//  OSCObject Static Constructors.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCObject {
    /// OSC Message.
    @inlinable
    public static func message(
        address: OSCAddress,
        values: [any OSCValue] = []
    ) -> OSCMessage {
        OSCMessage(
            address: address,
            values: values
        )
    }
    
    /// OSC Bundle.
    @inlinable
    public static func bundle(
        elements: [any OSCObject],
        timeTag: OSCTimeTag? = nil
    ) -> OSCBundle {
        OSCBundle(
            elements: elements,
            timeTag: timeTag
        )
    }
}
