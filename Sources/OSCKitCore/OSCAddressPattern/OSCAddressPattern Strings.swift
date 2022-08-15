//
//  OSCAddressPattern Strings.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

// MARK: - Address Components

extension OSCAddressPattern {
    /// Returns the address pattern as a string.
    public var stringValue: String {
        rawAddress
    }
    
    /// Returns the address as individual path components (strings between `/` separators).
    public var pathComponents: [Substring] {
        rawAddress.oscAddressPathComponents
    }
}

// MARK: - Address Pattern

extension OSCAddressPattern {
    /// Utility: Returns the raw OSC address pattern converted to a tokenized pattern.
    var components: [Component] {
        pathComponents
            .map { Component(string: String($0)) }
    }
    
    /// Returns `true` if the address matches a given local address.
    /// Employs address pattern matching if the inbound address contains a pattern.
    public func matches(localAddress: String) -> Bool {
        let selfPattern = components
        guard !selfPattern.isEmpty else { return false }
        
        let localAddressComponents = localAddress.oscAddressPathComponents
        
        guard selfPattern.count == localAddressComponents.count else { return false }
        
        for idx in 0 ..< selfPattern.count {
            guard idx < localAddressComponents.count,
                  selfPattern[idx].evaluate(matching: localAddressComponents[idx])
            else { return false }
        }
        
        return true
    }
}
