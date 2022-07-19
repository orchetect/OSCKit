//
//  OSCObject.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

// MARK: - OSCObject

/// Protocol applied to OSC data objects
public protocol OSCObject {
    
    /// Returns raw OSC packet data constructed from the struct's properties.
    var rawData: Data { get }
    
    /// Initialize by parsing raw OSC packet data bytes.
    init(from rawData: Data) throws
    
}


// MARK: - appearsToBeOSC

public extension Data {
    
    /// Test if `Data` appears to be an OSC bundle or OSC message. (Basic validation)
    ///
    /// - Returns: An `OSCObjectType` case if validation succeeds. `nil` if neither.
    @inlinable var appearsToBeOSC: OSCObjectType? {
        
        if appearsToBeOSCBundle {
            return .bundle
        } else if appearsToBeOSCMessage {
            return .message
        }
        
        return nil
        
    }
    
}


// MARK: - OSCObjectType

/// Enum describing an OSC message type.
public enum OSCObjectType: Equatable {
    
    case message
    case bundle
    
}


// MARK: - Data.parseOSC

public extension Data {
    
    /// Parses raw data and returns valid OSC objects if data is successfully parsed as OSC.
    ///
    /// Returns `nil` if neither.
    @inlinable func parseOSC() throws -> OSCPayload? {
        
        if appearsToBeOSCBundle {
            return .bundle(try OSCBundle(from: self))
        } else if appearsToBeOSCMessage {
            return .message(try OSCMessage(from: self))
        }
        
        return nil
        
    }
    
}

