//
//  OSCObject.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - OSCObject

/// Protocol adopted by all OSC data objects.
public protocol OSCObject: Equatable, Hashable {
    /// Returns raw OSC data constructed from the struct's properties.
    func rawData() throws -> Data
    
    /// Initialize by parsing raw OSC packet data bytes.
    init(from rawData: Data) throws
}
