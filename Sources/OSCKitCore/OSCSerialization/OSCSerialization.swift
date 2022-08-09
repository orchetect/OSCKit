//
//  OSCSerialization.swift
//  OSCKit • https://github.com/orchetect/OSCKit
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
        registerDefaultTypes()
    }
    
    public func registerType(_ oscValueType: any OSCValueCodable.Type) {
        // TODO: throw an error if user attempts to register an already existing type tag?
        
        assert(
            !oscValueType
                .oscTagIdentity
                .staticTags()
                .allSatisfy(tagIdentities(contains:)),
            "Tag identity is already registered."
        )
        
        tagIdentities.append(
            (oscValueType.oscTagIdentity, oscValueType.self)
        )
    }
}

extension OSCSerialization {
    func registerDefaultTypes() {
        // core types
        // registerType(OSCValues.self) // can't use OSCValues as a type :(
        registerType(OSCArrayValue.self)
        registerType(Data.self)
        registerType(Float32.self)
        registerType(Int32.self)
        registerType(String.self)
        
        // extended types
        registerType(Bool.self)
        registerType(Character.self)
        registerType(Double.self)
        registerType(Int64.self)
        registerType(OSCImpulseValue.self)
        registerType(OSCMIDIValue.self)
        registerType(OSCNullValue.self)
        registerType(OSCStringAltValue.self)
        registerType(OSCTimeTag.self)
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
