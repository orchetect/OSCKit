//
//  ValueMask Token.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import SwiftASCII

extension OSCMessage.ValueMask {
    
    /// `OSCMessage` value type tokens, including optional variants and meta types.
    /// Useful for abstractions that mask sequences of values.
    public enum Token: Int, CaseIterable {
        
        // concrete types
        
        // -- core types
        case int32
        case float32
        case string
        case blob
        
        // -- extended types
        case int64
        case timeTag
        case double
        case stringAlt
        case character
        case midi
        case bool
        case `null`
        
        // "meta" types
        
        /// Meta type: Number.
        /// Not a specific type like the others. Used when defining a `MaskType` mask to accept numeric value types (`int32`, `float32`, `double`, `int64`) for an expected value placeholder.
        case number // accepts any OSC number type
        
        // optional versions of concrete types
        
        // -- core types
        case int32Optional // signifies a value that is optional or has a default value
        case float32Optional
        case stringOptional
        case blobOptional
        
        // -- extended types
        case int64Optional
        case timeTagOptional
        case doubleOptional
        case stringAltOptional
        case characterOptional
        case midiOptional
        case boolOptional
        case nullOptional
        
        // -- meta types
        /// Meta type: Number (Optional variant).
        /// Not a specific type like the others. Used when defining a `MaskType` mask to accept numeric value types (`int32`, `float32`, `double`, `int64`) for an expected value placeholder.
        case numberOptional // accepts any OSC number type
        
    }
    
}

public extension OSCMessage.ValueMask.Token {
    
    /// Returns base mask type (by stripping 'optional' component if present).
    @inlinable
    var baseType: Self {
        
        switch self {
            // core types
        case .int32,        .int32Optional:     return .int32
        case .float32,      .float32Optional:   return .float32
        case .string,       .stringOptional:    return .string
        case .blob,         .blobOptional:      return .blob
            
            // extended types
        case .int64,        .int64Optional:     return .int64
        case .timeTag,      .timeTagOptional:   return .timeTag
        case .double,       .doubleOptional:    return .double
        case .stringAlt,    .stringAltOptional: return .stringAlt
        case .character,    .characterOptional: return .character
        case .midi,         .midiOptional:      return .midi
        case .bool,         .boolOptional:      return .bool
        case .null,         .nullOptional:      return .null
            
            // meta types
        case .number,       .numberOptional:    return .number
        }
        
    }
    
    /// Returns `true` if a mask type instance is an 'optional' variant.
    @inlinable
    var isOptional: Bool {
        
        switch self {
            // concrete types
            // -- core types
        case .int32,
                .float32,
                .string,
                .blob:
            return false
            
            // -- extended types
        case .int64,
                .timeTag,
                .double,
                .stringAlt,
                .character,
                .midi,
                .bool,
                .null:
            return false
            
            // meta types
        case .number:
            return false
            
            // optional versions of concrete types
            // -- core types
        case .int32Optional,
                .float32Optional,
                .stringOptional,
                .blobOptional:
            return true
            
            // -- extended types
        case .int64Optional,
                .timeTagOptional,
                .doubleOptional,
                .stringAltOptional,
                .characterOptional,
                .midiOptional,
                .boolOptional,
                .nullOptional:
            return true
            
            // -- meta types
        case .numberOptional:
            return true
            
        }
        
    }
    
}

public extension OSCMessage.ValueMask.Token {
    
    /// Returns the associated concrete type.
    var concreteType: OSCMessageConcreteValue.Type {
        
        switch self {
            // core types
        case .int32,        .int32Optional:     return Int32.self
        case .float32,      .float32Optional:   return Float32.self
        case .string,       .stringOptional:    return ASCIIString.self
        case .blob,         .blobOptional:      return Data.self
            
            // extended types
        case .int64,        .int64Optional:     return Int64.self
        case .timeTag,      .timeTagOptional:   return Int64.self
        case .double,       .doubleOptional:    return Double.self
        case .stringAlt,    .stringAltOptional: return ASCIIString.self
        case .character,    .characterOptional: return ASCIICharacter.self
        case .midi,         .midiOptional:      return OSCMessageValue.MIDIMessage.self
        case .bool,         .boolOptional:      return Bool.self
        case .null,         .nullOptional:      return NSNull.self
            
            // meta types
        case .number,       .numberOptional:    return OSCMessageValue.Number.self
        }
    }
    
}
