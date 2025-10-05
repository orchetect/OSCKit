//
//  OSCValues Type Mask Helpers.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCValues {
    @usableFromInline
    func validateCount(_ validCount: Index) throws(OSCValueMaskError) {
        guard count == validCount else {
            throw .invalidCount
        }
    }

    @usableFromInline
    func validateCount(_ validRange: ClosedRange<Index>) throws(OSCValueMaskError) {
        guard validRange.contains(count) else {
            throw .invalidCount
        }
    }

    // MARK: - Concrete Values

    @usableFromInline
    func unwrapValue<MaskType>(
        _: MaskType.Type,
        index: Index,
        asOptional: Bool = false
    ) throws(OSCValueMaskError) -> MaskType
        where MaskType: OSCValueMaskable
    {
        guard indices.contains(index) else {
            throw .invalidCount
        }
        
        switch MaskType.self {
        case is Int.Type:
            guard let typed = self[index] as? (any BinaryInteger) else {
                throw .mismatchedTypes
            }
            
            return Int(typed) as! MaskType // guaranteed
            
        case is AnyOSCNumberValue.Type:
            let sourceValue = self[index]
            
            switch sourceValue {
            case let int as any (OSCValue & BinaryInteger):
                return AnyOSCNumberValue(int) as! MaskType // guaranteed
            case let float as any (OSCValue & BinaryFloatingPoint):
                return AnyOSCNumberValue(float) as! MaskType // guaranteed
            case let bool as Bool:
                return AnyOSCNumberValue(bool) as! MaskType // guaranteed
            default:
                throw .mismatchedTypes
            }
            
        default:
            guard let typed = self[index] as? MaskType else {
                throw .mismatchedTypes
            }
            
            return typed
        }
    }

    // MARK: - Optionals

    @usableFromInline
    func unwrapValue<MaskType>(
        _ type: MaskType?.Type,
        index: Index
    ) throws(OSCValueMaskError) -> MaskType?
        where MaskType: OSCValueMaskable
    {
        guard indices.contains(index) else {
            return nil
        }
        
        return try unwrapValue(
            type.Wrapped,
            index: index,
            asOptional: true
        )
    }
}
