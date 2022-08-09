//
//  OSCStringAltValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// Alternative String OSC value as defined by the OSC 1.0 spec.
/// This is encoded identically as to the normal String type except it carries a unique OSC tag that differentiates it as an alternative string type.
public struct OSCStringAltValue {
    public var string: String
    
    public init(_ string: String) {
        self.string = string
    }
}

// MARK: - Equatable, Hashable

extension OSCStringAltValue: Equatable, Hashable {
    
}

// MARK: - CustomStringConvertible

extension OSCStringAltValue: CustomStringConvertible {
    public var description: String {
        "OSCStringAltValue()"
    }
}

// MARK: - Codable

extension OSCStringAltValue: Codable { }

// MARK: - OSC Encoding

extension OSCStringAltValue: OSCValue {
    public static let oscValueToken: OSCValueToken = .stringAlt
}

extension OSCStringAltValue: OSCValueCodable {
    static let oscTag: Character = "S"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension OSCStringAltValue: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        let encoded = try String.oscEncoding.block(value.string)
        return (tag: oscTag, data: encoded.data)
    }
}

extension OSCStringAltValue: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        OSCStringAltValue(try String.oscDecoding.block(&decoder))
    }
}
