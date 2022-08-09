//
//  Int64.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension Int64: OSCValue {
    public static let oscValueToken: OSCValueToken = .int64
}

extension Int64: OSCValueCodable {
    static let oscTag: Character = "h"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension Int64: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: oscTag,
            data: value.toData(.bigEndian)
        )
    }
}

extension Int64: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        try decoder.readInt64()
    }
}