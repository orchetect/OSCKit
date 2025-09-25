//
//  OSCValueEncoderBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol that ``OSCValue`` encoder block encapsulation structs adopt.
public protocol OSCValueEncoderBlock where Self: Sendable {
    associatedtype OSCEncoded: OSCValueEncodable
}

// MARK: - Encoder Blocks

/// ``OSCValue`` statically-tagged value encoder block encapsulation.
public struct OSCValueStaticTagEncoder<OSCEncoded: OSCValueEncodable>: OSCValueEncoderBlock {
    public typealias Block = @Sendable (
        _ value: OSCEncoded
    ) throws -> (
        tag: Character,
        data: Data?
    )
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

/// ``OSCValue`` variably-tagged value encoder block encapsulation.
public struct OSCValueVariableTagEncoder<OSCEncoded: OSCValueEncodable>: OSCValueEncoderBlock {
    public typealias Block = @Sendable (
        _ value: OSCEncoded
    ) throws -> (
        tag: Character,
        data: Data?
    )
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

/// ``OSCValue`` variadic-tagged value encoder block encapsulation.
public struct OSCValueVariadicTagEncoder<OSCEncoded: OSCValueEncodable>: OSCValueEncoderBlock {
    public typealias Block = @Sendable (
        _ value: OSCEncoded
    ) throws -> (
        tags: [Character],
        data: Data?
    )
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}
