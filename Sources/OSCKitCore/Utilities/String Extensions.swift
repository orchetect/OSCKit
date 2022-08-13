//
//  String Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension String {
    /// Returns the address as individual path components (strings between `/` separators).
    var oscAddressPathComponents: [Substring] {
        guard !isEmpty else { return [] }
        
        var addressSlice = self[startIndex...]
        
        if addressSlice.starts(with: "/") {
            addressSlice = addressSlice.dropFirst()
        }
        
        if addressSlice.hasSuffix("/") {
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
