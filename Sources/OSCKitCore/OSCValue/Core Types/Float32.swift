//
//  Float32.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension Float32: OSCValue {
    public static let oscCoreType: OSCValueMask.Token = .float32
}

extension Float32: OSCValueCodable { }

extension Float32: OSCValueEncodable {
    static let oscTag: Character = "f"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
    
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
