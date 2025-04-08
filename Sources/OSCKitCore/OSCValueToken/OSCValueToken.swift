//
//  OSCValueToken.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// ``OSCValue`` type tokens, including optional variants and opaque types.
/// Useful for abstractions that mask sequences of values.
public enum OSCValueToken: Int, CaseIterable {
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
    /// Used when defining a mask to accept numeric value types
    /// (``int32``, ``float32``, ``double``, ``int64``) for an expected value placeholder.
    case number // accepts any OSC number type, but not Bool
    
    /// Meta type: Number or Boolean.
    /// Used when defining a mask to accept numeric value types
    /// (``int32``, ``float32``, ``double``, ``int64``, ``bool``) for an expected value placeholder.
    case numberOrBool // accepts any OSC number type or Bool
    
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
    /// Used when defining a mask to accept numeric value types
    /// (``int32``, ``float32``, ``double``, ``int64``) for an expected value placeholder.
    case numberOptional // accepts any OSC number type, but not Bool
    
    /// Meta type: Number or Boolean (Optional variant).
    /// Used when defining a mask to accept numeric value types
    /// (``int32``, ``float32``, ``double``, ``int64``, ``bool``) for an expected value placeholder.
    case numberOrBoolOptional // accepts any OSC number type or Bool
}

// MARK: - Equatable, Hashable

extension OSCValueToken: Equatable, Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - Sendable

extension OSCValueToken: Sendable { }

// MARK: - Properties

extension OSCValueToken {
    /// Returns base mask type (by stripping 'optional' component if present).
    public var baseType: Self {
        switch self {
        // core types
        case .blob,         .blobOptional:         .blob
        case .float32,      .float32Optional:      .float32
        case .int32,        .int32Optional:        .int32
        case .string,       .stringOptional:       .string
        // extended types
        case .array,        .arrayOptional:        .array
        case .bool,         .boolOptional:         .bool
        case .character,    .characterOptional:    .character
        case .double,       .doubleOptional:       .double
        case .int64,        .int64Optional:        .int64
        case .impulse,      .impulseOptional:      .impulse
        case .midi,         .midiOptional:         .midi
        case .null,         .nullOptional:         .null
        case .stringAlt,    .stringAltOptional:    .stringAlt
        case .timeTag,      .timeTagOptional:      .timeTag
        // opaque types
        case .number,       .numberOptional:       .number
        case .numberOrBool, .numberOrBoolOptional: .numberOrBool
        }
    }
    
    /// Returns `true` if a mask type instance is an 'optional' variant.
    public var isOptional: Bool {
        switch self {
        // concrete types
        // -- core types
        case .blob,
             .int32,
             .float32,
             .string:
            false
            
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
            
            false
            
        // opaque types
        case .number,
             .numberOrBool:
            false
            
        // optional versions of concrete types
        // -- core types
        case .blobOptional,
             .float32Optional,
             .int32Optional,
             .stringOptional:
            true
            
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
            true
            
        // -- opaque types
        case .numberOptional,
             .numberOrBoolOptional:
            true
        }
    }
}

extension OSCValueToken {
    /// Returns the associated concrete return type.
    public var maskReturnType: OSCValueMaskable.Type {
        switch self {
        // core types
        case .blob,         .blobOptional:         Data.self
        case .float32,      .float32Optional:      Float32.self
        case .int32,        .int32Optional:        Int32.self
        case .string,       .stringOptional:       String.self
        // extended types
        case .array,        .arrayOptional:        OSCArrayValue.self
        case .bool,         .boolOptional:         Bool.self
        case .character,    .characterOptional:    Character.self
        case .double,       .doubleOptional:       Double.self
        case .int64,        .int64Optional:        Int64.self
        case .impulse,      .impulseOptional:      OSCImpulseValue.self
        case .midi,         .midiOptional:         OSCMIDIValue.self
        case .null,         .nullOptional:         OSCNullValue.self
        case .stringAlt,    .stringAltOptional:    String.self
        case .timeTag,      .timeTagOptional:      Int64.self
        // opaque types
        case .number,       .numberOptional:       AnyOSCNumberValue.self
        case .numberOrBool, .numberOrBoolOptional: AnyOSCNumberValue.self
        }
    }
}
