//
//  Bool.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

private let oscTypeTagTrue: Character = "T"
private let oscTypeTagFalse: Character = "F"

extension Bool: OSCValue {
    public static let oscValueToken: OSCValueToken = .bool
}

extension Bool: OSCValueCodable {
    public static let oscTagIdentity: OSCValueTagIdentity = .variable(
        [oscTypeTagTrue, oscTypeTagFalse]
    )
}

extension Bool: OSCValueEncodable {
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
