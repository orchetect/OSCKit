//
//  OSCValueDecodable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol requirements for ``OSCValue`` decoding.
public protocol OSCValueDecodable: SendableMetatype {
    associatedtype OSCDecoded: OSCValueDecodable
    associatedtype OSCValueDecodingBlock: OSCValueDecoderBlock
        where OSCValueDecodingBlock.OSCDecoded == OSCDecoded
    
    static var oscDecoding: OSCValueDecodingBlock { get }
}

// MARK: - Default Implementation

extension OSCValueDecodable {
    public typealias OSCDecoded = Self
}
