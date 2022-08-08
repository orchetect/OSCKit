//
//  Bool.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

private let oscTypeTagTrue: Character = "T"
private let oscTypeTagFalse: Character = "F"

extension Bool: OSCValue {
    public static let oscCoreType: OSCValueMask.Token = .bool
}

extension Bool: OSCValueCodable { }

extension Bool: OSCValueEncodable {
    public static let oscTagIdentity: OSCValueTagIdentity = .variable(
        [oscTypeTagTrue, oscTypeTagFalse]
    )
    
    public typealias OSCValueEncodingBlock = OSCValueVariableEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: value ? oscTypeTagTrue : oscTypeTagFalse,
            data: nil
        )
    }
}

extension Bool: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueVariableDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { tag, decoder in
        switch tag {
        case oscTypeTagTrue:
            return true
        case oscTypeTagFalse:
            return false
        default:
            throw OSCDecodeError.unexpectedType(tag: tag)
        }
    }
}
