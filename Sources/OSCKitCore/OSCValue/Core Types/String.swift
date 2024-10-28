//
//  String.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if compiler(>=6.0)
internal import SwiftASCII // ASCIIString
#else
@_implementationOnly import SwiftASCII // ASCIIString
#endif

@_documentation(visibility: internal)
extension String: OSCValue {
    public static let oscValueToken: OSCValueToken = .string
}

@_documentation(visibility: internal)
extension String: OSCValueCodable {
    static let oscTag: Character = "s"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

@_documentation(visibility: internal)
extension String: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: oscTag,
            data: OSCMessageEncoder.fourNullBytePadded(value.asciiStringLossy.rawData)
        )
    }
}

@_documentation(visibility: internal)
extension String: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        try decoder.read4ByteAlignedNullTerminatedASCIIString()
    }
}
