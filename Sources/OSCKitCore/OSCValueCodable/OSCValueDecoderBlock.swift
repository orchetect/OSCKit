//
//  OSCValueDecoderBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public protocol OSCValueDecoderBlock {
    associatedtype OSCDecoded: OSCValueDecodable
}

// MARK: - Decoder Blocks

public struct OSCValueAtomicDecoder<OSCDecoded: OSCValueDecodable>: OSCValueDecoderBlock {
    public typealias Block = (
        _ decoder: inout OSCValueDecoder
    ) throws -> OSCDecoded
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

public struct OSCValueVariableDecoder<OSCDecoded: OSCValueDecodable>: OSCValueDecoderBlock {
    public typealias Block = (
        _ tag: Character,
        _ decoder: inout OSCValueDecoder
    ) throws -> OSCDecoded
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

public struct OSCValueVariadicDecoder<OSCDecoded: OSCValueDecodable>: OSCValueDecoderBlock {
    public typealias Block = (
        _ tags: [Character],
        _ decoder: inout OSCValueDecoder
    ) throws -> (tagCount: Int, value: OSCDecoded)
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}
