//
//  OSCBundle.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

// MARK: - OSCBundle

/// OSC Bundle object.
public struct OSCBundle: OSCObject {
    /// Timetag.
    /// Default value 1: means "immediate" in OSC spec.
    public let timeTag: OSCTimeTag
    
    /// Elements contained within the bundle. These can be `OSCBundle` or `OSCMessage` instances.
    public let elements: [OSCPayload]
    
    public let rawData: Data
}

// MARK: - Equatable

extension OSCBundle: Equatable {
    public static func == (lhs: OSCBundle, rhs: OSCBundle) -> Bool {
        // don't factor timeTag into equality
        
        guard lhs.elements.count == rhs.elements.count else { return false }
        
        for (lhsIndex, rhsIndex) in zip(lhs.elements.indices, rhs.elements.indices) {
            switch lhs.elements[lhsIndex] {
            case let .bundle(lhsElementTyped):
                guard case let .bundle(rhsElementTyped) = rhs.elements[rhsIndex]
                else { return false }
                
                if lhsElementTyped != rhsElementTyped { return false }
                
            case let .message(lhsElementTyped):
                guard case let .message(rhsElementTyped) = rhs.elements[rhsIndex]
                else { return false }
                
                if lhsElementTyped != rhsElementTyped { return false }
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
            switch $0 {
            case let .bundle(elementTyped):
                hasher.combine(elementTyped)
                
            case let .message(elementTyped):
                hasher.combine(elementTyped)
            }
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

extension OSCBundle: Codable {
    enum CodingKeys: String, CodingKey {
        case timeTag
        case elements
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let timeTag = try container.decode(OSCTimeTag.RawValue.self, forKey: .timeTag)
        let elements = try container.decode([OSCPayload].self, forKey: .elements)
        self.init(elements: elements, timeTag: OSCTimeTag(timeTag))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timeTag.rawValue, forKey: .timeTag)
        try container.encode(elements, forKey: .elements)
    }
}

// MARK: - Header

extension OSCBundle {
    /// Constant caching an OSCBundle header
    public static let header: Data = "#bundle"
        .toData(using: .nonLossyASCII)!
        .fourNullBytePadded
}
