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
    public static let oscEncoding = OSCValueStaticTagEncoder<Self> { value throws(OSCEncodeError) in
        (
            tag: oscTag,
            data: value.toData(.bigEndian)
        )
    }
}

@_documentation(visibility: internal)
extension Int64: OSCValueDecodable {
    public static let oscDecoding = OSCValueStaticTagDecoder<Self> { decoder throws(OSCDecodeError) in
        try decoder.readInt64()
    }
}
