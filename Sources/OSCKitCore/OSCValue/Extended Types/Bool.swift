//
//  Bool.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

private let oscTypeTagTrue: Character = "T"
private let oscTypeTagFalse: Character = "F"

@_documentation(visibility: internal)
extension Bool: OSCValue {
    public static let oscValueToken: OSCValueToken = .bool
}

@_documentation(visibility: internal)
extension Bool: OSCValueCodable {
    public static let oscTagIdentity: OSCValueTagIdentity = .variable(
        [oscTypeTagTrue, oscTypeTagFalse]
    )
}

@_documentation(visibility: internal)
extension Bool: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueVariableTagEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value throws(OSCEncodeError) in
        (
            tag: value ? oscTypeTagTrue : oscTypeTagFalse,
            data: nil
        )
    }
}

@_documentation(visibility: internal)
extension Bool: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueVariableTagDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { tag, decoder throws(OSCDecodeError) in
        switch tag {
        case oscTypeTagTrue:
            return true
        case oscTypeTagFalse:
            return false
        default:
            throw .unexpectedType(tag: tag)
        }
    }
}
