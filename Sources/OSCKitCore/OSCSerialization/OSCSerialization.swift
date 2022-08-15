//
//  OSCSerialization.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC Coding singleton serialization context.
///
/// Register custom value types to enable `OSCValueDecoder` and `OSCValues.masked()` support for them.
public class OSCSerialization {
    /// Shared singleton instance.
    public static let shared: OSCSerialization = .init()
    
    var tagIdentities: [(OSCValueTagIdentity, any OSCValueCodable.Type)] = []
    
    internal required init() {
        do {
            try registerDefaultTypes()
        } catch {
            assertionFailure(
                "One or more types were already registered while initializing. This should not happen."
            )
        }
    }
    
    public func registerType(_ oscValueType: any OSCValueCodable.Type) throws {
        // throw an error if user attempts to register an already existing type tag
        
        let staticTags = oscValueType
            .oscTagIdentity
            .staticTags()
        
        if !staticTags.isEmpty {
            guard staticTags.allSatisfy(tagIdentities(contains:)) == false
            else {
                throw OSCSerializationError.tagAlreadyRegistered
            }
        }
        
        // add type's tag identity
        tagIdentities.append(
            (oscValueType.oscTagIdentity, oscValueType.self)
        )
    }
}

extension OSCSerialization {
    func registerDefaultTypes() throws {
        try registerType(Int32.self)
        try registerType(Float32.self)
        try registerType(String.self)
        try registerType(Data.self)
        
        // extended types
        try registerType(Bool.self)
        try registerType(Character.self)
        try registerType(Double.self)
        try registerType(Int64.self)
        try registerType(OSCImpulseValue.self)
        try registerType(OSCMIDIValue.self)
        try registerType(OSCNullValue.self)
        try registerType(OSCStringAltValue.self)
        try registerType(OSCTimeTag.self)
        
        // variadic
        // registerType(OSCValues.self) // can't use `any OSC Value` as a type :(
        
        // this should be registered last in order
        try registerType(OSCArrayValue.self)
    }
    
    func tagIdentities(for character: Character) -> [any OSCValueCodable.Type] {
        tagIdentities
            .filter {
                switch $0.0 {
                case let .atomic(char):
                    return char == character
                case let .variable(chars):
                    return chars.contains(character)
                case .variadic:
                    return true
                }
            }
            .map { $0.1 }
    }
    
    func tagIdentities(contains character: Character) -> Bool {
        tagIdentities
            .contains {
                $0.0.isEqual(to: character)
            }
    }
}
