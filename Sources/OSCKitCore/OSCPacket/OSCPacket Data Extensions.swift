//
//  OSCPacket Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import protocol Foundation.DataProtocol
#else
import protocol FoundationEssentials.DataProtocol
#endif

extension DataProtocol {
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
