//
//  OSCMessageValueProtocol Masks.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension Array where Element == OSCMessageValue {
    
    /// Returns `[OSCMessageValueProtocol]` of non-enumeration-encapsulated values if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
    ///
    /// - parameter mask: `OSCMessage.ValueMask` representing a positive mask match.
    ///
    /// - Returns: Unwrapped values if values match the mask.
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func masked(
        _ valueMask: OSCMessage.ValueMask
    ) throws -> [OSCMessageValueProtocol?] {
        
        try masked(valueMask.tokens)
        
    }
    
    /// Returns `[OSCMessageValueProtocol]` of non-enumeration-encapsulated values if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
    ///
    /// - parameter mask: `[OSCMessage.ValueMask.Token]` representing a positive mask match.
    ///
    /// - Returns: Unwrapped values if values match the mask.
    ///
    /// - Throws: `OSCMessage.ValueMask.MaskError`
    @inlinable
    func masked(
        _ valueMask: [OSCMessage.ValueMask.Token]
    ) throws -> [OSCMessageValueProtocol?] {
        
        // should not contain more values than mask
        if self.count > valueMask.count { throw OSCMessage.ValueMask.MaskError.invalidCount }
        
        var values = [OSCMessageValueProtocol?]()
        
        for idx in 0..<valueMask.count {
            let idxOptional = valueMask[idx].isOptional
            
            if self.indices.contains(idx) {
                // check if it's the correct base type
                if !self[idx].baseTypeMatches(type: valueMask[idx].baseType,
                                              canMatchMetaTypes: true)
                {
                    throw OSCMessage.ValueMask.MaskError.mismatchedTypes
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
                case false:             throw OSCMessage.ValueMask.MaskError.mismatchedTypes
                }
            }
        }
        
        return values
        
    }
    
}
