//
//  OSCPacket Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data {
    /// Test if data appears to be an OSC bundle or OSC message. (Basic validation)
    ///
    /// - Returns: An ``OSCPacketType`` case if validation succeeds.
    @inlinable
    package var oscPacketType: OSCPacketType? {
        if appearsToBeOSCBundle {
            return .bundle
        } else if appearsToBeOSCMessage {
            return .message
        }
        
        return nil
    }
}
