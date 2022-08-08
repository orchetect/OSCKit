//
//  OSCMessage init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

extension OSCMessage {
    /// Create an OSC message from a raw `String` address and zero or more OSC values.
    /// The address string will be converted to an ASCII string, lossily converting or removing invalid non-ASCII characters if necessary.
    @inlinable @_disfavoredOverload
    public init(
        address: String,
        values: [any OSCValue] = []
    ) {
        self.address = OSCAddress(address)
        self.values = values
        self._rawData = nil
    }
    
    /// Create an OSC message from a raw `ASCIIString` address and zero or more OSC values.
    @_disfavoredOverload
    init(
        address: ASCIIString,
        values: [any OSCValue] = []
    ) {
        self.address = OSCAddress(address)
        self.values = values
        self._rawData = nil
    }
    
    /// Create an OSC message from an `OSCAddress` and zero or more OSC values.
    @inlinable
    public init(
        address: OSCAddress,
        values: [any OSCValue] = []
    ) {
        self.address = address
        self.values = values
        self._rawData = nil
    }
    
    /// Create an OSC message from OSC address path components and zero or more OSC values.
    /// Empty path components is equivalent to the address of "/".
    @inlinable
    public init(
        address pathComponents: [String],
        values: [any OSCValue] = []
    ) {
        self.address = OSCAddress(pathComponents: pathComponents)
        self.values = values
        self._rawData = nil
    }
    
    /// Create an OSC message from OSC address path components and zero or more OSC values.
    /// Empty path components is equivalent to the address of "/".
    @_disfavoredOverload
    init(
        address pathComponents: [ASCIIString],
        values: [any OSCValue] = []
    ) {
        self.address = OSCAddress(pathComponents: pathComponents)
        self.values = values
        self._rawData = nil
    }
}
