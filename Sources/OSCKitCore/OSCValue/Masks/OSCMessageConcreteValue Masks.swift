//
//  OSCValue Masks.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension Array where Element == any OSCValue {
    /// Returns `[OSCValue]` of non-enumeration-encapsulated values if an array of `OSCValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `mask`.
    ///
    /// - parameter mask: `OSCValueMask` representing a positive mask match.
    ///
    /// - Returns: Unwrapped values if values match the mask.
    ///
    /// - Throws: `OSCValueMask.MaskError`
    @inlinable
    public func masked(
        _ mask: OSCValueMask
    ) throws -> [(any OSCValue)?] {
        try masked(mask.tokens)
    }
    
    /// Returns `[OSCValue]` of non-enumeration-encapsulated values if an array of `OSCValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `mask`.
    ///
    /// - parameter mask: `[OSCValueMask.Token]` representing a positive mask match.
    ///
    /// - Returns: Unwrapped values if values match the mask.
    ///
    /// - Throws: `OSCValueMask.MaskError`
    @inlinable
    public func masked(
        _ mask: [OSCValueMask.Token]
    ) throws -> [(any OSCValue)?] {
        // should not contain more values than mask
        if count > mask.count {
            throw OSCValueMask.MaskError.invalidCount
        }
        
        var values = [(any OSCValue)?]()
        
        for idx in 0 ..< mask.count {
            let idxOptional = mask[idx].isOptional
            
            if indices.contains(idx) {
                // check if it's the correct base type
                if !self[idx].oscCoreType(
                    matches: mask[idx].baseType,
                    canMatchMetaTypes: true
                ) {
                    throw OSCValueMask.MaskError.mismatchedTypes
                }
                
                // TODO: fix this
                
//                switch self[idx] {
//                // core types
//                case let v as Int32:             values.append(v); continue
//                case let v as Float32:           values.append(v); continue
//                case let v as String:            values.append(v); continue
//                case let v as Data:              values.append(v); continue
//
//                // extended types
//                case let v as Int64:             values.append(v); continue
//                case let v as OSCTimeTag:        values.append(v); continue
//                case let v as Double:            values.append(v); continue
//                case let v as OSCStringAltValue: values.append(v); continue
//                case let v as Character:         values.append(v); continue
//                case let v as Bool:              values.append(v); continue
//                case let v as OSCImpulseValue:   values.append(v); continue
//                case let v as OSCMIDIValue:      values.append(v); continue
//                case let v as OSCNullValue:      values.append(v); continue
//                }
            } else {
                switch idxOptional {
                case true:              values.append(nil); continue
                case false:             throw OSCValueMask.MaskError.mismatchedTypes
                }
            }
        }
        
        return values
    }
}
