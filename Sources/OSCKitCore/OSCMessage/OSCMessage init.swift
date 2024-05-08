//
//  OSCMessage init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if compiler(>=5.10)
/* private */ import SwiftASCII // internal inits
#else
@_implementationOnly import SwiftASCII // internal inits
#endif

// NOTE: Overloads that take variadic values were tested,
// however for code consistency and proper indentation, it is
// undesirable to have variadic parameters.

extension OSCMessage {
    /// Create an OSC message from a raw `String` address pattern and zero or more OSC values
    /// (arguments).
    /// The address string will be converted to an ASCII string, lossily converting or removing
    /// invalid non-ASCII characters if necessary.
    @_disfavoredOverload
    public init(
        _ addressPattern: String,
        values: OSCValues = []
    ) {
        self.addressPattern = OSCAddressPattern(addressPattern)
        self.values = values
        _rawData = nil
    }
    
    /// Create an OSC message from an ``OSCAddressPattern`` and zero or more OSC values (arguments).
    public init(
        _ addressPattern: OSCAddressPattern,
        values: OSCValues = []
    ) {
        self.addressPattern = addressPattern
        self.values = values
        _rawData = nil
    }
    
    /// Create an OSC message from OSC address pattern path components and zero or more OSC values
    /// (arguments).
    /// Empty path components is equivalent to the address of "/".
    public init<S>(
        addressPattern pathComponents: S,
        values: OSCValues = []
    ) where S: BidirectionalCollection, S.Element: StringProtocol {
        addressPattern = OSCAddressPattern(pathComponents: pathComponents)
        self.values = values
        _rawData = nil
    }
    
    // MARK: - SwiftASCII typed
    
    /// Internal:
    /// Create an OSC message from a raw ``ASCIIString`` address pattern and zero or more OSC values
    /// (arguments).
    init(
        asciiAddressPattern address: ASCIIString,
        values: OSCValues = []
    ) {
        addressPattern = OSCAddressPattern(ascii: address)
        self.values = values
        _rawData = nil
    }
    
    /// Internal:
    /// Create an OSC message from ``ASCIIString`` OSC address pattern path components and zero or
    /// more OSC values (arguments).
    /// Empty path components is equivalent to the address of "/".
    init<S>(
        asciiAddressPattern pathComponents: S,
        values: OSCValues = []
    ) where S: BidirectionalCollection, S.Element == ASCIIString {
        addressPattern = OSCAddressPattern(asciiPathComponents: pathComponents)
        self.values = values
        _rawData = nil
    }
}
