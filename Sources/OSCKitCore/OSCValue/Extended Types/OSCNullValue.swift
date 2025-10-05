//
//  OSCNullValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Null OSC value as defined by the OSC 1.0 spec.
/// This type carries no data.
public struct OSCNullValue {
    public init() { }
}

// MARK: - `any OSCValue` Constructors

extension OSCValue where Self == OSCNullValue {
    /// Null OSC value as defined by the OSC 1.0 spec.
    /// This type carries no data.
    public static var null: Self {
        OSCNullValue()
    }
}

// MARK: - Equatable, Hashable

extension OSCNullValue: Equatable, Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - Sendable

extension OSCNullValue: Sendable { }

// MARK: - CustomStringConvertible

extension OSCNullValue: CustomStringConvertible {
    public var description: String {
        "Null"
    }
}

// MARK: - Codable

extension OSCNullValue: Codable { }

// MARK: - OSC Encoding

@_documentation(visibility: internal)
extension OSCNullValue: OSCValue {
    public static let oscValueToken: OSCValueToken = .null
}

@_documentation(visibility: internal)
extension OSCNullValue: OSCValueCodable {
    static let oscTag: Character = "N"
    public static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

@_documentation(visibility: internal)
extension OSCNullValue: OSCValueEncodable {
    public static let oscEncoding = OSCValueStaticTagEncoder<Self> { value throws(OSCEncodeError) in
        (tag: oscTag, data: nil)
    }
}

@_documentation(visibility: internal)
extension OSCNullValue: OSCValueDecodable {
    public static let oscDecoding = OSCValueStaticTagDecoder<Self> { decoder throws(OSCDecodeError) in
        OSCNullValue()
    }
}
