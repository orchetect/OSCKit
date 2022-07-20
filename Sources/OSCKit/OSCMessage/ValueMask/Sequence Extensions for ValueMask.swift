//
//  Sequence Extensions for ValueMask.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension Array where Element == OSCMessageValue {
    
    /// Returns `true` if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
    ///
    /// Some meta type(s) are available:
    ///   - `number` & `numberOptional`: Matches `int32`, `float32`, `double`, or `int64`.
    ///
    /// - parameter expectedMask: `OSCMessage.ValueMask.Token` array representing a positive mask match.
    @inlinable
    func matches(
        mask: OSCMessage.ValueMask
    ) -> Bool {
        
        matches(mask: mask.tokens)
        
    }
    
    /// Returns `true` if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
    ///
    /// Some meta type(s) are available:
    ///   - `number` & `numberOptional`: Matches `int32`, `float32`, `double`, or `int64`.
    ///
    /// - parameter expectedMask: `OSCMessage.ValueMask.Token` array representing a positive mask match.
    @inlinable
    func matches(
        mask: [OSCMessage.ValueMask.Token]
    ) -> Bool {
        
        // should not contain more values than mask
        if self.count > mask.count { return false }
        
        var matchCount = 0
        
        for idx in 0..<mask.count {
            // can be a concrete type or meta type
            let idxOptional = mask[idx].isOptional
            
            if self.indices.contains(idx) {
                switch self[idx].baseTypeMatches(type: mask[idx].baseType,
                                                 canMatchMetaTypes: true) {
                case true:
                    matchCount += 1
                    continue
                    
                case false:
                    return false
                    
                }
            } else {
                switch idxOptional {
                case true:
                    matchCount += 1
                    continue
                    
                case false:
                    return false
                    
                }
            }
        }
        
        if mask.count == matchCount { return true }
        return false
        
    }
    
}

public extension Array where Element == OSCMessageValue {
    
    /// Returns `[OSCMessageValueProtocol]` of non-enumeration-encapsulated values if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
    ///
    /// - parameter mask: `OSCMessage.ValueMask` representing a positive mask match.
    ///
    /// - Returns:
    ///   `.int32()` as `Int`,
    ///   `.float32()` as `Float32`,
    ///   `.string()` as `String`,
    ///   `.blob()` as `Data`.
    ///   Returns `nil` if values do not match the mask.
    @inlinable
    func values(
        mask: OSCMessage.ValueMask
    ) -> [OSCMessageValueProtocol?]? {
        
        values(mask: mask.tokens)
        
    }
    
    /// Returns `[OSCMessageValueProtocol]` of non-enumeration-encapsulated values if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
    ///
    /// - parameter mask: `[OSCMessage.ValueMask.Token]` representing a positive mask match.
    ///
    /// - Returns:
    ///   `.int32()` as `Int`,
    ///   `.float32()` as `Float32`,
    ///   `.string()` as `String`,
    ///   `.blob()` as `Data`.
    ///   Returns `nil` if values do not match the mask.
    @inlinable
    func values(
        mask: [OSCMessage.ValueMask.Token]
    ) -> [OSCMessageValueProtocol?]? {
        
        // should not contain more values than mask
        if self.count > mask.count { return nil }
        
        var values = [OSCMessageValueProtocol?]()
        
        for idx in 0..<mask.count {
            let idxOptional = mask[idx].isOptional
            
            if self.indices.contains(idx) {
                // check if it's the correct base type
                if !self[idx].baseTypeMatches(type: mask[idx].baseType,
                                              canMatchMetaTypes: true) {
                    return nil
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
                case false:             return nil
                }
            }
        }
        
        return values
        
    }
    
}
