//
//  OSCValueToken.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// `OSCValue` type tokens, including optional variants and opaque types.
/// Useful for abstractions that mask sequences of values.
public enum OSCValueToken: Int, CaseIterable, Equatable, Hashable {
    // concrete types
    
    // -- core types
    case blob
    case float32
    case int32
    case string
    
    // -- extended types
    case array
    case bool
    case character
    case double
    case int64
    case impulse
    case midi
    case null
    case stringAlt
    case timeTag
    
    // -- opaque types
    
    /// Meta type: Number.
    /// Not a specific type like the others. Used when defining a mask to accept numeric value types (`int32`, `float32`, `double`, `int64`) for an expected value placeholder.
    case number // accepts any OSC number type
    
    // optional versions of concrete types
    
    // -- core types
    case blobOptional
    case float32Optional
    case int32Optional
    case stringOptional
    
    // -- extended types
    case arrayOptional
    case boolOptional
    case characterOptional
    case doubleOptional
    case int64Optional
    case impulseOptional
    case midiOptional
    case nullOptional
    case stringAltOptional
    case timeTagOptional
    
    // -- opaque types
    /// Meta type: Number (Optional variant).
    /// Not a specific type like the others. Used when defining a mask to accept numeric value types (`int32`, `float32`, `double`, `int64`) for an expected value placeholder.
    case numberOptional // accepts any OSC number type
}

extension OSCValueToken {
    /// Returns base mask type (by stripping 'optional' component if present).
    @inlinable
    public var baseType: Self {
        switch self {
        // core types
        case .blob,         .blobOptional:      return .blob
        case .float32,      .float32Optional:   return .float32
        case .int32,        .int32Optional:     return .int32
        case .string,       .stringOptional:    return .string
            
        // extended types
        case .array,        .arrayOptional:     return .array
        case .bool,         .boolOptional:      return .bool
        case .character,    .characterOptional: return .character
        case .double,       .doubleOptional:    return .double
        case .int64,        .int64Optional:     return .int64
        case .impulse,      .impulseOptional:     return .impulse
        case .midi,         .midiOptional:      return .midi
        case .null,         .nullOptional:      return .null
        case .stringAlt,    .stringAltOptional: return .stringAlt
        case .timeTag,      .timeTagOptional:   return .timeTag
            
        // opaque types
        case .number,       .numberOptional:    return .number
        }
    }
    
    /// Returns `true` if a mask type instance is an 'optional' variant.
    @inlinable
    public var isOptional: Bool {
        switch self {
        // concrete types
        // -- core types
        case .blob,
             .int32,
             .float32,
             .string:
            return false
            
        // -- extended types
        case .array,
             .bool,
             .character,
             .double,
             .int64,
             .impulse,
             .midi,
             .null,
             .stringAlt,
             .timeTag:
            
            return false
            
        // opaque types
        case .number:
            return false
            
        // optional versions of concrete types
        // -- core types
        case .blobOptional,
             .float32Optional,
             .int32Optional,
             .stringOptional:
            return true
            
        // -- extended types
        case .arrayOptional,
             .boolOptional,
             .characterOptional,
             .doubleOptional,
             .int64Optional,
             .impulseOptional,
             .midiOptional,
             .nullOptional,
             .stringAltOptional,
             .timeTagOptional:
            return true
            
        // -- opaque types
        case .numberOptional:
            return true
        }
    }
}

extension OSCValueToken {
    /// Returns the associated concrete return type.
    public var maskReturnType: OSCValueMaskable.Type {
        switch self {
        // core types
        case .blob,         .blobOptional:      return Data.self
        case .float32,      .float32Optional:   return Float32.self
        case .int32,        .int32Optional:     return Int32.self
        case .string,       .stringOptional:    return String.self

        // extended types
        case .array,        .arrayOptional:     return OSCArrayValue.self
        case .bool,         .boolOptional:      return Bool.self
        case .character,    .characterOptional: return Character.self
        case .double,       .doubleOptional:    return Double.self
        case .int64,        .int64Optional:     return Int64.self
        case .impulse,      .impulseOptional:   return OSCImpulseValue.self
        case .midi,         .midiOptional:      return OSCMIDIValue.self
        case .null,         .nullOptional:      return OSCNullValue.self
        case .stringAlt,    .stringAltOptional: return String.self
        case .timeTag,      .timeTagOptional:   return Int64.self

        // opaque types
        case .number,       .numberOptional:    return AnyOSCNumberValue.self
        }
    }
}
