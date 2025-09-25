//
//  OSCBundle.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - OSCBundle

/// OSC Bundle.
///
/// An OSC bundle can contain zero or more OSC messages and/or OSC bundles, sent in a single
/// packet along with an OSC time tag. Bundles may recursively nest as long as the total data size
/// fits within a single packet.
public struct OSCBundle {
    /// Time tag.
    /// Default value 1: means "immediate" in OSC spec.
    public var timeTag: OSCTimeTag
    
    /// Bundles and/or messages contained within the bundle.
    public var elements: [OSCPacket]
    
    @usableFromInline
    let _rawData: Data?
}

// MARK: - Equatable

extension OSCBundle: Equatable {
    public func elementsEqual(to other: Self) -> Bool {
        // don't factor timeTag into equality
        
        guard elements.count == other.elements.count else { return false }
        
        return elements == other.elements
    }
}

// MARK: - Hashable

extension OSCBundle: Hashable { }

// MARK: - Sendable

extension OSCBundle: Sendable { }

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
