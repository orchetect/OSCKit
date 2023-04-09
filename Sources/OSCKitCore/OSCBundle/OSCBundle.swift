//
//  OSCBundle.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - OSCBundle

/// OSC Bundle.
///
/// An OSC bundle can contain zero or more OSC messages and/or OSC bundles, sent in a single
/// packet along with an OSC time tag. Bundles may recursively nest as long as the total data size
/// fits within a single packet.
public struct OSCBundle: OSCObject {
    public static let oscObjectType: OSCObjectType = .bundle
    
    /// Time tag.
    /// Default value 1: means "immediate" in OSC spec.
    public let timeTag: OSCTimeTag
    
    /// Elements contained within the bundle. These can be ``OSCBundle`` or ``OSCMessage``
    /// instances.
    public let elements: [any OSCObject]
    
    @usableFromInline
    let _rawData: Data?
}

// MARK: - Equatable

extension OSCBundle: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // don't factor timeTag into equality
        
        guard lhs.elements.count == rhs.elements.count else { return false }
        
        for (lhsIndex, rhsIndex) in zip(lhs.elements.indices, rhs.elements.indices) {
            switch lhs.elements[lhsIndex] {
            case let lhsElementTyped as OSCBundle:
                guard let rhsElementTyped = rhs.elements[rhsIndex] as? OSCBundle
                else { return false }
                
                guard lhsElementTyped == rhsElementTyped else { return false }
                
            case let lhsElementTyped as OSCMessage:
                guard let rhsElementTyped = rhs.elements[rhsIndex] as? OSCMessage
                else { return false }
                
                guard lhsElementTyped == rhsElementTyped else { return false }
                
            default:
                return false
            }
        }
        
        return true
    }
}

// MARK: - Hashable

extension OSCBundle: Hashable {
    public func hash(into hasher: inout Hasher) {
        // don't factor timeTag into hash
        
        elements.forEach {
            hasher.combine($0)
        }
    }
}

// MARK: - CustomStringConvertible

extension OSCBundle: CustomStringConvertible {
    public var description: String {
        let tt = timeTag.isImmediate ? "" : "timeTag: \(timeTag)"
        
        switch elements.isEmpty {
        case true:
            return "OSCBundle(\(tt))"
        case false:
            return "OSCBundle(\(tt)\(timeTag.isImmediate ? "" : ", ")elements: \(elements))"
        }
    }
    
    /// Same as `description` but elements are separated with new-line characters.
    public var descriptionPretty: String {
        let tt = timeTag.rawValue == 1 ? "" : "timeTag: \(timeTag)"
        
        let elementsString = elements
            .map { "\($0)" }
            .joined(separator: "\n  ")
        
        switch elements.isEmpty {
        case true:
            return "OSCBundle(\(tt))"
        case false:
            return "OSCBundle(\(tt)) with elements:\n  \(elementsString)"
                .trimmed
        }
    }
}

// TODO: Codable - fix or remove

// extension OSCBundle: Codable {
//    enum CodingKeys: String, CodingKey {
//        case timeTag
//        case elements
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let timeTag = try container.decode(OSCTimeTag.RawValue.self, forKey: .timeTag)
//        let elements = try container.decode([any OSCObject].self, forKey: .elements)
//        self.init(elements: elements, timeTag: OSCTimeTag(timeTag))
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(timeTag.rawValue, forKey: .timeTag)
//        try container.encode(elements, forKey: .elements)
//    }
// }

// MARK: - Header

extension OSCBundle {
    /// Constant caching an OSCBundle header
    public static let header: Data = OSCMessageEncoder.fourNullBytePadded(
        "#bundle".toData(using: .nonLossyASCII) ?? Data()
    )
}
