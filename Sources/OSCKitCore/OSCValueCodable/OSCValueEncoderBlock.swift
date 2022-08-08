//
//  OSCValueEncoderBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public protocol OSCValueEncoderBlock {
    associatedtype OSCEncoded: OSCValue
}

// MARK: - Static Constructors

extension OSCValueEncoderBlock {
    public static func atomic(
        _ block: @escaping OSCValueAtomicEncoder<OSCEncoded>.Block
    ) -> OSCValueAtomicEncoder<OSCEncoded> {
        .init(block)
    }
    
    public static func variable(
        _ block: @escaping OSCValueVariableEncoder<OSCEncoded>.Block
    ) -> OSCValueVariableEncoder<OSCEncoded> {
        .init(block)
    }
    
    public static func variadic(
        _ block: @escaping OSCValueVariadicEncoder<OSCEncoded>.Block
    ) -> OSCValueVariadicEncoder<OSCEncoded> {
        .init(block)
    }
}

// MARK: - Encoders

public struct OSCValueAtomicEncoder<OSCEncoded: OSCValue>: OSCValueEncoderBlock {
    public typealias Block = (
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

public struct OSCValueVariableEncoder<OSCEncoded: OSCValue>: OSCValueEncoderBlock {
    public typealias Block = (
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

public struct OSCValueVariadicEncoder<OSCEncoded: OSCValue>: OSCValueEncoderBlock {
    public typealias Block = (
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
