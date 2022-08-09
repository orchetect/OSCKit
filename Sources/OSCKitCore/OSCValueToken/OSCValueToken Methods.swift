//
//  OSCValueToken Methods.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCValueToken {
    /// Returns `true` if the value's base type masks the supplied `OSCValueMaskToken`.
    ///
    /// - parameters:
    ///   - token: `OSCValueToken` to compare to.
    ///   - canMatchMetaTypes: Allows matching against a meta type (if a meta type is passed in `type`)
    ///     If `true`, only exact matches will return `true` (`.int32` matches only `.int32` and not `.number` "meta" type; `.number` only matches `.number`).
    ///     If `false`, "meta" types matches will return true (ie: `.int32` or `.float32` will return true if `type` = `.number`).
    ///     (default = `false`)
    @inlinable
    public func matches(
        mask token: OSCValueToken,
        canMatchMetaTypes: Bool = false
    ) -> Bool {
        if self == token { return true }
        
        if canMatchMetaTypes {
            // handle all meta types
            // for now, it's just `.number` unless more are added to OSCKit in future
            
            if token == .number,
               (
                self == .int32 ||
                self == .float32 ||
                self == .int64 ||
                self == .double
               )
            {
                return true
            }
        }
        
        return false
    }
}

extension OSCValue {
    /// A mechanism to easily return the static type of an `AnyOSCValue` instance.
    @inlinable @_disfavoredOverload
    func getSelf() -> Self.Type {
        Self.self
    }
}
