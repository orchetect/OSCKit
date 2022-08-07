//
//  Value init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix
import SwiftASCII

extension OSCMessage.Value {
    // core types
    
    @inlinable
    public init(_ source: Int32) {
        self = .int32(source)
    }
    
    @inlinable
    public init(_ source: Float32) {
        self = .float32(source)
    }
    
    @inlinable
    public init(_ source: ASCIIString) {
        self = .string(source)
    }
    
    @inlinable
    public init(_ source: Data) {
        self = .blob(source)
    }
    
    // extended types
    
    @inlinable
    public init(_ source: Int64) {
        self = .int64(source)
    }
    
    @inlinable
    public init(timeTag source: OSCTimeTag) {
        self = .timeTag(source)
    }
    
    @inlinable
    public init(_ source: Double) {
        self = .double(source)
    }
    
    @inlinable
    public init(stringAlt source: ASCIIString) {
        self = .stringAlt(source)
    }
    
    @inlinable
    public init(character source: ASCIICharacter) {
        self = .character(source)
    }
    
    @inlinable
    public init(_ source: MIDIMessage) {
        self = .midi(source)
    }
    
    @inlinable
    public static func midi(
        portID: UInt8,
        status: UInt8,
        data1: UInt8 = 0x00,
        data2: UInt8 = 0x00
    ) -> Self {
        .midi(MIDIMessage(
            portID: portID,
            status: status,
            data1: data1,
            data2: data2
        ))
    }
    
    @inlinable
    public init(_ source: Bool) {
        self = .bool(source)
    }
}
