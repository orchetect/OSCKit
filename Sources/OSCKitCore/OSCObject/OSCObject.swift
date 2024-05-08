//
//  OSCObject.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - OSCObject

/// Protocol adopted by all OSC data objects, namely ``OSCMessage`` and ``OSCBundle``.
public protocol OSCObject: Equatable, Hashable {
    /// Enum case describing the OSC object type.
    static var oscObjectType: OSCObjectType { get }
    
    /// Returns raw OSC data constructed from the struct's properties.
    func rawData() throws -> Data
    
    /// Initialize by parsing raw OSC packet data bytes.
    init(from rawData: Data) throws
}

extension OSCObject {
    /// Enum case describing the OSC object type.
    public var oscObjectType: OSCObjectType { Self.oscObjectType }
}
