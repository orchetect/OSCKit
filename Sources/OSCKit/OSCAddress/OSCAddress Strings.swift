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
    public var pathComponents: [Substring]? {
        
        let addressString = address.stringValue
        
        guard addressString.prefix(1) == "/",
              addressString.count > 1,
              addressString.suffix(1) != "/"
        else { return nil }
        
        let addressStringAfterInitialSlash = addressString.suffix(
            from: addressString.index(after: addressString.startIndex)
        )
        
        return addressStringAfterInitialSlash
            .split(separator: "/",
                   omittingEmptySubsequences: false)
        
    }
    
}

// MARK: - Address Pattern

extension OSCAddress {
    
    /// Returns the OSC address converted to a tokenized pattern form.
    public var pattern: [Pattern] {
        
        pathComponents?
            .map { Pattern(string: String($0)) ?? .init() }
        ?? []
        
    }
    
}
