//
//  OSCArrayValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

/// OSC value array.
public struct OSCArrayValue {
    public let elements: OSCValues
    
    public init(_ elements: OSCValues) {
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
        "OSCArrayValue(\(elements))"
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
        // TODO: implement
        
        (tags: [], data: nil)
    }
}

extension OSCArrayValue: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueVariadicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { tags, decoder in
        // TODO: implement
        
        let array: OSCValues = [Int32(123)]
        
        return (tagCount: 0, OSCDecoded(array))
    }
}
