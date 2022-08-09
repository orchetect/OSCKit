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
        values: OSCValues = []
    ) {
        self.addressPattern = OSCAddressPattern(address)
        self.values = values
        self._rawData = nil
    }
    
    /// Create an OSC message from an `OSCAddressPattern` and zero or more OSC values.
    @inlinable
    public init(
        address: OSCAddressPattern,
        values: OSCValues = []
    ) {
        self.addressPattern = address
        self.values = values
        self._rawData = nil
    }
    
    /// Create an OSC message from OSC address path components and zero or more OSC values.
    /// Empty path components is equivalent to the address of "/".
    @inlinable
    public init(
        address pathComponents: some BidirectionalCollection<some StringProtocol>,
        values: OSCValues = []
    ) {
        self.addressPattern = OSCAddressPattern(pathComponents: pathComponents)
        self.values = values
        self._rawData = nil
    }
    
    // MARK: - SwiftASCII typed
    
    /// Create an OSC message from a raw `ASCIIString` address and zero or more OSC values.
    init(
        asciiAddress address: ASCIIString,
        values: OSCValues = []
    ) {
        self.addressPattern = OSCAddressPattern(ascii: address)
        self.values = values
        self._rawData = nil
    }
    
    /// Create an OSC message from `ASCIIString` OSC address path components and zero or more OSC values.
    /// Empty path components is equivalent to the address of "/".
    init(
        asciiAddress pathComponents: some BidirectionalCollection<ASCIIString>,
        values: OSCValues = []
    ) {
        self.addressPattern = OSCAddressPattern(asciiPathComponents: pathComponents)
        self.values = values
        self._rawData = nil
    }
}
