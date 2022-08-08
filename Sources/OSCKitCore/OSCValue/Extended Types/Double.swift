//
//  Double.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension Double: OSCValue {
    public static let oscCoreType: OSCValueMask.Token = .double
}

extension Double: OSCValueCodable { }

extension Double: OSCValueEncodable {
    static let oscTag: Character = "d"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
    
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: oscTag,
            data: value.toData(.bigEndian)
        )
    }
}

extension Double: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        try decoder.readDouble()
    }
}
