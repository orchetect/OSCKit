//
//  OSCAddressPattern init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

extension OSCAddressPattern {
    /// Create an OSC address from a raw `String` address.
    /// The string will be converted to valid ASCII, lossily converting or removing invalid non-ASCII characters if necessary.
    public init(_ lossy: String) {
        let asciiLossy = ASCIIString(lossy)
        self.init(ascii: asciiLossy)
    }
    
    /// Create an OSC address from a raw `ASCIIString` address.
    init(ascii address: ASCIIString) {
        rawAddress = address.stringValue
        rawData = address.rawData
    }
    
    /// Create an OSC address from individual path components.
    /// The path component strings will be converted to valid ASCII, lossily converting or removing invalid non-ASCII characters if necessary.
    /// Empty path components is equivalent to the address of "/".
    public init(pathComponents lossy: some BidirectionalCollection<some StringProtocol>) {
        let formedAddress = ("/" + lossy.joined(separator: "/"))
        self.init(formedAddress)
    }
    
    /// Create an OSC address from individual path components.
    /// The path component strings will be converted to ASCII strings, lossily converting or removing invalid non-ASCII characters if necessary.
    /// Empty path components is equivalent to the address of "/".
    init(asciiPathComponents: some BidirectionalCollection<ASCIIString>) {
        let ascii = ASCIICharacter("/") + asciiPathComponents.joined(separator: "/")
        self.init(ascii: ascii)
    }
}
