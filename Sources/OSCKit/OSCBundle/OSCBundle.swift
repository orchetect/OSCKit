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
    public let timeTag: Int64
    
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
            case .bundle(let lhsElementTyped):
                guard case .bundle(let rhsElementTyped) = rhs.elements[rhsIndex]
                else { return false }
                
                if lhsElementTyped != rhsElementTyped { return false }
                
            case .message(let lhsElementTyped):
                guard case .message(let rhsElementTyped) = rhs.elements[rhsIndex]
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
            case .bundle(let elementTyped):
                hasher.combine(elementTyped)
                
            case .message(let elementTyped):
                hasher.combine(elementTyped)
                
            }
            
        }
        
    }
    
}

// MARK: - CustomStringConvertible

extension OSCBundle: CustomStringConvertible {
    
    public var description: String {
        
        elements.count < 1
        ? "OSCBundle(timeTag: \(timeTag))"
        : "OSCBundle(timeTag: \(timeTag), elements: \(elements))"
        
    }
    
    /// Same as `description` but elements are separated with new-line characters.
    public var descriptionPretty: String {
        
        let elementsString =
        elements
            .map { "\($0)" }
            .joined(separator: "\n  ")
        
        return elements.count < 1
        ? "OSCBundle(timeTag: \(timeTag))"
        : "OSCBundle(timeTag: \(timeTag)) Elements:\n  \(elementsString)"
            .trimmed
        
    }
    
}

// MARK: - Header

extension OSCBundle {
    
    /// Constant caching an OSCBundle header
    public static let header: Data = "#bundle"
        .toData(using: .nonLossyASCII)!
        .fourNullBytePadded
    
}
