//
//  Mask Sequence Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension Array where Element == OSCMessage.Value {
    
    /// Returns `true` if an array of `OSCMessage.Value` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `mask`.
    ///
    /// Some meta type(s) are available:
    ///   - `number` & `numberOptional`: Matches `int32`, `float32`, `double`, or `int64`.
    ///
    /// - parameter expectedMask: `OSCMessage.Value.Mask.Token` array representing a positive mask match.
    @inlinable
    func matches(
        mask: OSCMessage.Value.Mask
    ) -> Bool {
        
        matches(mask: mask.tokens)
        
    }
    
    /// Returns `true` if an array of `OSCMessage.Value` values matches an expected value type mask (order and type of values).
    /// To make any of the mask values optional, pass them as `.optional` in `mask`.
    ///
    /// Some meta type(s) are available:
    ///   - `number` & `numberOptional`: Matches `int32`, `float32`, `double`, or `int64`.
    ///
    /// - parameter expectedMask: `OSCMessage.Value.Mask.Token` array representing a positive mask match.
    @inlinable
    func matches(
        mask: [OSCMessage.Value.Mask.Token]
    ) -> Bool {
        
        // should not contain more values than mask
        if self.count > mask.count { return false }
        
        var matchCount = 0
        
        for idx in 0..<mask.count {
            // can be a concrete type or meta type
            let idxOptional = mask[idx].isOptional
            
            if self.indices.contains(idx) {
                switch self[idx].baseType(matches: mask[idx].baseType,
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
