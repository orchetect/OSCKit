//
//  OSCPacket Properties.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCPacket {
    /// Returns an enum case describing the OSC packet type.
    public var packetType: OSCPacketType {
        switch self {
        case .message: .message
        case .bundle: .bundle
        }
    }
    
    /// A convenience to access all messages within the packet.
    ///
    /// If the packet is an OSC message, an array of one message will be returned.
    ///
    /// If the packet is an OSC bundle, all messages contained within it will be returned, preserving order.
    public var messages: [OSCMessage] {
        switch self {
        case let .bundle(bundle):
            bundle.elements.reduce(into: []) { base, element in
                base.append(contentsOf: element.messages)
            }
        case let .message(message):
            [message]
        }
    }
}
