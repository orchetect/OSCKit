//
//  OSCObject Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension Data {
    /// Parses raw data and returns valid OSC objects if data is successfully parsed as OSC.
    ///
    /// Returns `nil` if not an OSC data packet. Throws an error if the data is malformed.
    @inlinable
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
    /// - Returns: An `OSCObjectType` case if validation succeeds. `nil` if neither.
    @inlinable
    public var appearsToBeOSC: OSCObjectType? {
        if appearsToBeOSCBundle {
            return .bundle
        } else if appearsToBeOSCMessage {
            return .message
        }
        
        return nil
    }
}
