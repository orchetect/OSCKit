//
//  OSCObject Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension Data {
    
    /// Parses raw data and returns valid OSC objects if data is successfully parsed as OSC.
    ///
    /// Returns `nil` if not an OSC data packet. Throws an error if the data is malformed.
    @inlinable
    func parseOSC() throws -> OSCPayload? {
        
        if appearsToBeOSCBundle {
            return .bundle(try OSCBundle(from: self))
        } else if appearsToBeOSCMessage {
            return .message(try OSCMessage(from: self))
        }
        
        return nil
        
    }
    
}

public extension Data {
    
    /// Test if data appears to be an OSC bundle or OSC message. (Basic validation)
    ///
    /// - Returns: An `OSCObjectType` case if validation succeeds. `nil` if neither.
    @inlinable
    var appearsToBeOSC: OSCObjectType? {
        
        if appearsToBeOSCBundle {
            return .bundle
        } else if appearsToBeOSCMessage {
            return .message
        }
        
        return nil
        
    }
    
}