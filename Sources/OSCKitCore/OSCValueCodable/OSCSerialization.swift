//
//  OSCSerialization.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// OSC Coding serialization context.
///
/// Register custom value types to enable `OSCValueDecoder` parsing support for them.
public class OSCSerialization {
    public private(set) var tagIdentities: [OSCValueTagIdentity: any OSCValueCodable.Type] = [:]
    
    public init() {
        // core types
        //registerType([any OSCValue].self)
        registerType(OSCValueArray.self)
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
    
    public func registerType(_ oscValueType: any OSCValueCodable.Type) {
        // TODO: check existing registered tag types and throw an error if user attempts to register any of them
        
        tagIdentities[oscValueType.oscTagIdentity] = oscValueType.self
    }
    
//    public func tagIdentities(for character: Character) -> [any OSCValueCodable.Type] {
//        tagIdentities.filter {
//            switch $0 {
//            case .
//            }
//        }
//    }
}
