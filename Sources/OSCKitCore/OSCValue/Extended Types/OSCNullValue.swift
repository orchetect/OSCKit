//
//  OSCNullValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// Null OSC value as defined by the OSC 1.0 spec.
/// This type carries no data.
public struct OSCNullValue {
    @inlinable
    public init() { }
}

// MARK: - Equatable, Hashable

extension OSCNullValue: Equatable, Hashable {
    
}

// MARK: - CustomStringConvertible

extension OSCNullValue: CustomStringConvertible {
    public var description: String {
        "OSCNullValue()"
    }
}

// MARK: - Codable

extension OSCNullValue: Codable { }

// MARK: - OSC Encoding

extension OSCNullValue: OSCValue {
    public static let oscValueToken: OSCValueToken = .null
}

extension OSCNullValue: OSCValueCodable {
    static let oscTag: Character = "N"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension OSCNullValue: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (tag: oscTag, data: nil)
    }
}

extension OSCNullValue: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        OSCNullValue()
    }
}
