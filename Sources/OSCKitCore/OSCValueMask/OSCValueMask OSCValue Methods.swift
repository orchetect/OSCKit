//
//  OSCValueMask OSCValue Methods.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCValue {
    /// Returns `true` if the value's base type masks the supplied `OSCValueMask.Token`.
    ///
    /// - parameters:
    ///   - type: `OSCValueMask.Token` to compare to.
    ///   - canMatchMetaTypes: Allows matching against a meta type (if a meta type is passed in `type`)
    ///     If `true`, only exact matches will return `true` (`.int32` matches only `.int32` and not `.number` "meta" type; `.number` only matches `.number`).
    ///     If `false`, "meta" types matches will return true (ie: `.int32` or `.float32` will return true if `type` = `.number`).
    ///     (default = `false`)
    @inlinable
    public func oscCoreType(
        matches mask: OSCValueMask.Token,
        canMatchMetaTypes: Bool = false
    ) -> Bool {
        if Self.oscCoreType == mask { return true }
        
        if canMatchMetaTypes {
            // handle all meta types
            // for now, it's just `.number` unless more are added to OSCKit in future
            
            if mask == .number,
               (
                Self.oscCoreType == .int32 ||
                Self.oscCoreType == .float32 ||
                Self.oscCoreType == .int64 ||
                Self.oscCoreType == .double
               )
            {
                return true
            }
        }
        
        return false
    }
}
