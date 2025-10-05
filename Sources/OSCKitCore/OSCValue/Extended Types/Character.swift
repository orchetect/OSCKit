//
//  Character.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import SwiftASCII // ASCIICharacter

// MARK: - OSC Encoding

@_documentation(visibility: internal)
extension Character: OSCValue {
    public static let oscValueToken: OSCValueToken = .character
}

@_documentation(visibility: internal)
extension Character: OSCValueCodable {
    static let oscTag: Character = "c"
    public static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

@_documentation(visibility: internal)
extension Character: OSCValueEncodable {
    public static let oscEncoding = OSCValueStaticTagEncoder<Self> { value throws(OSCEncodeError) in
        (
            tag: oscTag,
            data: ASCIICharacter(value)
                .asciiValue
                .int32
                .toData(.bigEndian)
        )
    }
}

@_documentation(visibility: internal)
extension Character: OSCValueDecodable {
    public static let oscDecoding = OSCValueStaticTagDecoder<Self> { decoder throws(OSCDecodeError) in
        let asciiCharNum = try decoder.readInt32().int
        guard let asciiChar = ASCIICharacter(asciiCharNum) else {
            throw .malformed(
                "Character value couldn't be read. Could not form a Unicode scalar from the value."
            )
        }
        return asciiChar.characterValue
    }
}
