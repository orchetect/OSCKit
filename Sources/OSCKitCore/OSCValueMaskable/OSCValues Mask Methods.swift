//
//  OSCValues Mask Methods.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCValues {
    /// Returns `true` if an array of ``OSCValue`` values matches an expected value type mask (order
    /// and type of values).
    /// To make any mask value `Optional`, use its `*Optional` variant.
    ///
    /// Some opaque type(s) are available:
    ///   - ``OSCValueToken/number`` & ``OSCValueToken/numberOptional``: Matches
    ///     ``OSCValueToken/int32``, ``OSCValueToken/float32``, ``OSCValueToken/double``, or
    ///     ``OSCValueToken/int64``.
    ///
    /// - parameter expectedMask: ``OSCValueToken`` array representing a positive mask match.
    public func matches(
        mask: [OSCValueToken]
    ) -> Bool {
        // should not contain more values than mask
        if count > mask.count { return false }
        
        var matchCount = 0
        
        for idx in 0 ..< mask.count {
            // can be a concrete type or opaque type
            let idxOptional = mask[idx].isOptional
            
            if indices.contains(idx) {
                switch mask[idx] {
                case .number, .numberOptional:
                    // pass through to be matched as a core type
                    break
                default:
                    if self[idx] is (any OSCInterpolatedValue) {
                        // interpolated values should never match against a core OSC type
                        return false
                    }
                }
                
                let token = self[idx].getSelf().oscValueToken
                switch token.isBaseType(
                    matching: mask[idx].baseType,
                    includingOpaque: true
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
