//
//  OSCValueToken Methods.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCValueToken {
    /// Returns `true` if the value's base type masks the supplied ``OSCValueToken``.
    ///
    /// - parameters:
    ///   - token: ``OSCValueToken`` to compare to.
    ///   - includingOpaque: Allows matching against an opaque type if one is passed in `type`.
    ///     If `false`, only exact matching occurs (ie: ``int32`` == ``int32``; ``number`` == ``number``).
    ///     If `true`, opaque type matching is allowed (ie: ``int32`` == ``number``).
    public func isBaseType(
        matching token: OSCValueToken,
        includingOpaque: Bool = false
    ) -> Bool {
        if self == token { return true }
        
        if includingOpaque {
            // handle all opaque types
            // for now, it's just `.number` unless more are added to OSCKit in future
            
            switch token {
            case .number:
                if self == .int32 ||
                    self == .float32 ||
                    self == .int64 ||
                    self == .double
                {
                    return true
                }
            default:
                break
            }
        }
        
        return false
    }
}

extension OSCValue {
    /// A mechanism to easily return the static type of an ``AnyOSCValue`` instance.
    @inlinable @_disfavoredOverload
    func getSelf() -> Self.Type {
        Self.self
    }
}
