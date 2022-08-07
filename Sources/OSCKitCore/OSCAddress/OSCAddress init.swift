//
//  OSCAddress init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

extension OSCAddress {
    /// Create an OSC address from a raw `String` address.
    /// The string will be converted to an ASCII string, lossily converting or removing invalid non-ASCII characters if necessary.
    @_disfavoredOverload
    public init(_ address: String) {
        self.address = address.asciiStringLossy
    }
    
    /// Create an OSC address from a raw `ASCIIString` address.
    public init(_ address: ASCIIString) {
        self.address = address
    }
    
    /// Create an OSC address from individual path components.
    /// The path component strings will be converted to ASCII strings, lossily converting or removing invalid non-ASCII characters if necessary.
    /// Empty path components is equivalent to the address of "/".
    public init(pathComponents: [String]) {
        address = ("/" + pathComponents.joined(separator: "/")).asciiStringLossy
    }
    
    /// Create an OSC address from individual path components.
    /// The path component strings will be converted to ASCII strings, lossily converting or removing invalid non-ASCII characters if necessary.
    /// Empty path components is equivalent to the address of "/".
    @_disfavoredOverload
    public init(pathComponents: [ASCIIString]) {
        address = ASCIICharacter("/") + pathComponents.joined(separator: "/")
    }
}
