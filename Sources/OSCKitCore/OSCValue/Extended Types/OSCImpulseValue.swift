//
//  OSCImpulseValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Impulse OSC value (also known as Infinitum or Bang) as defined by the OSC 1.0 spec.
/// This type carries no data.
public struct OSCImpulseValue {
    public init() { }
}

// MARK: - `any OSCValue` Constructors

extension OSCValue where Self == OSCImpulseValue {
    /// Impulse OSC value (also known as Infinitum or Bang) as defined by the OSC 1.0 spec.
    /// This type carries no data.
    public static var impulse: Self {
        OSCImpulseValue()
    }
}

// MARK: - Equatable, Hashable

extension OSCImpulseValue: Equatable, Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - Sendable

extension OSCImpulseValue: Sendable { }

// MARK: - CustomStringConvertible

extension OSCImpulseValue: CustomStringConvertible {
    public var description: String {
        "Impulse"
    }
}

// MARK: - Codable

extension OSCImpulseValue: Codable { }

// MARK: - OSC Encoding

@_documentation(visibility: internal)
extension OSCImpulseValue: OSCValue {
    public static let oscValueToken: OSCValueToken = .impulse
}

@_documentation(visibility: internal)
extension OSCImpulseValue: OSCValueCodable {
    static let oscTag: Character = "I"
    public static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

@_documentation(visibility: internal)
extension OSCImpulseValue: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (tag: oscTag, data: nil)
    }
}

@_documentation(visibility: internal)
extension OSCImpulseValue: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        OSCImpulseValue()
    }
}
