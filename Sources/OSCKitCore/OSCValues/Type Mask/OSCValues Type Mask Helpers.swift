//
//  OSCValues Type Mask Helpers.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCValues {
    @usableFromInline
    func validateCount(_ validCount: Index) throws {
        guard count == validCount else {
            throw OSCValueMaskError.invalidCount
        }
    }

    @usableFromInline
    func validateCount(_ validRange: ClosedRange<Index>) throws {
        guard validRange.contains(count) else {
            throw OSCValueMaskError.invalidCount
        }
    }

    // MARK: - Concrete Values

    @usableFromInline
    func unwrapValue<MaskType>(
        _: MaskType.Type,
        index: Index
    ) throws -> MaskType
        where MaskType: OSCValueMaskable
    {
        guard indices.contains(index) else {
            throw OSCValueMaskError.invalidCount
        }

        guard let typed = self[index] as? MaskType else {
            throw OSCValueMaskError.mismatchedTypes
        }

        return typed
    }

    // MARK: - Optionals

    @usableFromInline
    func unwrapValue<MaskType>(
        _ type: MaskType?.Type,
        index: Index
    ) throws -> MaskType?
        where MaskType: OSCValueMaskable
    {
        guard indices.contains(index) else { return nil }

        return try unwrapValue(type.Wrapped, index: index)
    }

    // MARK: - Int

    /// Handle `Int` as a special interpolated type.
    @usableFromInline
    func unwrapValue(
        _: Int.Type,
        index: Index
    ) throws -> Int
        where Int: OSCValueMaskable
    {
        guard indices.contains(index) else {
            throw OSCValueMaskError.invalidCount
        }

        guard let typed = self[index] as? (any BinaryInteger) else {
            throw OSCValueMaskError.mismatchedTypes
        }

        return Int(typed)
    }

    // MARK: - AnyOSCNumberValue

    /// Handle opaque type `AnyOSCNumberValue`.
    /// @usableFromInline
    func unwrapValue(
        _: AnyOSCNumberValue.Type,
        index: Index
    ) throws -> AnyOSCNumberValue
        where AnyOSCNumberValue: OSCValueMaskable
    {
        guard indices.contains(index) else {
            throw OSCValueMaskError.invalidCount
        }

        let sourceValue = self[index]

        switch sourceValue {
        case let int as any (OSCValue & BinaryInteger):
            return AnyOSCNumberValue(int)
        case let float as any (OSCValue & BinaryFloatingPoint):
            return AnyOSCNumberValue(float)
        default:
            throw OSCValueMaskError.mismatchedTypes
        }
    }
}
