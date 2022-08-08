//
//  OSCValueArray.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

/// OSC value array.
public struct OSCValueArray {
    public let elements: [any OSCValue]
    
    public init(_ elements: [any OSCValue]) {
        self.elements = elements
    }
}

// MARK: - Equatable

extension OSCValueArray: Equatable {
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

extension OSCValueArray: Hashable {
    public func hash(into hasher: inout Hasher) {
        elements.hash(into: &hasher)
    }
}

// MARK: - CustomStringConvertible

extension OSCValueArray: CustomStringConvertible {
    public var description: String {
        "OSCValueArray(\(elements))"
    }
}

// MARK: - OSC Encoding

private let oscTypeTagOpen: Character = "["
private let oscTypeTagClose: Character = "]"

extension OSCValueArray: OSCValue {
    public static var oscCoreType: OSCValueMask.Token { .array }
}

extension OSCValueArray: OSCValueCodable { }

extension OSCValueArray: OSCValueEncodable {
    public static let oscTagIdentity: OSCValueTagIdentity = .variadic(minCount: 2, maxCount: nil)
    
    public typealias OSCValueEncodingBlock = OSCValueVariadicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        // TODO: implement
        
        (tags: [], data: nil)
    }
}

extension OSCValueArray: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueVariadicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { tags, decoder in
        // TODO: implement
        
        let array: [any OSCValue] = [Int32(123)]
        
        return (tagCount: 0, OSCDecoded(array))
    }
}
