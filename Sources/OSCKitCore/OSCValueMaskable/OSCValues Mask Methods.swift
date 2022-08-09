//
//  OSCValues Mask Methods.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCValues {
    /// Returns `true` if an array of `OSCValue` values matches an expected value type mask (order and type of values).
    /// To make any mask value `Optional`, use its `*Optional` variant.
    ///
    /// Some meta type(s) are available:
    ///   - `number` & `numberOptional`: Matches `int32`, `float32`, `double`, or `int64`.
    ///
    /// - parameter expectedMask: `OSCValueToken` array representing a positive mask match.
    @inlinable
    public func matches(
        mask: [OSCValueToken]
    ) -> Bool {
        // should not contain more values than mask
        if count > mask.count { return false }
        
        var matchCount = 0
        
        for idx in 0 ..< mask.count {
            // can be a concrete type or meta type
            let idxOptional = mask[idx].isOptional
            
            if indices.contains(idx) {
                switch self[idx].getSelf().oscValueToken.matches(
                    mask: mask[idx].baseType,
                    canMatchMetaTypes: true
                ) {
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
