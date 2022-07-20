//
//  Concrete Type Masks.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

// MARK: - 1 Value

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V>(mask v: V.Type)
    throws -> V
    where V : OSCMessageValueProtocol
    {
        try validateCount(1)
        let v = try unwrapValue(v.self, index: 0)
        return v
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V>(mask v: V?.Type) throws -> V?
    where V : OSCMessageValueProtocol
    {
        try validateCount(0...1)
        let v = try unwrapValue(v.self, index: 0)
        return v
    }
    
}

// MARK: - 2 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1>(mask v0: V0.Type,
                        _ v1: V1.Type)
    throws -> (V0, V1)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol
    {
        try validateCount(2)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        return (v0, v1)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1>(mask v0: V0.Type,
                        _ v1: V1?.Type)
    throws -> (V0, V1?)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol
    {
        try validateCount(1...2)
        let v0 = try unwrapValue(v0.self, index: 0)
        let v1 = try unwrapValue(v1.self, index: 1)
        return (v0, v1)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1>(mask v0: V0?.Type,
                        _ v1: V1?.Type)
    throws -> (V0?, V1?)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol
    {
        try validateCount(0...2)
        let v0 = try unwrapValue(v0.self, index: 0)
        let v1 = try unwrapValue(v1.self, index: 1)
        return (v0, v1)
    }
    
}

// MARK: - 3 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2>(mask v0: V0.Type,
                            _ v1: V1.Type,
                            _ v2: V2.Type)
    throws -> (V0, V1, V2)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol,
          V2 : OSCMessageValueProtocol
    {
        try validateCount(3)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        return (v0, v1, v2)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2>(mask v0: V0.Type,
                            _ v1: V1.Type,
                            _ v2: V2?.Type)
    throws -> (V0, V1, V2?)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol,
          V2 : OSCMessageValueProtocol
    {
        try validateCount(2...3)
        let v0 = try unwrapValue(v0.self, index: 0)
        let v1 = try unwrapValue(v1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        return (v0, v1, v2)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2>(mask v0: V0.Type,
                            _ v1: V1?.Type,
                            _ v2: V2?.Type)
    throws -> (V0, V1?, V2?)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol,
          V2 : OSCMessageValueProtocol
    {
        try validateCount(1...3)
        let v0 = try unwrapValue(v0.self, index: 0)
        let v1 = try unwrapValue(v1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        return (v0, v1, v2)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2>(mask v0: V0?.Type,
                            _ v1: V1?.Type,
                            _ v2: V2?.Type)
    throws -> (V0?, V1?, V2?)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol,
          V2 : OSCMessageValueProtocol
    {
        try validateCount(0...3)
        let v0 = try unwrapValue(v0.self, index: 0)
        let v1 = try unwrapValue(v1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        return (v0, v1, v2)
    }
    
}

// MARK: - 4 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3>(mask v0: V0.Type,
                                _ v1: V1.Type,
                                _ v2: V2.Type,
                                _ v3: V3.Type)
    throws -> (V0, V1, V2, V3)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol,
          V2 : OSCMessageValueProtocol,
          V3 : OSCMessageValueProtocol
    {
        try validateCount(4)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        return (v0, v1, v2, v3)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3>(mask v0: V0.Type,
                                _ v1: V1.Type,
                                _ v2: V2.Type,
                                _ v3: V3?.Type)
    throws -> (V0, V1, V2, V3?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol
    {
        try validateCount(3...4)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        return (v0, v1, v2, v3)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3>(mask v0: V0.Type,
                                _ v1: V1.Type,
                                _ v2: V2?.Type,
                                _ v3: V3?.Type)
    throws -> (V0, V1, V2?, V3?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol
    {
        try validateCount(2...4)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        return (v0, v1, v2, v3)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3>(mask v0: V0.Type,
                                _ v1: V1?.Type,
                                _ v2: V2?.Type,
                                _ v3: V3?.Type)
    throws -> (V0, V1?, V2?, V3?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol
    {
        try validateCount(1...4)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        return (v0, v1, v2, v3)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3>(mask v0: V0?.Type,
                                _ v1: V1?.Type,
                                _ v2: V2?.Type,
                                _ v3: V3?.Type)
    throws -> (V0?, V1?, V2?, V3?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol
    {
        try validateCount(0...4)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        return (v0, v1, v2, v3)
    }
    
}

// MARK: - 5 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4>(mask v0: V0.Type,
                                    _ v1: V1.Type,
                                    _ v2: V2.Type,
                                    _ v3: V3.Type,
                                    _ v4: V4.Type)
    throws -> (V0, V1, V2, V3, V4)
    where V0 : OSCMessageValueProtocol,
          V1 : OSCMessageValueProtocol,
          V2 : OSCMessageValueProtocol,
          V3 : OSCMessageValueProtocol,
          V4 : OSCMessageValueProtocol
    {
        try validateCount(5)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        return (v0, v1, v2, v3, v4)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4>(mask v0: V0.Type,
                                    _ v1: V1.Type,
                                    _ v2: V2.Type,
                                    _ v3: V3.Type,
                                    _ v4: V4?.Type)
    throws -> (V0, V1, V2, V3, V4?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol
    {
        try validateCount(4...5)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        return (v0, v1, v2, v3, v4)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4>(mask v0: V0.Type,
                                    _ v1: V1.Type,
                                    _ v2: V2.Type,
                                    _ v3: V3?.Type,
                                    _ v4: V4?.Type)
    throws -> (V0, V1, V2, V3?, V4?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol
    {
        try validateCount(3...5)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        return (v0, v1, v2, v3, v4)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4>(mask v0: V0.Type,
                                    _ v1: V1.Type,
                                    _ v2: V2?.Type,
                                    _ v3: V3?.Type,
                                    _ v4: V4?.Type)
    throws -> (V0, V1, V2?, V3?, V4?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol
    {
        try validateCount(2...5)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        return (v0, v1, v2, v3, v4)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4>(mask v0: V0.Type,
                                    _ v1: V1?.Type,
                                    _ v2: V2?.Type,
                                    _ v3: V3?.Type,
                                    _ v4: V4?.Type)
    throws -> (V0, V1?, V2?, V3?, V4?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol
    {
        try validateCount(1...5)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        return (v0, v1, v2, v3, v4)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4>(mask v0: V0?.Type,
                                    _ v1: V1?.Type,
                                    _ v2: V2?.Type,
                                    _ v3: V3?.Type,
                                    _ v4: V4?.Type)
    throws -> (V0?, V1?, V2?, V3?, V4?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol
    {
        try validateCount(0...5)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        return (v0, v1, v2, v3, v4)
    }
    
}

// MARK: - 6 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5>(mask v0: V0.Type,
                                        _ v1: V1.Type,
                                        _ v2: V2.Type,
                                        _ v3: V3.Type,
                                        _ v4: V4.Type,
                                        _ v5: V5.Type)
    throws -> (V0, V1, V2, V3, V4, V5)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol
    {
        try validateCount(6)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        return (v0, v1, v2, v3, v4, v5)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5>(mask v0: V0.Type,
                                        _ v1: V1.Type,
                                        _ v2: V2.Type,
                                        _ v3: V3.Type,
                                        _ v4: V4.Type,
                                        _ v5: V5?.Type)
    throws -> (V0, V1, V2, V3, V4, V5?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol
    {
        try validateCount(5...6)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        return (v0, v1, v2, v3, v4, v5)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5>(mask v0: V0.Type,
                                        _ v1: V1.Type,
                                        _ v2: V2.Type,
                                        _ v3: V3.Type,
                                        _ v4: V4?.Type,
                                        _ v5: V5?.Type)
    throws -> (V0, V1, V2, V3, V4?, V5?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol
    {
        try validateCount(4...6)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        return (v0, v1, v2, v3, v4, v5)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5>(mask v0: V0.Type,
                                        _ v1: V1.Type,
                                        _ v2: V2.Type,
                                        _ v3: V3?.Type,
                                        _ v4: V4?.Type,
                                        _ v5: V5?.Type)
    throws -> (V0, V1, V2, V3?, V4?, V5?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol
    {
        try validateCount(3...6)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        return (v0, v1, v2, v3, v4, v5)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5>(mask v0: V0.Type,
                                        _ v1: V1.Type,
                                        _ v2: V2?.Type,
                                        _ v3: V3?.Type,
                                        _ v4: V4?.Type,
                                        _ v5: V5?.Type)
    throws -> (V0, V1, V2?, V3?, V4?, V5?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol
    {
        try validateCount(2...6)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        return (v0, v1, v2, v3, v4, v5)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5>(mask v0: V0.Type,
                                        _ v1: V1?.Type,
                                        _ v2: V2?.Type,
                                        _ v3: V3?.Type,
                                        _ v4: V4?.Type,
                                        _ v5: V5?.Type)
    throws -> (V0, V1?, V2?, V3?, V4?, V5?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol
    {
        try validateCount(1...6)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        return (v0, v1, v2, v3, v4, v5)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5>(mask v0: V0?.Type,
                                        _ v1: V1?.Type,
                                        _ v2: V2?.Type,
                                        _ v3: V3?.Type,
                                        _ v4: V4?.Type,
                                        _ v5: V5?.Type)
    throws -> (V0?, V1?, V2?, V3?, V4?, V5?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol
    {
        try validateCount(0...6)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        return (v0, v1, v2, v3, v4, v5)
    }
    
}

// MARK: - 7 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6>(mask v0: V0.Type,
                                            _ v1: V1.Type,
                                            _ v2: V2.Type,
                                            _ v3: V3.Type,
                                            _ v4: V4.Type,
                                            _ v5: V5.Type,
                                            _ v6: V6.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol
    {
        try validateCount(7)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6>(mask v0: V0.Type,
                                            _ v1: V1.Type,
                                            _ v2: V2.Type,
                                            _ v3: V3.Type,
                                            _ v4: V4.Type,
                                            _ v5: V5.Type,
                                            _ v6: V6?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol
    {
        try validateCount(6...7)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6>(mask v0: V0.Type,
                                            _ v1: V1.Type,
                                            _ v2: V2.Type,
                                            _ v3: V3.Type,
                                            _ v4: V4.Type,
                                            _ v5: V5?.Type,
                                            _ v6: V6?.Type)
    throws -> (V0, V1, V2, V3, V4, V5?, V6?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol
    {
        try validateCount(5...7)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6>(mask v0: V0.Type,
                                            _ v1: V1.Type,
                                            _ v2: V2.Type,
                                            _ v3: V3.Type,
                                            _ v4: V4?.Type,
                                            _ v5: V5?.Type,
                                            _ v6: V6?.Type)
    throws -> (V0, V1, V2, V3, V4?, V5?, V6?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol
    {
        try validateCount(4...7)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6>(mask v0: V0.Type,
                                            _ v1: V1.Type,
                                            _ v2: V2.Type,
                                            _ v3: V3?.Type,
                                            _ v4: V4?.Type,
                                            _ v5: V5?.Type,
                                            _ v6: V6?.Type)
    throws -> (V0, V1, V2, V3?, V4?, V5?, V6?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol
    {
        try validateCount(3...7)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6>(mask v0: V0.Type,
                                            _ v1: V1.Type,
                                            _ v2: V2?.Type,
                                            _ v3: V3?.Type,
                                            _ v4: V4?.Type,
                                            _ v5: V5?.Type,
                                            _ v6: V6?.Type)
    throws -> (V0, V1, V2?, V3?, V4?, V5?, V6?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol
    {
        try validateCount(2...7)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6>(mask v0: V0.Type,
                                            _ v1: V1?.Type,
                                            _ v2: V2?.Type,
                                            _ v3: V3?.Type,
                                            _ v4: V4?.Type,
                                            _ v5: V5?.Type,
                                            _ v6: V6?.Type)
    throws -> (V0, V1?, V2?, V3?, V4?, V5?, V6?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol
    {
        try validateCount(1...7)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6>(mask v0: V0?.Type,
                                            _ v1: V1?.Type,
                                            _ v2: V2?.Type,
                                            _ v3: V3?.Type,
                                            _ v4: V4?.Type,
                                            _ v5: V5?.Type,
                                            _ v6: V6?.Type)
    throws -> (V0?, V1?, V2?, V3?, V4?, V5?, V6?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol
    {
        try validateCount(0...7)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        return (v0, v1, v2, v3, v4, v5, v6)
    }
    
}

// MARK: - 8 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0.Type,
                                                _ v1: V1.Type,
                                                _ v2: V2.Type,
                                                _ v3: V3.Type,
                                                _ v4: V4.Type,
                                                _ v5: V5.Type,
                                                _ v6: V6.Type,
                                                _ v7: V7.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0.Type,
                                                _ v1: V1.Type,
                                                _ v2: V2.Type,
                                                _ v3: V3.Type,
                                                _ v4: V4.Type,
                                                _ v5: V5.Type,
                                                _ v6: V6.Type,
                                                _ v7: V7?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(7...8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0.Type,
                                                _ v1: V1.Type,
                                                _ v2: V2.Type,
                                                _ v3: V3.Type,
                                                _ v4: V4.Type,
                                                _ v5: V5.Type,
                                                _ v6: V6?.Type,
                                                _ v7: V7?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6?, V7?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(6...8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0.Type,
                                                _ v1: V1.Type,
                                                _ v2: V2.Type,
                                                _ v3: V3.Type,
                                                _ v4: V4.Type,
                                                _ v5: V5?.Type,
                                                _ v6: V6?.Type,
                                                _ v7: V7?.Type)
    throws -> (V0, V1, V2, V3, V4, V5?, V6?, V7?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(5...8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0.Type,
                                                _ v1: V1.Type,
                                                _ v2: V2.Type,
                                                _ v3: V3.Type,
                                                _ v4: V4?.Type,
                                                _ v5: V5?.Type,
                                                _ v6: V6?.Type,
                                                _ v7: V7?.Type)
    throws -> (V0, V1, V2, V3, V4?, V5?, V6?, V7?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(4...8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0.Type,
                                                _ v1: V1.Type,
                                                _ v2: V2.Type,
                                                _ v3: V3?.Type,
                                                _ v4: V4?.Type,
                                                _ v5: V5?.Type,
                                                _ v6: V6?.Type,
                                                _ v7: V7?.Type)
    throws -> (V0, V1, V2, V3?, V4?, V5?, V6?, V7?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(3...8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0.Type,
                                                _ v1: V1.Type,
                                                _ v2: V2?.Type,
                                                _ v3: V3?.Type,
                                                _ v4: V4?.Type,
                                                _ v5: V5?.Type,
                                                _ v6: V6?.Type,
                                                _ v7: V7?.Type)
    throws -> (V0, V1, V2?, V3?, V4?, V5?, V6?, V7?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(2...8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0.Type,
                                                _ v1: V1?.Type,
                                                _ v2: V2?.Type,
                                                _ v3: V3?.Type,
                                                _ v4: V4?.Type,
                                                _ v5: V5?.Type,
                                                _ v6: V6?.Type,
                                                _ v7: V7?.Type)
    throws -> (V0, V1?, V2?, V3?, V4?, V5?, V6?, V7?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(1...8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7>(mask v0: V0?.Type,
                                                _ v1: V1?.Type,
                                                _ v2: V2?.Type,
                                                _ v3: V3?.Type,
                                                _ v4: V4?.Type,
                                                _ v5: V5?.Type,
                                                _ v6: V6?.Type,
                                                _ v7: V7?.Type)
    throws -> (V0?, V1?, V2?, V3?, V4?, V5?, V6?, V7?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol
    {
        try validateCount(0...8)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        return (v0, v1, v2, v3, v4, v5, v6, v7)
    }
    
}

// MARK: - 9 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1.Type,
                                                    _ v2: V2.Type,
                                                    _ v3: V3.Type,
                                                    _ v4: V4.Type,
                                                    _ v5: V5.Type,
                                                    _ v6: V6.Type,
                                                    _ v7: V7.Type,
                                                    _ v8: V8.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7, V8)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1.Type,
                                                    _ v2: V2.Type,
                                                    _ v3: V3.Type,
                                                    _ v4: V4.Type,
                                                    _ v5: V5.Type,
                                                    _ v6: V6.Type,
                                                    _ v7: V7.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(8...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1.Type,
                                                    _ v2: V2.Type,
                                                    _ v3: V3.Type,
                                                    _ v4: V4.Type,
                                                    _ v5: V5.Type,
                                                    _ v6: V6.Type,
                                                    _ v7: V7?.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7?, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(7...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1.Type,
                                                    _ v2: V2.Type,
                                                    _ v3: V3.Type,
                                                    _ v4: V4.Type,
                                                    _ v5: V5.Type,
                                                    _ v6: V6?.Type,
                                                    _ v7: V7?.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6?, V7?, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(6...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1.Type,
                                                    _ v2: V2.Type,
                                                    _ v3: V3.Type,
                                                    _ v4: V4.Type,
                                                    _ v5: V5?.Type,
                                                    _ v6: V6?.Type,
                                                    _ v7: V7?.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0, V1, V2, V3, V4, V5?, V6?, V7?, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(5...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1.Type,
                                                    _ v2: V2.Type,
                                                    _ v3: V3.Type,
                                                    _ v4: V4?.Type,
                                                    _ v5: V5?.Type,
                                                    _ v6: V6?.Type,
                                                    _ v7: V7?.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0, V1, V2, V3, V4?, V5?, V6?, V7?, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(4...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1.Type,
                                                    _ v2: V2.Type,
                                                    _ v3: V3?.Type,
                                                    _ v4: V4?.Type,
                                                    _ v5: V5?.Type,
                                                    _ v6: V6?.Type,
                                                    _ v7: V7?.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0, V1, V2, V3?, V4?, V5?, V6?, V7?, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(3...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1.Type,
                                                    _ v2: V2?.Type,
                                                    _ v3: V3?.Type,
                                                    _ v4: V4?.Type,
                                                    _ v5: V5?.Type,
                                                    _ v6: V6?.Type,
                                                    _ v7: V7?.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0, V1, V2?, V3?, V4?, V5?, V6?, V7?, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(2...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0.Type,
                                                    _ v1: V1?.Type,
                                                    _ v2: V2?.Type,
                                                    _ v3: V3?.Type,
                                                    _ v4: V4?.Type,
                                                    _ v5: V5?.Type,
                                                    _ v6: V6?.Type,
                                                    _ v7: V7?.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0, V1?, V2?, V3?, V4?, V5?, V6?, V7?, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(1...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8>(mask v0: V0?.Type,
                                                    _ v1: V1?.Type,
                                                    _ v2: V2?.Type,
                                                    _ v3: V3?.Type,
                                                    _ v4: V4?.Type,
                                                    _ v5: V5?.Type,
                                                    _ v6: V6?.Type,
                                                    _ v7: V7?.Type,
                                                    _ v8: V8?.Type)
    throws -> (V0?, V1?, V2?, V3?, V4?, V5?, V6?, V7?, V8?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol
    {
        try validateCount(0...9)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8)
    }
    
}

// MARK: - 10 Values

public extension Array where Element == OSCMessageValue {
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2.Type,
                                                        _ v3: V3.Type,
                                                        _ v4: V4.Type,
                                                        _ v5: V5.Type,
                                                        _ v6: V6.Type,
                                                        _ v7: V7.Type,
                                                        _ v8: V8.Type,
                                                        _ v9: V9.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7, V8, V9)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2.Type,
                                                        _ v3: V3.Type,
                                                        _ v4: V4.Type,
                                                        _ v5: V5.Type,
                                                        _ v6: V6.Type,
                                                        _ v7: V7.Type,
                                                        _ v8: V8.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7, V8, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(9...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2.Type,
                                                        _ v3: V3.Type,
                                                        _ v4: V4.Type,
                                                        _ v5: V5.Type,
                                                        _ v6: V6.Type,
                                                        _ v7: V7.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(8...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2.Type,
                                                        _ v3: V3.Type,
                                                        _ v4: V4.Type,
                                                        _ v5: V5.Type,
                                                        _ v6: V6.Type,
                                                        _ v7: V7?.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6, V7?, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(7...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2.Type,
                                                        _ v3: V3.Type,
                                                        _ v4: V4.Type,
                                                        _ v5: V5.Type,
                                                        _ v6: V6?.Type,
                                                        _ v7: V7?.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1, V2, V3, V4, V5, V6?, V7?, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(6...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2.Type,
                                                        _ v3: V3.Type,
                                                        _ v4: V4.Type,
                                                        _ v5: V5?.Type,
                                                        _ v6: V6?.Type,
                                                        _ v7: V7?.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1, V2, V3, V4, V5?, V6?, V7?, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(5...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2.Type,
                                                        _ v3: V3.Type,
                                                        _ v4: V4?.Type,
                                                        _ v5: V5?.Type,
                                                        _ v6: V6?.Type,
                                                        _ v7: V7?.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1, V2, V3, V4?, V5?, V6?, V7?, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(4...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2.Type,
                                                        _ v3: V3?.Type,
                                                        _ v4: V4?.Type,
                                                        _ v5: V5?.Type,
                                                        _ v6: V6?.Type,
                                                        _ v7: V7?.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1, V2, V3?, V4?, V5?, V6?, V7?, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(3...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1.Type,
                                                        _ v2: V2?.Type,
                                                        _ v3: V3?.Type,
                                                        _ v4: V4?.Type,
                                                        _ v5: V5?.Type,
                                                        _ v6: V6?.Type,
                                                        _ v7: V7?.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1, V2?, V3?, V4?, V5?, V6?, V7?, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(2...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0.Type,
                                                        _ v1: V1?.Type,
                                                        _ v2: V2?.Type,
                                                        _ v3: V3?.Type,
                                                        _ v4: V4?.Type,
                                                        _ v5: V5?.Type,
                                                        _ v6: V6?.Type,
                                                        _ v7: V7?.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0, V1?, V2?, V3?, V4?, V5?, V6?, V7?, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(1...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
    /// Returns the OSC value sequence as concrete value types.
    /// If the value types do not match the mask, an error is thrown.
    ///
    /// Any concrete type can also be used as as an Optional (ie: `Int32?.self`) to either match that value type or return `nil` the value is missing in the designated position in the value array.
    ///
    /// Core concrete types:
    /// - `Int32.self` (matches `.int32`)
    /// - `Float32.self` (matches `.float32`)
    /// - `ASCIIString.self` (matches `.string` and `.stringAlt`)
    /// - `Data.self` (matches `.data`)
    ///
    /// Extended concrete types:
    /// - `Int64.self` (matches `.int64`, `.timeTag`)
    /// - `Double.self` (matches `.double`)
    /// - `ASCIICharacter.self` (matches `.character`)
    /// - `OSCMessageValue.MIDIMessage.self` (matches `.midi`)
    /// - `Bool.self` (matches `.bool`)
    /// - `NSNull.self` (matches `.null`)
    ///
    /// Meta types:
    /// - `OSCMessageValue.Number.self` (matches `.int32`, `.float32`, `.double`, `.int64`)
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func values<V0, V1, V2, V3, V4, V5, V6, V7, V8, V9>(mask v0: V0?.Type,
                                                        _ v1: V1?.Type,
                                                        _ v2: V2?.Type,
                                                        _ v3: V3?.Type,
                                                        _ v4: V4?.Type,
                                                        _ v5: V5?.Type,
                                                        _ v6: V6?.Type,
                                                        _ v7: V7?.Type,
                                                        _ v8: V8?.Type,
                                                        _ v9: V9?.Type)
    throws -> (V0?, V1?, V2?, V3?, V4?, V5?, V6?, V7?, V8?, V9?)
    where V0 : OSCMessageValueProtocol,
    V1 : OSCMessageValueProtocol,
    V2 : OSCMessageValueProtocol,
    V3 : OSCMessageValueProtocol,
    V4 : OSCMessageValueProtocol,
    V5 : OSCMessageValueProtocol,
    V6 : OSCMessageValueProtocol,
    V7 : OSCMessageValueProtocol,
    V8 : OSCMessageValueProtocol,
    V9 : OSCMessageValueProtocol
    {
        try validateCount(0...10)
        let v0 = try unwrapValue(V0.self, index: 0)
        let v1 = try unwrapValue(V1.self, index: 1)
        let v2 = try unwrapValue(v2.self, index: 2)
        let v3 = try unwrapValue(v3.self, index: 3)
        let v4 = try unwrapValue(v4.self, index: 4)
        let v5 = try unwrapValue(v5.self, index: 5)
        let v6 = try unwrapValue(v6.self, index: 6)
        let v7 = try unwrapValue(v7.self, index: 7)
        let v8 = try unwrapValue(v8.self, index: 8)
        let v9 = try unwrapValue(v9.self, index: 9)
        return (v0, v1, v2, v3, v4, v5, v6, v7, v8, v9)
    }
    
}

// MARK: - Helpers

internal extension Array where Element == OSCMessageValue {
    
    @usableFromInline
    func validateCount(_ validCount: Index) throws {
        
        guard count == validCount else {
            throw OSCMessage.ValueMask.MaskError.invalidCount
        }
        
    }
    
    @usableFromInline
    func validateCount(_ validRange: ClosedRange<Index>) throws {
        
        guard validRange.contains(count) else {
            throw OSCMessage.ValueMask.MaskError.invalidCount
        }
        
    }
    
    @usableFromInline
    func unwrapValue<T>(_ type: T.Type,
                                 index: Index) throws -> T
    where T : OSCMessageValueProtocol
    {
        
        guard indices.contains(index) else {
            throw OSCMessage.ValueMask.MaskError.invalidCount
        }
        
        switch T.self {
        case is OSCMessageValue.Number.Type:
            switch self[index] {
                // core types
            case let .int32(v):     return OSCMessageValue.Number.int32(v) as! T
            case let .float32(v):   return OSCMessageValue.Number.float32(v) as! T
                
                // extended types
            case let .int64(v):     return OSCMessageValue.Number.int64(v) as! T
            case let .double(v):    return OSCMessageValue.Number.double(v) as! T
            default: break
            }
            
        default:
            switch self[index] {
                // core types
            case let .int32(v):     if let typed = v as? T { return typed }
            case let .float32(v):   if let typed = v as? T { return typed }
            case let .string(v):    if let typed = v as? T { return typed }
            case let .blob(v):      if let typed = v as? T { return typed }
                
                // extended types
            case let .int64(v):     if let typed = v as? T { return typed }
            case let .timeTag(v):   if let typed = v as? T { return typed }
            case let .double(v):    if let typed = v as? T { return typed }
            case let .stringAlt(v): if let typed = v as? T { return typed }
            case let .character(v): if let typed = v as? T { return typed }
            case let .midi(v):      if let typed = v as? T { return typed }
            case let .bool(v):      if let typed = v as? T { return typed }
            case .null:             if let typed = NSNull() as? T { return typed }
            }
        }
        
        throw OSCMessage.ValueMask.MaskError.mismatchedTypes
        
    }
    
    @usableFromInline
    func unwrapValue<T>(_ type: T?.Type,
                                 index: Index) throws -> T?
    where T : OSCMessageValueProtocol
    {
        guard indices.contains(index) else { return nil }
        
        return try unwrapValue(type.Wrapped, index: index)
    }
    
}
