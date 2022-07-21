//
//  OSCAddress Strings.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

// MARK: - Address Components

extension OSCAddress {
    
    public var asciiStringValue: ASCIIString {
        
        address
        
    }
    
    public var stringValue: String {
        
        address.stringValue
        
    }
    
    /// Returns the address as individual path components (strings between `/` separators).
    public var pathComponents: [Substring] {
        
        let addressString = address.stringValue
        guard !addressString.isEmpty else { return [] }
        
        var addressSlice = addressString[addressString.startIndex...]
        
        if addressString.starts(with: "/") {
            addressSlice = addressSlice.dropFirst()
        }
        
        if addressString.hasSuffix("/") {
            addressSlice = addressSlice.dropLast()
        }
        if addressSlice.isEmpty { return [] }
        
        return addressSlice
            .split(separator: "/",
                   omittingEmptySubsequences: false)
        
    }
    
}

// MARK: - Address Pattern

extension OSCAddress {
    
    /// Returns the OSC address converted to a tokenized pattern form.
    public var pattern: [Pattern] {
        
        pathComponents
            .map { Pattern(string: String($0)) }
        
    }
    
}
