//
//  OSCPayload init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCPayload {
    /// OSC Message.
    public init(_ message: OSCMessage) {
        self = .message(message)
    }
    
    /// OSC Bundle.
    public init(_ bundle: OSCBundle) {
        self = .bundle(bundle)
    }
}

extension OSCPayload {
    /// OSC Message.
    @inlinable
    public static func message(
        address: OSCAddress,
        values: [OSCMessage.Value] = []
    ) -> Self {
        let msg = OSCMessage(
            address: address,
            values: values
        )
        
        return .message(msg)
    }
    
    /// OSC Bundle.
    @inlinable
    public static func bundle(
        elements: [OSCPayload],
        timeTag: OSCTimeTag? = nil
    ) -> Self {
        .bundle(
            OSCBundle(
                elements: elements,
                timeTag: timeTag
            )
        )
    }
}
