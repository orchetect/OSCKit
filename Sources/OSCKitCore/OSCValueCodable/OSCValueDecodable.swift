//
//  OSCValueDecodable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public protocol OSCValueDecodable {
    associatedtype OSCDecoded: OSCValue
    associatedtype OSCValueDecodingBlock: OSCValueDecoderBlock where OSCValueDecodingBlock.OSCDecoded == OSCDecoded
    static var oscDecoding: OSCValueDecodingBlock { get }
}

// MARK: - Default Implementation

extension OSCValueDecodable {
    public typealias OSCDecoded = Self
}
