//
//  OSCTimeTag OSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore // Data<->number conversion

extension OSCTimeTag: OSCValue {
    public static let oscValueToken: OSCValueToken = .timeTag
}

extension OSCTimeTag: OSCValueCodable {
    static let oscTag: Character = "t"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension OSCTimeTag: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: oscTag,
            data: value.rawValue.toData(.bigEndian)
        )
    }
}

extension OSCTimeTag: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        let rawValue = try decoder.readUInt64()
        return OSCTimeTag(rawValue)
    }
}
