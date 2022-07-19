//
//  OSCMessage init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

extension OSCMessage {
    
    /// Create an OSC message from a raw `String` address and zero or more OSC values.
    /// The address string will be converted to an ASCII string, lossily converting or removing invalid non-ASCII characters if necessary.
    @inlinable @_disfavoredOverload
    public init(address: String,
                values: [OSCMessageValue] = []) {
        
        let oscAddress = OSCAddress(address.asciiStringLossy)
        self.address = oscAddress
        self.values = values
        self.rawData = Self.generateRawData(address: oscAddress,
                                            values: values)
        
    }
    
    /// Create an OSC message from a raw `ASCIIString` address and zero or more OSC values.
    @inlinable @_disfavoredOverload
    public init(address: ASCIIString,
                values: [OSCMessageValue] = []) {
        
        let oscAddress = OSCAddress(address)
        self.address = oscAddress
        self.values = values
        self.rawData = Self.generateRawData(address: oscAddress,
                                            values: values)
        
    }
    
    /// Create an OSC message from an `OSCAddress` and zero or more OSC values.
    @inlinable
    public init(address: OSCAddress,
                values: [OSCMessageValue] = []) {
        
        self.address = address
        self.values = values
        self.rawData = Self.generateRawData(address: address,
                                            values: values)
        
    }
    
    /// Create an OSC message from OSC address path components and zero or more OSC values.
    /// Empty path components is equivalent to the address of "/".
    @inlinable
    public init(address pathComponents: [String],
                values: [OSCMessageValue] = []) {
        
        self.address = OSCAddress(pathComponents: pathComponents)
        self.values = values
        self.rawData = Self.generateRawData(address: address,
                                            values: values)
        
    }
    
    /// Create an OSC message from OSC address path components and zero or more OSC values.
    /// Empty path components is equivalent to the address of "/".
    @inlinable @_disfavoredOverload
    public init(address pathComponents: [ASCIIString],
                values: [OSCMessageValue] = []) {
        
        self.address = OSCAddress(pathComponents: pathComponents)
        self.values = values
        self.rawData = Self.generateRawData(address: address,
                                            values: values)
        
    }
    
}
