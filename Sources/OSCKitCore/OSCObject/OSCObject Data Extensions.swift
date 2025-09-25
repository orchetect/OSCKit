//
//  OSCObject Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data {
    /// Parses raw data and returns valid OSC objects if data is successfully parsed as OSC.
    ///
    /// - Throws: An error is thrown if data appears to be an OSC bundle or message but is
    ///   malformed. Errors thrown will typically be a case of ``OSCDecodeError`` but other
    ///   errors may be thrown.
    ///
    /// - Returns: Decoded ``OSCObject``, or `nil` if not an OSC data packet.
    package func parseOSCPacket() throws -> OSCPacket? {
        if appearsToBeOSCBundle {
            let bundle = try OSCBundle(from: self)
            return .bundle(bundle)
        } else if appearsToBeOSCMessage {
            let message = try OSCMessage(from: self)
            return .message(message)
        }
        
        return nil
    }
    
    /// Test if data appears to be an OSC bundle or OSC message. (Basic validation)
    ///
    /// - Returns: An ``OSCPacketType`` case if validation succeeds.
    package var oscPacketType: OSCPacketType? {
        if appearsToBeOSCBundle {
            return .bundle
        } else if appearsToBeOSCMessage {
            return .message
        }
        
        return nil
    }
}
