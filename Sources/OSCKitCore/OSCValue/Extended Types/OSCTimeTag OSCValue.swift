//
//  OSCTimeTag OSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

@_documentation(visibility: internal)
extension OSCTimeTag: OSCValue {
    public static let oscValueToken: OSCValueToken = .timeTag
}

@_documentation(visibility: internal)
extension OSCTimeTag: OSCValueCodable {
    static let oscTag: Character = "t"
    public static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

@_documentation(visibility: internal)
extension OSCTimeTag: OSCValueEncodable {
    public static let oscEncoding = OSCValueStaticTagEncoder<Self> { value throws(OSCEncodeError) in
        (
            tag: oscTag,
            data: value.rawValue.toData(.bigEndian)
        )
    }
}

@_documentation(visibility: internal)
extension OSCTimeTag: OSCValueDecodable {
    public static let oscDecoding = OSCValueStaticTagDecoder<Self> { decoder throws(OSCDecodeError) in
        let rawValue = try decoder.readUInt64()
        return OSCTimeTag(rawValue)
    }
}
