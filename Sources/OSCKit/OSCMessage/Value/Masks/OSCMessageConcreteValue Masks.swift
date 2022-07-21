//
//  OSCMessageConcreteValue Masks.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension Array where Element == OSCMessage.Value {
    
    /// Returns `[OSCMessageConcreteValue]` of non-enumeration-encapsulated values if an array of `OSCMessage.Value` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `mask`.
    ///
    /// - parameter mask: `OSCMessage.Value.Mask` representing a positive mask match.
    ///
    /// - Returns: Unwrapped values if values match the mask.
    ///
    /// - Throws: `OSCMessage.Value.Mask.MaskError`
    @inlinable
    func masked(
        _ mask: OSCMessage.Value.Mask
    ) throws -> [OSCMessageConcreteValue?] {
        
        try masked(mask.tokens)
        
    }
    
    /// Returns `[OSCMessageConcreteValue]` of non-enumeration-encapsulated values if an array of `OSCMessage.Value` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `mask`.
    ///
    /// - parameter mask: `[OSCMessage.Value.Mask.Token]` representing a positive mask match.
    ///
    /// - Returns: Unwrapped values if values match the mask.
    ///
    /// - Throws: `OSCMessage.Value.Mask.MaskError`
    @inlinable
    func masked(
        _ mask: [OSCMessage.Value.Mask.Token]
    ) throws -> [OSCMessageConcreteValue?] {
        
        // should not contain more values than mask
        if self.count > mask.count { throw OSCMessage.Value.Mask.MaskError.invalidCount }
        
        var values = [OSCMessageConcreteValue?]()
        
        for idx in 0..<mask.count {
            let idxOptional = mask[idx].isOptional
            
            if self.indices.contains(idx) {
                // check if it's the correct base type
                if !self[idx].baseType(matches: mask[idx].baseType,
                                       canMatchMetaTypes: true)
                {
                    throw OSCMessage.Value.Mask.MaskError.mismatchedTypes
                }
                
                switch self[idx] {
                    // core types
                case let .int32(v):     values.append(v)        ; continue
                case let .float32(v):   values.append(v)        ; continue
                case let .string(v):    values.append(v)        ; continue
                case let .blob(v):      values.append(v)        ; continue
                    
                    // extended types
                case let .int64(v):     values.append(v)        ; continue
                case let .timeTag(v):   values.append(v)        ; continue
                case let .double(v):    values.append(v)        ; continue
                case let .stringAlt(v): values.append(v)        ; continue
                case let .character(v): values.append(v)        ; continue
                case let .midi(v):      values.append(v)        ; continue
                case let .bool(v):      values.append(v)        ; continue
                case .null:             values.append(NSNull()) ; continue
                }
            } else {
                switch idxOptional {
                case true:              values.append(nil)      ; continue
                case false:             throw OSCMessage.Value.Mask.MaskError.mismatchedTypes
                }
            }
        }
        
        return values
        
    }
    
}
