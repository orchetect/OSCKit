//
//  Double.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

@_documentation(visibility: internal)
extension Double: OSCValue {
    public static let oscValueToken: OSCValueToken = .double
}

@_documentation(visibility: internal)
extension Double: OSCValueCodable {
    static let oscTag: Character = "d"
    public static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

@_documentation(visibility: internal)
extension Double: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueStaticTagEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: oscTag,
            data: value.toData(.bigEndian)
        )
    }
}

@_documentation(visibility: internal)
extension Double: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        try decoder.readDouble()
    }
}
