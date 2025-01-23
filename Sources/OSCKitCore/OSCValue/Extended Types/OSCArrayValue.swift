//
//  OSCArrayValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if compiler(>=6.0)
internal import SwiftASCII // ASCIICharacter
#else
@_implementationOnly import SwiftASCII // ASCIICharacter
#endif

/// OSC value array (as an OSC value type itself).
public struct OSCArrayValue {
    public let elements: OSCValues
    
    public init(_ elements: OSCValues) {
        self.elements = elements
    }
    
    // NOTE: Overloads that take variadic values were tested,
    // however for code consistency and proper indentation, it is
    // undesirable to have variadic parameters.
}

// MARK: - `any OSCValue` Constructors

extension OSCValue where Self == OSCArrayValue {
    /// OSC value array.
    public static func array(_ elements: OSCValues) -> Self {
        OSCArrayValue(elements)
    }
}

// MARK: - Equatable

extension OSCArrayValue: Equatable {
    // custom operator logic is needed because array contains `any OSCValue`
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.elements == rhs.elements
    }
    
    // additional operator overloads:
    
    public static func == (lhs: Self, rhs: [any OSCValue]) -> Bool {
        lhs.elements == rhs
    }

    public static func != (lhs: Self, rhs: [any OSCValue]) -> Bool {
        lhs.elements != rhs
    }

    public static func == (lhs: [any OSCValue], rhs: Self) -> Bool {
        lhs == rhs.elements
    }

    public static func != (lhs: [any OSCValue], rhs: Self) -> Bool {
        lhs != rhs.elements
    }
}

// MARK: - Hashable

extension OSCArrayValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        elements.hash(into: &hasher)
    }
}

// MARK: - Sendable

extension OSCArrayValue: Sendable { }

// MARK: - CustomStringConvertible

extension OSCArrayValue: CustomStringConvertible {
    public var description: String {
        "\(elements)"
    }
}

// MARK: - ExpressibleByArrayLiteral

// Note: this honestly has no practical effect since Swift's type inference
//       system will almost never guess an array literal contains `any OSCValue`.
//       It seems to infer it to be of type [Any] without more context,
//       and even still, from testing it seems it is almost impossible to
//       get this literal to be formed without requiring explicit typing
//       of the array inline:
//         ie: [123, "String"] as OSCArrayValue
//       which defeats the purpose since it brings no real syntactic convenience.

// extension OSCArrayValue: ExpressibleByArrayLiteral {
//    public typealias ArrayLiteralElement = any OSCValue
//
//    public init(arrayLiteral elements: ArrayLiteralElement...) {
//        self.init(elements)
//    }
// }

// MARK: - OSC Encoding

private let oscTypeTagOpen: Character = "["
private let oscTypeTagClose: Character = "]"

@_documentation(visibility: internal)
extension OSCArrayValue: OSCValue {
    public static var oscValueToken: OSCValueToken { .array }
}

@_documentation(visibility: internal)
extension OSCArrayValue: OSCValueCodable {
    public static let oscTagIdentity: OSCValueTagIdentity = .variadic(minCount: 2, maxCount: nil)
}

@_documentation(visibility: internal)
extension OSCArrayValue: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueVariadicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        var tags: [ASCIICharacter] = []
        tags.reserveCapacity(value.elements.count + 2)
        tags += ASCIICharacter(oscTypeTagOpen)
        
        var data = Data()
        
        for element in value.elements {
            try OSCMessageEncoder.encode(
                element,
                builderTags: &tags,
                builderValuesChunk: &data
            )
        }
        
        tags += ASCIICharacter(oscTypeTagClose)
        
        return (
            tags: tags.map { $0.characterValue },
            data: data
        )
    }
}

@_documentation(visibility: internal)
extension OSCArrayValue: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueVariadicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { tags, decoder in
        guard tags.first == oscTypeTagOpen else {
            return nil
        }

        var extractedValues: OSCValues = []
        
        var remainingTags = Array(tags.dropFirst())
        
        var currentTagIndex = remainingTags.startIndex
        while currentTagIndex < remainingTags.count {
            var tag = remainingTags[currentTagIndex]
            
            if tag == oscTypeTagClose {
                currentTagIndex += 1
                return (
                    tagCount: currentTagIndex - remainingTags.startIndex + 1,
                    value: OSCDecoded(extractedValues)
                )
            }
            
            let tagsToAdvance = try OSCMessageDecoder.decodeValue(
                initialChar: &tag,
                currentTagIndex: &currentTagIndex,
                tags: &remainingTags,
                extractedValues: &extractedValues,
                decoder: &decoder
            )
            currentTagIndex += tagsToAdvance
        }
        
        // fall-through condition means we never encountered a closing tag
        throw OSCDecodeError.malformed("Array termination tag ']' was not found.")
    }
}
