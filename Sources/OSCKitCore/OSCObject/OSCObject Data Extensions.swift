//
//  OSCObject Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data {
    /// Parses raw data and returns valid OSC objects if data is successfully parsed as OSC.
    ///
    /// - Throws: An error is thrown if data appears to be an OSC bundle or message but is
    /// malformed.
    ///
    /// Errors thrown will typically be a case of ``OSCDecodeError`` but other errors may be thrown.
    ///
    /// - Returns: Decoded ``OSCObject``, or `nil` if not an OSC data packet.
    public func parseOSC() throws -> (any OSCObject)? {
        if appearsToBeOSCBundle {
            return try OSCBundle(from: self)
        } else if appearsToBeOSCMessage {
            return try OSCMessage(from: self)
        }
        
        return nil
    }
    
    /// Test if data appears to be an OSC bundle or OSC message. (Basic validation)
    ///
    /// - Returns: An ``OSCObjectType`` case if validation succeeds.
    public var oscObjectType: OSCObjectType? {
        if appearsToBeOSCBundle {
            return .bundle
        } else if appearsToBeOSCMessage {
            return .message
        }
        
        return nil
    }
}
