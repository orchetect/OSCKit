//
//  Mask Token OSCMessage Value Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

public extension OSCMessage.Value {
    
    /// Returns `true` if the type of a `OSCMessage.Value` matches the supplied `OSCMessage.Value.Mask.Token`.
    ///
    /// - parameters:
    ///   - type: `OSCMessage.Value.Mask.Token` to compare to.
    ///   - canMatchMetaTypes: Allows matching against a meta type (if a meta type is passed in `type`)
    ///     If `true`, only exact matches will return `true` (`.int32` matches only `.int32` and not `.number` "meta" type; `.number` only matches `.number`).
    ///     If `false`, "meta" types matches will return true (ie: `.int32` or `.float32` will return true if `type` = `.number`).
    ///     (default = `false`)
    @inlinable
    func baseType(matches token: Mask.Token,
                  canMatchMetaTypes: Bool = false) -> Bool {
        
        if baseType == token { return true }
        
        if canMatchMetaTypes {
            // handle all meta types
            // for now, it's just .number unless more are added to OSCKit in future
            
            if token == .number,
               (baseType == .int32 ||
                baseType == .float32 ||
                baseType == .int64 ||
                baseType == .double)
            {
                return true
            }
        }
        
        return false
        
    }
    
    /// Returns base type of `OSCMessage.Value` as an `OSCMessage.Value.Mask.Token` (by removing 'optional' component).
    @inlinable
    var baseType: Mask.Token {
        
        switch self {
            // core types
        case .int32:     return .int32
        case .float32:   return .float32
        case .string:    return .string
        case .blob:      return .blob
            
            // extended types
        case .int64:     return .int64
        case .timeTag:   return .timeTag
        case .double:    return .double
        case .stringAlt: return .stringAlt
        case .character: return .character
        case .midi:      return .midi
        case .bool:      return .bool
        case .null:      return .null
        }
        
    }
    
}
