//
//  OSCValueEncodable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public protocol OSCValueEncodable {
    associatedtype OSCEncoded: OSCValueEncodable
    associatedtype OSCValueEncodingBlock: OSCValueEncoderBlock where OSCValueEncodingBlock.OSCEncoded == OSCEncoded
    static var oscTagIdentity: OSCValueTagIdentity { get }
    static var oscEncoding: OSCValueEncodingBlock { get }
}

// MARK: - Default Implementation

extension OSCValueEncodable {
    public typealias OSCEncoded = Self
}
