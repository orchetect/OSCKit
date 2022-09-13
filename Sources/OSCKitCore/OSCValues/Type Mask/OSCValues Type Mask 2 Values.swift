//
//  OSCValues Type Mask 2 Values.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCValues {
    /// Returns the OSC value sequence as a strongly typed tuple
    /// if it matches the given mask of concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// A mask of up to 10 value types in sequence.
    ///
    /// Common usage:
    ///
    ///     // as a tuple
    ///     let tuple = try values.masked(String.self, Int.self)
    ///     print(tuple.0, tuple.1)
    ///
    ///     // unwrapped into local variables
    ///     let (string, int) = try values.masked(String.self, Int.self)
    ///     print(string, int)
    ///
    /// Basic examples:
    ///
    ///     // present optional value
    ///     ["Test", 123, Int32(456)].masked(String.self, Int32.self, Int32?.self)
    ///     tuple.0 // "Test" as String
    ///     tuple.1 // 123 as Int
    ///     tuple.2 // 456 as Int32?
    ///
    ///     // missing optional value
    ///     ["Test", 123].masked(String.self, Int32.self, Int32?.self)
    ///     tuple.0 // "Test" as String
    ///     tuple.1 // 123 as Int
    ///     tuple.2 // nil as Int32?
    ///
    ///     // mismatching types
    ///     [123, 456].masked(String.self, Int32.self)
    ///     // throws OSCValueMaskError.mismatchedTypes
    ///
    ///     // mismatched element count, regardless of types
    ///     [123, 456].masked(String.self, Int32.self, Int32.self)
    ///     // throws OSCValueMaskError.invalidCount
    ///
    /// `Int.self` is a special common-use interpolated type for convenience:
    ///
    ///     // any integer may match against Int.self and is converted to Int
    ///     [Int32(123) Int64(456)].masked(Int.self, Int.self)
    ///     tuple.0 // 123 as Int
    ///     tuple.1 // 456 as Int
    ///
    ///     // all other integer types must match themself exactly
    ///     [Int32(123) Int64(456)].masked(Int32.self, Int32.self)
    ///     // throws error; mask does not match
    ///
    ///     // same with optionals; specific integer types must match if present
    ///     [123, 456, 789].masked(String.self, Int.self, Int32?.self)
    ///     // throws error; mask does not match
    ///
    /// In addition to core OSC concrete types, various non-standard OSC types can be used and will be transparently encoded as their closest related OSC core type when encoding in an ``OSCMessage``.
    ///
    /// These types conform to the ``OSCInterpolatedValue`` protocol (which defines their core encoding value type) and may be used any where ``OSCValue`` is accepted.
    ///
    /// OSCKit provides conformance for a number of such common Swift Standard Library types: `Int8`, `Int16`, `UInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64`, `Float16`, `Float80`.
    ///
    /// (Note that `Int32`, `Int64`, `Float32` are already core `OSCValue` types.)
    ///
    ///     let values: OSCValues = [Int8(123), Int16(123)]
    ///
    /// `AnyOSCNumberValue` is a special type to match and box any OSC numeric value.
    ///
    ///     [Int8(123)]
    ///         .masked(AnyOSCNumberValue.self)
    ///         // (AnyOSCNumberValue(Int8(123)))
    ///
    ///     [Double(123.45)]
    ///         .masked(AnyOSCNumberValue.self)
    ///         // (AnyOSCNumberValue(Double(123.45)))
    ///
    ///     // which can be accessed as either typed:
    ///     AnyOSCNumberValue(Int8(123)).base // .int(Int8)
    ///
    ///     // or interpolated:
    ///     AnyOSCNumberValue(Int8(123)).intValue // 123 as Int
    ///     AnyOSCNumberValue(Int8(123)).doubleValue // 123.0 as Double
    ///
    /// One or more trailing types can also be expressed as as an `Optional` (ie: `Int32?.self`) which will match that value type or return `nil` if the value is missing in the base value array.
    ///
    /// Core OSC concrete types:
    /// - `Int32.self`
    /// - `Float32.self`
    /// - `String.self`
    /// - `Data.self` (a.k.a. OSC blob)
    /// - `OSCTimeTag.self`
    ///
    /// Extended (non-standard) OSC concrete types:
    /// - `Bool.self`
    /// - `Character.self`
    /// - `Int64.self`
    /// - `Double.self`
    /// - `OSCArrayValue.self`
    /// - `OSCImpulseValue.self`
    /// - `OSCMIDIValue.self`
    /// - `OSCNullValue.self`
    /// - `OSCStringAltValue.self`
    ///
    /// Interpolating concrete types for convenience:
    /// - `Int.self` (converts from any OSC integer types)
    ///
    /// Opaque types:
    /// - `AnyOSCNumberValue.self` (boxes any OSC integer or float number)
    ///
    /// - Throws: ``OSCValueMaskError``
    @inlinable
    public func masked<V0, V1>(
        _ v0: V0.Type,
        _ v1: V1.Type
    ) throws -> (V0, V1)
        where V0: OSCValueMaskable,
        V1: OSCValueMaskable
    {
        try validateCount(2)
        let v0 = try unwrapValue(v0.self, index: 0)
        let v1 = try unwrapValue(v1.self, index: 1)
        return (v0, v1)
    }

    /// Returns the OSC value sequence as a strongly typed tuple
    /// if it matches the given mask of concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// A mask of up to 10 value types in sequence.
    ///
    /// Common usage:
    ///
    ///     // as a tuple
    ///     let tuple = try values.masked(String.self, Int.self)
    ///     print(tuple.0, tuple.1)
    ///
    ///     // unwrapped into local variables
    ///     let (string, int) = try values.masked(String.self, Int.self)
    ///     print(string, int)
    ///
    /// Basic examples:
    ///
    ///     // present optional value
    ///     ["Test", 123, Int32(456)].masked(String.self, Int32.self, Int32?.self)
    ///     tuple.0 // "Test" as String
    ///     tuple.1 // 123 as Int
    ///     tuple.2 // 456 as Int32?
    ///
    ///     // missing optional value
    ///     ["Test", 123].masked(String.self, Int32.self, Int32?.self)
    ///     tuple.0 // "Test" as String
    ///     tuple.1 // 123 as Int
    ///     tuple.2 // nil as Int32?
    ///
    ///     // mismatching types
    ///     [123, 456].masked(String.self, Int32.self)
    ///     // throws OSCValueMaskError.mismatchedTypes
    ///
    ///     // mismatched element count, regardless of types
    ///     [123, 456].masked(String.self, Int32.self, Int32.self)
    ///     // throws OSCValueMaskError.invalidCount
    ///
    /// `Int.self` is a special common-use interpolated type for convenience:
    ///
    ///     // any integer may match against Int.self and is converted to Int
    ///     [Int32(123) Int64(456)].masked(Int.self, Int.self)
    ///     tuple.0 // 123 as Int
    ///     tuple.1 // 456 as Int
    ///
    ///     // all other integer types must match themself exactly
    ///     [Int32(123) Int64(456)].masked(Int32.self, Int32.self)
    ///     // throws error; mask does not match
    ///
    ///     // same with optionals; specific integer types must match if present
    ///     [123, 456, 789].masked(String.self, Int.self, Int32?.self)
    ///     // throws error; mask does not match
    ///
    /// In addition to core OSC concrete types, various non-standard OSC types can be used and will be transparently encoded as their closest related OSC core type when encoding in an ``OSCMessage``.
    ///
    /// These types conform to the ``OSCInterpolatedValue`` protocol (which defines their core encoding value type) and may be used any where ``OSCValue`` is accepted.
    ///
    /// OSCKit provides conformance for a number of such common Swift Standard Library types: `Int8`, `Int16`, `UInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64`, `Float16`, `Float80`.
    ///
    /// (Note that `Int32`, `Int64`, `Float32` are already core `OSCValue` types.)
    ///
    ///     let values: OSCValues = [Int8(123), Int16(123)]
    ///
    /// `AnyOSCNumberValue` is a special type to match and box any OSC numeric value.
    ///
    ///     [Int8(123)]
    ///         .masked(AnyOSCNumberValue.self)
    ///         // (AnyOSCNumberValue(Int8(123)))
    ///
    ///     [Double(123.45)]
    ///         .masked(AnyOSCNumberValue.self)
    ///         // (AnyOSCNumberValue(Double(123.45)))
    ///
    ///     // which can be accessed as either typed:
    ///     AnyOSCNumberValue(Int8(123)).base // .int(Int8)
    ///
    ///     // or interpolated:
    ///     AnyOSCNumberValue(Int8(123)).intValue // 123 as Int
    ///     AnyOSCNumberValue(Int8(123)).doubleValue // 123.0 as Double
    ///
    /// One or more trailing types can also be expressed as as an `Optional` (ie: `Int32?.self`) which will match that value type or return `nil` if the value is missing in the base value array.
    ///
    /// Core OSC concrete types:
    /// - `Int32.self`
    /// - `Float32.self`
    /// - `String.self`
    /// - `Data.self` (a.k.a. OSC blob)
    /// - `OSCTimeTag.self`
    ///
    /// Extended (non-standard) OSC concrete types:
    /// - `Bool.self`
    /// - `Character.self`
    /// - `Int64.self`
    /// - `Double.self`
    /// - `OSCArrayValue.self`
    /// - `OSCImpulseValue.self`
    /// - `OSCMIDIValue.self`
    /// - `OSCNullValue.self`
    /// - `OSCStringAltValue.self`
    ///
    /// Interpolating concrete types for convenience:
    /// - `Int.self` (converts from any OSC integer types)
    ///
    /// Opaque types:
    /// - `AnyOSCNumberValue.self` (boxes any OSC integer or float number)
    ///
    /// - Throws: ``OSCValueMaskError``
    @inlinable
    public func masked<V0, V1>(
        _ v0: V0.Type,
        _ v1: V1?.Type
    ) throws -> (V0, V1?)
        where V0: OSCValueMaskable,
        V1: OSCValueMaskable
    {
        try validateCount(1 ... 2)
        let v0 = try unwrapValue(v0.self, index: 0)
        let v1 = try unwrapValue(v1.self, index: 1)
        return (v0, v1)
    }

    /// Returns the OSC value sequence as a strongly typed tuple
    /// if it matches the given mask of concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// A mask of up to 10 value types in sequence.
    ///
    /// Common usage:
    ///
    ///     // as a tuple
    ///     let tuple = try values.masked(String.self, Int.self)
    ///     print(tuple.0, tuple.1)
    ///
    ///     // unwrapped into local variables
    ///     let (string, int) = try values.masked(String.self, Int.self)
    ///     print(string, int)
    ///
    /// Basic examples:
    ///
    ///     // present optional value
    ///     ["Test", 123, Int32(456)].masked(String.self, Int32.self, Int32?.self)
    ///     tuple.0 // "Test" as String
    ///     tuple.1 // 123 as Int
    ///     tuple.2 // 456 as Int32?
    ///
    ///     // missing optional value
    ///     ["Test", 123].masked(String.self, Int32.self, Int32?.self)
    ///     tuple.0 // "Test" as String
    ///     tuple.1 // 123 as Int
    ///     tuple.2 // nil as Int32?
    ///
    ///     // mismatching types
    ///     [123, 456].masked(String.self, Int32.self)
    ///     // throws OSCValueMaskError.mismatchedTypes
    ///
    ///     // mismatched element count, regardless of types
    ///     [123, 456].masked(String.self, Int32.self, Int32.self)
    ///     // throws OSCValueMaskError.invalidCount
    ///
    /// `Int.self` is a special common-use interpolated type for convenience:
    ///
    ///     // any integer may match against Int.self and is converted to Int
    ///     [Int32(123) Int64(456)].masked(Int.self, Int.self)
    ///     tuple.0 // 123 as Int
    ///     tuple.1 // 456 as Int
    ///
    ///     // all other integer types must match themself exactly
    ///     [Int32(123) Int64(456)].masked(Int32.self, Int32.self)
    ///     // throws error; mask does not match
    ///
    ///     // same with optionals; specific integer types must match if present
    ///     [123, 456, 789].masked(String.self, Int.self, Int32?.self)
    ///     // throws error; mask does not match
    ///
    /// In addition to core OSC concrete types, various non-standard OSC types can be used and will be transparently encoded as their closest related OSC core type when encoding in an ``OSCMessage``.
    ///
    /// These types conform to the ``OSCInterpolatedValue`` protocol (which defines their core encoding value type) and may be used any where ``OSCValue`` is accepted.
    ///
    /// OSCKit provides conformance for a number of such common Swift Standard Library types: `Int8`, `Int16`, `UInt`, `UInt8`, `UInt16`, `UInt32`, `UInt64`, `Float16`, `Float80`.
    ///
    /// (Note that `Int32`, `Int64`, `Float32` are already core `OSCValue` types.)
    ///
    ///     let values: OSCValues = [Int8(123), Int16(123)]
    ///
    /// `AnyOSCNumberValue` is a special type to match and box any OSC numeric value.
    ///
    ///     [Int8(123)]
    ///         .masked(AnyOSCNumberValue.self)
    ///         // (AnyOSCNumberValue(Int8(123)))
    ///
    ///     [Double(123.45)]
    ///         .masked(AnyOSCNumberValue.self)
    ///         // (AnyOSCNumberValue(Double(123.45)))
    ///
    ///     // which can be accessed as either typed:
    ///     AnyOSCNumberValue(Int8(123)).base // .int(Int8)
    ///
    ///     // or interpolated:
    ///     AnyOSCNumberValue(Int8(123)).intValue // 123 as Int
    ///     AnyOSCNumberValue(Int8(123)).doubleValue // 123.0 as Double
    ///
    /// One or more trailing types can also be expressed as as an `Optional` (ie: `Int32?.self`) which will match that value type or return `nil` if the value is missing in the base value array.
    ///
    /// Core OSC concrete types:
    /// - `Int32.self`
    /// - `Float32.self`
    /// - `String.self`
    /// - `Data.self` (a.k.a. OSC blob)
    /// - `OSCTimeTag.self`
    ///
    /// Extended (non-standard) OSC concrete types:
    /// - `Bool.self`
    /// - `Character.self`
    /// - `Int64.self`
    /// - `Double.self`
    /// - `OSCArrayValue.self`
    /// - `OSCImpulseValue.self`
    /// - `OSCMIDIValue.self`
    /// - `OSCNullValue.self`
    /// - `OSCStringAltValue.self`
    ///
    /// Interpolating concrete types for convenience:
    /// - `Int.self` (converts from any OSC integer types)
    ///
    /// Opaque types:
    /// - `AnyOSCNumberValue.self` (boxes any OSC integer or float number)
    ///
    /// - Throws: ``OSCValueMaskError``
    @inlinable
    public func masked<V0, V1>(
        _ v0: V0?.Type,
        _ v1: V1?.Type
    ) throws -> (V0?, V1?)
        where V0: OSCValueMaskable,
        V1: OSCValueMaskable
    {
        try validateCount(0 ... 2)
        let v0 = try unwrapValue(v0.self, index: 0)
        let v1 = try unwrapValue(v1.self, index: 1)
        return (v0, v1)
    }
}
