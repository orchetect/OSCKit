//
//  OSCMessageValue Utilities.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

// MARK: - Convenience methods

public extension OSCMessageValue {
    
    /// Convenience:
    /// If passed value can be converted to an `Int`, an `Int` will be returned.
    /// Used in cases where you mask an OSC message value set with `.number` or `.numberOptional` and want to get a value out without caring about preserving type.
    ///
    /// - parameter testValue: Any numerical value type that OSC supports.
    /// - returns: `Double`, or `nil` if value can't be converted.
    @inlinable
    static func numberAsInt(_ testValue: Any?) -> Int? {
        
        // core types
        if let v = testValue as? Int     { return v }
        if let v = testValue as? Int32   { return Int(exactly: v) }
        if let v = testValue as? Float32 { return Int(exactly: v) }
        
        // extended types
        if let v = testValue as? Int64   { return Int(exactly: v) }
        if let v = testValue as? Double  { return Int(exactly: v) }
        
        return nil
        
    }
    
    /// Convenience:
    /// If passed value can be converted to a `Double`, a `Double` will be returned.
    /// Used in cases where you mask an OSC message value set with `.number` or `.numberOptional` and want to get a value out without caring about preserving type.
    ///
    /// - parameter testValue: Any numerical value type that OSC supports.
    /// - returns: `Double`, or `nil` if value can't be converted.
    @inlinable
    static func numberAsDouble(_ testValue: Any?) -> Double? {
        
        // core types
        if let v = testValue as? Int     { return Double(exactly: v) }
        if let v = testValue as? Int32   { return Double(exactly: v) }
        if let v = testValue as? Float32 { return Double(exactly: v) }
        
        // extended types
        if let v = testValue as? Int64   { return Double(exactly: v) }
        if let v = testValue as? Double  { return v }
        
        return nil
        
    }
    
}
