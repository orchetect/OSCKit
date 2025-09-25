//
//  OSCPacket Static.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Static Constructors

// NOTE: Overloads that take variadic values were tested,
// however for code consistency and proper indentation, it is
// undesirable to have variadic parameters.

extension OSCPacket {
    /// Construct a new OSC bundle.
    public static func bundle(
        timeTag: OSCTimeTag? = nil,
        _ elements: [OSCPacket] = []
    ) -> Self {
        let bundle = OSCBundle(
            timeTag: timeTag,
            elements
        )
        return .bundle(bundle)
    }
    
    /// Construct a new OSC message.
    public static func message(
        _ addressPattern: String,
        values: OSCValues = []
    ) -> Self {
        let message = OSCMessage(
            OSCAddressPattern(addressPattern),
            values: values
        )
        return .message(message)
    }
    
    /// Construct a new OSC message.
    public static func message(
        _ addressPattern: OSCAddressPattern,
        values: OSCValues = []
    ) -> Self {
        let message = OSCMessage(
            addressPattern,
            values: values
        )
        return .message(message)
    }
}
