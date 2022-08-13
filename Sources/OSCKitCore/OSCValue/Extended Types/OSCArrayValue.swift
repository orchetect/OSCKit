//
//  OSCArrayValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

/// OSC value array.
public struct OSCArrayValue {
    public let elements: OSCValues
    
    public init(_ elements: OSCValues) {
        self.elements = elements
    }
    
    public init(_ elements: (any OSCValue)...) {
        self.elements = elements
    }
}

// MARK: - Equatable

extension OSCArrayValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.elements.count == lhs.elements.count else { return false }
        for (lhsIndex, rhsIndex) in zip(lhs.elements.indices, rhs.elements.indices) {
            guard isEqual(lhs.elements[lhsIndex], rhs.elements[rhsIndex]) else {
                return false
            }
        }
        return true
    }
}

// MARK: - Hashable

extension OSCArrayValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        elements.hash(into: &hasher)
    }
}

// MARK: - CustomStringConvertible

extension OSCArrayValue: CustomStringConvertible {
    public var description: String {
        "\(elements)"
    }
}

// MARK: - OSC Encoding

private let oscTypeTagOpen: Character = "["
private let oscTypeTagClose: Character = "]"

extension OSCArrayValue: OSCValue {
    public static var oscValueToken: OSCValueToken { .array }
}

extension OSCArrayValue: OSCValueCodable {
    public static let oscTagIdentity: OSCValueTagIdentity = .variadic(minCount: 2, maxCount: nil)
}

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
