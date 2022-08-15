//
//  OSCValueEncodable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol OSCValueEncodable {
    associatedtype OSCEncoded: OSCValueEncodable
    associatedtype OSCValueEncodingBlock: OSCValueEncoderBlock
        where OSCValueEncodingBlock.OSCEncoded == OSCEncoded
    static var oscTagIdentity: OSCValueTagIdentity { get }
    static var oscEncoding: OSCValueEncodingBlock { get }
}

// MARK: - Default Implementation

extension OSCValueEncodable {
    public typealias OSCEncoded = Self
}
