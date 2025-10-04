//
//  String.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import SwiftASCII // ASCIIString

@_documentation(visibility: internal)
extension String: OSCValue {
    public static let oscValueToken: OSCValueToken = .string
}

@_documentation(visibility: internal)
extension String: OSCValueCodable {
    static let oscTag: Character = "s"
    public static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

@_documentation(visibility: internal)
extension String: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueStaticTagEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value throws(OSCEncodeError) in
        (
            tag: oscTag,
            data: OSCMessageEncoder.fourNullBytePadded(value.asciiStringLossy.rawData)
        )
    }
}

@_documentation(visibility: internal)
extension String: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueStaticTagDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder throws(OSCDecodeError) in
        try decoder.read4ByteAlignedNullTerminatedASCIIString()
    }
}
