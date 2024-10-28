//
//  OSCSerialization.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC Coding serialization context (global singleton).
///
/// Register custom value types to enable ``OSCValueDecoder`` and ``OSCValues`` `masked()` support
/// for them.
@globalActor public final actor OSCSerialization { // TODO: convert to actor/globalActor?
    /// Shared singleton instance.
    public static let shared = OSCSerialization()
    
    /// Internal:
    /// Registered tag identities repository.
    var tagIdentities: [(OSCValueTagIdentity, any OSCValueCodable.Type)] = []
    
    /// Singleton init.
    init() {
        // register default types synchronously so they are available immediately
        for oscValueType in Self.standardTypes {
            tagIdentities.append(
                (oscValueType.oscTagIdentity, oscValueType.self)
            )
        }
    }
    
    /// Register a concrete type that conforms to ``OSCValueCodable`` to make it available for OSC
    /// encoding and decoding.
    public func registerType(_ oscValueType: any OSCValueCodable.Type) throws {
        // throw an error if user attempts to register an already existing type tag
        try canRegisterType(oscValueType)
        
        // add type's tag identity
        tagIdentities.append(
            (oscValueType.oscTagIdentity, oscValueType.self)
        )
    }
    
    private func canRegisterType(_ oscValueType: any OSCValueCodable.Type) throws {
        let staticTags = oscValueType
            .oscTagIdentity
            .staticTags()
        
        if !staticTags.isEmpty {
            guard staticTags.allSatisfy(tagIdentities(contains:)) == false
            else {
                throw OSCSerializationError.tagAlreadyRegistered
            }
        }
    }
}

extension OSCSerialization {
    static let standardTypes: [any OSCValueCodable.Type] = [
        Int32.self,
        Float32.self,
        String.self,
        Data.self,
        
        // extended types
        Bool.self,
        Character.self,
        Double.self,
        Int64.self,
        OSCImpulseValue.self,
        OSCMIDIValue.self,
        OSCNullValue.self,
        OSCStringAltValue.self,
        OSCTimeTag.self,
        
        // variadic
        // OSCValues.self, // can't use `any OSC Value` as a type :(
        
        // this should be registered last in order
        OSCArrayValue.self
    ]
    
    /// Internal:
    /// Returns tag identities for a given OSC-type tag character.
    func tagIdentities(for character: Character) -> [any OSCValueCodable.Type] {
        tagIdentities
            .filter {
                switch $0.0 {
                case let .atomic(char):
                    char == character
                case let .variable(chars):
                    chars.contains(character)
                case .variadic:
                    true
                }
            }
            .map { $0.1 }
    }
    
    /// Internal:
    /// Returns `true` if a registered tag identity matches a given OSC-type tag character.
    func tagIdentities(contains character: Character) -> Bool {
        tagIdentities
            .contains {
                $0.0.isEqual(to: character)
            }
    }
}
