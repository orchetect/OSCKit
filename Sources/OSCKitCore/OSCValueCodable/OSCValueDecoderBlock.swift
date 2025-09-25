//
//  OSCValueDecoderBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol that ``OSCValue`` decoder block encapsulation objects adopt.
public protocol OSCValueDecoderBlock where Self: Sendable {
    associatedtype OSCDecoded: OSCValueDecodable
}

// MARK: - Decoder Blocks

/// ``OSCValue`` statically-tagged value decoder block encapsulation.
public struct OSCValueStaticTagDecoder<OSCDecoded: OSCValueDecodable>: OSCValueDecoderBlock {
    public typealias Block = @Sendable (
        _ decoder: inout OSCValueDecoder
    ) throws -> OSCDecoded
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

/// ``OSCValue`` variable value decoder block encapsulation.
public struct OSCValueVariableDecoder<OSCDecoded: OSCValueDecodable>: OSCValueDecoderBlock {
    public typealias Block = @Sendable (
        _ tag: Character,
        _ decoder: inout OSCValueDecoder
    ) throws -> OSCDecoded
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

/// ``OSCValue`` variadic value decoder block encapsulation.
///
/// Return `nil` if no expected tags are encountered.
/// Only throw an error if at least one expected tag is encountered but any other tags or value data
/// is malformed.
public struct OSCValueVariadicDecoder<OSCDecoded: OSCValueDecodable>: OSCValueDecoderBlock {
    public typealias Block = @Sendable (
        _ tags: [Character],
        _ decoder: inout OSCValueDecoder
    ) throws -> (tagCount: Int, value: OSCDecoded)?
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}
