//
//  Double.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore // Data<->number conversion

extension Double: OSCValue {
    public static let oscValueToken: OSCValueToken = .double
}

extension Double: OSCValueCodable {
    static let oscTag: Character = "d"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension Double: OSCValueEncodable {
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
