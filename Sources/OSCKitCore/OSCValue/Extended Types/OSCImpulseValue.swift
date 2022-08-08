//
//  OSCImpulseValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// Impulse OSC value (also known as Infinitum or Bang) as defined by the OSC 1.0 spec.
/// This type carries no data.
public struct OSCImpulseValue {
    @inlinable
    public init() { }
}

// MARK: - Equatable, Hashable

extension OSCImpulseValue: Equatable, Hashable {
    
}

// MARK: - CustomStringConvertible

extension OSCImpulseValue: CustomStringConvertible {
    public var description: String {
        "OSCImpulseValue()"
    }
}

// MARK: - Codable

extension OSCImpulseValue: Codable { }

// MARK: - OSC Encoding

extension OSCImpulseValue: OSCValue {
    public static let oscCoreType: OSCValueMask.Token = .impulse
}

extension OSCImpulseValue: OSCValueCodable { }

extension OSCImpulseValue: OSCValueEncodable {
    static let oscTag: Character = "I"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
    
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (tag: oscTag, data: nil)
    }
}

extension OSCImpulseValue: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        OSCImpulseValue()
    }
}
