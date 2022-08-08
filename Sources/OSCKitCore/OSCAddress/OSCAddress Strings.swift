//
//  OSCAddress Strings.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

// MARK: - Address Components

extension OSCAddress {
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
            .split(
                separator: "/",
                omittingEmptySubsequences: false
            )
    }
}

// MARK: - Address Pattern

extension OSCAddress {
    /// Returns the OSC address converted to a tokenized pattern form.
    public var pattern: [Pattern] {
        pathComponents
            .map { Pattern(string: String($0)) }
    }
    
    /// Returns `true` if the address matches a given local address.
    /// Employs OSC address pattern matching if the inbound address contains a pattern.
    public func pattern(matches localAddress: OSCAddress) -> Bool {
        let selfPattern = pattern
        guard !pattern.isEmpty else { return false }
        
        let localAddressComponents = localAddress.pathComponents
        
        guard selfPattern.count == localAddressComponents.count else { return false }
        
        for idx in 0 ..< selfPattern.count {
            guard idx < localAddressComponents.count,
                  selfPattern[idx].evaluate(matching: localAddressComponents[idx])
            else { return false }
        }
        
        return true
    }
}
