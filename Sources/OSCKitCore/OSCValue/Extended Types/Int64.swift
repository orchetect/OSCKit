//
//  Int64.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension Int64: OSCValue {
    public static let oscCoreType: OSCValueMask.Token = .int64
}

extension Int64: OSCValueCodable { }

extension Int64: OSCValueEncodable {
    static let oscTag: Character = "h"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
    
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
