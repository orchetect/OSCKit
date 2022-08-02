//
//  OSCObject.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

// MARK: - OSCObject

/// Protocol adopted by all OSC data objects.
public protocol OSCObject {
    /// Returns raw OSC packet data constructed from the struct's properties.
    var rawData: Data { get }
    
    /// Initialize by parsing raw OSC packet data bytes.
    init(from rawData: Data) throws
}
