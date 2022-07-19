//
//  Value Masks.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import SwiftASCII

public extension OSCMessageValue {
    
    /// Tests if the type of a `OSCMessageValue` matches the supplied `OSCMessage.MaskType` (optional/default or not) and returns base type.
    /// Returns `nil` if does not match.
    ///
    /// - parameter type: `OSCMessage.MaskType` to compare to.
    /// - parameter canMatchMetaTypes: Match a meta type (if a meta type is passed in `type`)
    ///     If `true`, only exact matches will return `true` (`.int32` matches only `.int32` and not `.number` "meta" type; `.number` only matches `.number`).
    ///     If `false`, "meta" types matches will return true (ie: `.int32` or `.float32` will return true if `type` = `.number`).
    ///     (default = `false`)
    @inlinable
    func baseTypeMatches(type: OSCMessage.MaskType,
                         canMatchMetaTypes: Bool = false) -> Bool {
        
        // if types explicitly match, return true
        
        // concrete types match, or a meta type matches the same meta type
        // ie: .int32,  .float32    = return false
        //     .int32,  .int32      = return true
        //     .int32,  .number     = return false
        //     .number, .number     = return true
        if self.baseType.rawValue == type.rawValue { return true }
        
        switch canMatchMetaTypes {
        case false: break
            // we already covered this with the code above so execution will never reach this switch case
            
        case true:
            // add additional case to allow "meta" types to also match concrete types
            
            // ie: .int32,  .float32    = return false
            //     .int32,  .int32      = return true
            //     .int32,  .number     = return false
            //     .number, .number     = return true
            
            // (FYI, `self` will never be a meta type itself, only a concrete type)
            if type.rawValue == OSCMessage.MaskType.number.rawValue &&
                (self.baseType.rawValue == OSCMessage.MaskType.int32.rawValue ||
                 self.baseType.rawValue == OSCMessage.MaskType.float32.rawValue ||
                 self.baseType.rawValue == OSCMessage.MaskType.int64.rawValue ||
                 self.baseType.rawValue == OSCMessage.MaskType.double.rawValue) {
                
                return true
            }
            
        }
        
        return false
        
    }
    
    /// Returns base type of `OSCMessageValue` as an `OSCMessage.MaskType` (by removing 'optional' component).
    @inlinable
    var baseType: OSCMessage.MaskType {
        
        switch self {
            // core types
        case .int32(_):     return .int32
        case .float32(_):   return .float32
        case .string(_):    return .string
        case .blob(_):      return .blob
            
            // extended types
        case .int64(_):     return .int64
        case .timeTag(_):   return .timeTag
        case .double(_):    return .double
        case .stringAlt(_): return .stringAlt
        case .character(_): return .character
        case .midi(_):      return .midi
        case .bool(_):      return .bool
        case .null:         return .null
        }
        
    }
    
}

// MARK: - Value Mask

public extension Array where Element == OSCMessageValue {
    
    /// Returns `true` if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
    ///
    /// Some meta type(s) are available:
    ///   - `number` & `numberOptional`: Accepts int32 or float32 as a value.
    ///
    /// - parameter expectedMask: `OSCMessage.MaskType` array representing a positive mask match.
    @inlinable
    func matchesValueMask(
        expectedMask: [OSCMessage.MaskType]
    ) -> Bool {
        
        // should not contain more values than mask
        if self.count > expectedMask.count { return false }
        
        var matchCount = 0
        
        for idx in 0..<expectedMask.count {
            // can be a concrete type or meta type
            let idxOptional = expectedMask[idx].isOptional
            
            if self.indices.contains(idx) {
                switch self[idx].baseTypeMatches(type: expectedMask[idx].baseType,
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
        
        if expectedMask.count == matchCount { return true }
        return false
        
    }
    
    /// Returns `[OSCMessageValueProtocol]` of non-enumeration-encapsulated values if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
    ///
    /// - parameter expectedMask: `OSCMessage.MaskType` array representing a positive mask match.
    ///
    /// - Returns:
    ///   `.int32()` as `Int`,
    ///   `.float32()` as `Float32`,
    ///   `.string()` as `String`,
    ///   `.blob()` as `Data`.
    ///   Returns `nil` if values do not match the mask.
    @inlinable
    func valuesFromValueMask(
        expectedMask: [OSCMessage.MaskType]
    ) -> [OSCMessageValueProtocol?]? {
        
        // should not contain more values than mask
        if self.count > expectedMask.count { return nil }
        
        var values = [OSCMessageValueProtocol?]()
        
        for idx in 0..<expectedMask.count {
            let idxOptional = expectedMask[idx].isOptional
            
            if self.indices.contains(idx) {
                // check if it's the correct base type
                if !self[idx].baseTypeMatches(type: expectedMask[idx].baseType,
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
