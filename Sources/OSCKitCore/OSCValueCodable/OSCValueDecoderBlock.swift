//
//  OSCValueDecoderBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public protocol OSCValueDecoderBlock {
    associatedtype OSCDecoded: OSCValue
}

// MARK: - Static Constructors

// TODO: add these

// MARK: - Decoders

public struct OSCValueAtomicDecoder<OSCDecoded: OSCValue>: OSCValueDecoderBlock {
    public typealias Block = (
        _ decoder: inout OSCValueDecoder
    ) throws -> OSCDecoded
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

public struct OSCValueVariableDecoder<OSCDecoded: OSCValue>: OSCValueDecoderBlock {
    public typealias Block = (
        _ tag: Character,
        _ decoder: inout OSCValueDecoder
    ) throws -> OSCDecoded
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}

public struct OSCValueVariadicDecoder<OSCDecoded: OSCValue>: OSCValueDecoderBlock {
    public typealias Block = (
        _ tags: [Character],
        _ decoder: inout OSCValueDecoder
    ) throws -> (tagCount: Int, OSCDecoded)
    
    public let block: Block
    
    public init(_ block: @escaping Block) {
        self.block = block
    }
}
