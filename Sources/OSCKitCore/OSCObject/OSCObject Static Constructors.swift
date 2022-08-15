//
//  OSCObject Static Constructors.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// NOTE: Overloads that take variadic values were tested,
// however for code consistency and proper indentation, it is
// undesirable to have variadic parameters.

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
}

// MARK: - OSCBundle

extension OSCObject where Self == OSCBundle {
    /// OSC Bundle.
    @inlinable
    public static func bundle(
        timeTag: OSCTimeTag? = nil,
        _ elements: [any OSCObject] = []
    ) -> Self {
        OSCBundle(
            timeTag: timeTag,
            elements
        )
    }
}
