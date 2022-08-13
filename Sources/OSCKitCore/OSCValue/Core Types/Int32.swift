//
//  Int32.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension Int32: OSCValue {
    public static let oscValueToken: OSCValueToken = .int32
}

extension Int32: OSCValueCodable {
    static let oscTag: Character = "i"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension Int32: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (tag: oscTag, data: value.toData(.bigEndian))
    }
}

extension Int32: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        try decoder.readInt32()
    }
}
