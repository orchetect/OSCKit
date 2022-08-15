//
//  Float32.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore

extension Float32: OSCValue {
    public static let oscValueToken: OSCValueToken = .float32
}

extension Float32: OSCValueCodable {
    static let oscTag: Character = "f"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension Float32: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (tag: oscTag, data: value.toData(.bigEndian))
    }
}

extension Float32: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        try decoder.readFloat32()
    }
}
