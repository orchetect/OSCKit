//
//  OSCMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

// MARK: - OSCMessage

/// OSC Message.
public struct OSCMessage: OSCObject {
    
    // MARK: - Properties
    
    /// OSC message address.
    public let address: OSCAddress
    
    /// OSC values contained within the message.
    public let values: [OSCMessageValue]
    
    public let rawData: Data
    
    // MARK: - init
    
    /// Create an OSC message from a raw `String` address and zero or more OSC values.
    /// The address string will be converted to an ASCII string, lossily converting or removing invalid non-ASCII characters if necessary.
    @_disfavoredOverload
    @inlinable
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


// MARK: - Equatable, Hashable

extension OSCMessage: Equatable, Hashable {
    
    // implementation is automatically synthesized by Swift
    
}


// MARK: - CustomStringConvertible

extension OSCMessage: CustomStringConvertible {
    
    public var description: String {
        
        values.count < 1
        ? "OSCMessage(address: \"\(address)\")"
        : "OSCMessage(address: \"\(address)\", values: [\(values.mapDebugString(withLabel: true))])"
        
    }
    
    /// Same as `description` but values are separated with new-line characters and indented.
    public var descriptionPretty: String {
        
        values.count < 1
        ? "OSCMessage(address: \"\(address)\")"
        : "OSCMessage(address: \"\(address)\") Values:\n  \(values.mapDebugString(withLabel: true, separator: "\n  "))"
            .trimmed
        
    }
    
}


// MARK: - Header

extension OSCMessage {
    
    /// Constant caching an OSCMessage header.
    public static let header: Data = "/".toData(using: .nonLossyASCII)!
    
}

extension Data {
    
    /// A fast test if Data() appears tor be an OSC message.
    /// (Note: Does NOT do extensive checks to ensure message isn't malformed.)
    @inlinable
    public var appearsToBeOSCMessage: Bool {
        
        // it's possible an OSC address won't start with "/", but it should!
        self.starts(with: OSCMessage.header)
        
    }
    
}
