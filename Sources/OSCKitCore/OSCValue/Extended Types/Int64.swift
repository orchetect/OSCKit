//
//  Int64.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

@_documentation(visibility: internal)
extension Int64: OSCValue {
    public static let oscValueToken: OSCValueToken = .int64
}

@_documentation(visibility: internal)
extension Int64: OSCValueCodable {
    static let oscTag: Character = "h"
    public static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

@_documentation(visibility: internal)
extension Int64: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueStaticTagEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: oscTag,
            data: value.toData(.bigEndian)
        )
    }
}

@_documentation(visibility: internal)
extension Int64: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueStaticTagDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        try decoder.readInt64()
    }
}
