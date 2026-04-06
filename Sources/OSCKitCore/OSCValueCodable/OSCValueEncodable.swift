//
//  OSCValueEncodable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

/// Protocol requirements for ``OSCValue`` encoding.
public protocol OSCValueEncodable: SendableMetatype {
    associatedtype OSCEncoded: OSCValueEncodable
    associatedtype OSCValueEncodingBlock: OSCValueEncoderBlock
        where OSCValueEncodingBlock.OSCEncoded == OSCEncoded
    
    /// Declarative description of how an OSC value represents itself with OSC message type tag(s).
    static var oscTagIdentity: OSCValueTagIdentity { get }
    static var oscEncoding: OSCValueEncodingBlock { get }
}

// MARK: - Default Implementation

extension OSCValueEncodable {
    public typealias OSCEncoded = Self
}
