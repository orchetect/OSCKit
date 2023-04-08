/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Swift/Integers.swift
///
/// Borrowed from OTCore 1.4.10 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// MARK: - Convenience type conversion methods

extension BinaryInteger {
    /// Same as `Int`
    /// (Functional convenience method)
    @inlinable
    var int: Int { Int(self) }
    
    /// Same as `UInt`
    /// (Functional convenience method)
    @inlinable
    var uInt: UInt { UInt(self) }
    
    /// Same as `Int8`
    /// (Functional convenience method)
    @inlinable
    var int8: Int8 { Int8(self) }
    
    /// Same as `UInt8`
    /// (Functional convenience method)
    @inlinable
    var uInt8: UInt8 { UInt8(self) }
    
    /// Same as `Int16`
    /// (Functional convenience method)
    @inlinable
    var int16: Int16 { Int16(self) }
    
    /// Same as `UInt16`
    /// (Functional convenience method)
    @inlinable
    var uInt16: UInt16 { UInt16(self) }
    
    /// Same as `Int32`
    /// (Functional convenience method)
    @inlinable
    var int32: Int32 { Int32(self) }
    
    /// Same as `UInt32`
    /// (Functional convenience method)
    @inlinable
    var uInt32: UInt32 { UInt32(self) }
    
    /// Same as `Int64`
    /// (Functional convenience method)
    @inlinable
    var int64: Int64 { Int64(self) }
    
    /// Same as `UInt64`
    /// (Functional convenience method)
    @inlinable
    var uInt64: UInt64 { UInt64(self) }
}

extension BinaryInteger {
    /// Same as `Int(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var intExactly: Int? { Int(exactly: self) }
    
    /// Same as `UInt(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var uIntExactly: UInt? { UInt(exactly: self) }
    
    /// Same as `Int8(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var int8Exactly: Int8? { Int8(exactly: self) }
    
    /// Same as `UInt8(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var uInt8Exactly: UInt8? { UInt8(exactly: self) }
    
    /// Same as `Int16(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var int16Exactly: Int16? { Int16(exactly: self) }
    
    /// Same as `UInt16(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var uInt16Exactly: UInt16? { UInt16(exactly: self) }
    
    /// Same as `Int32(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var int32Exactly: Int32? { Int32(exactly: self) }
    
    /// Same as `UInt32(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var uInt32Exactly: UInt32? { UInt32(exactly: self) }
    
    /// Same as `Int64(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var int64Exactly: Int64? { Int64(exactly: self) }
    
    /// Same as `UInt64(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var uInt64Exactly: UInt64? { UInt64(exactly: self) }
}

extension BinaryInteger {
    /// Same as `Double()`
    /// (Functional convenience method)
    @inlinable
    var double: Double { Double(self) }
    
    /// Same as `Double(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var doubleExactly: Double? { Double(exactly: self) }
    
    /// Same as `Float()`
    /// (Functional convenience method)
    @inlinable
    var float: Float { Float(self) }
    
    /// Same as `Float(exactly:)`
    /// (Functional convenience method)
    @inlinable
    var floatExactly: Float? { Float(exactly: self) }
    
    /// Same as `Float32()`
    /// (Functional convenience method)
    @inlinable
    var float32: Float32 { Float32(self) }
    
    #if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
    /// Same as `Float80()`
    /// (Functional convenience method)
    @inlinable
    var float80: Float80 { Float80(self) }
    #endif
}

extension StringProtocol {
    /// Same as `Int()`
    /// (Functional convenience method)
    @inlinable
    var int: Int? { Int(self) }
    
    /// Same as `Int()`
    /// (Functional convenience method)
    @inlinable
    var uInt: UInt? { UInt(self) }
    
    /// Same as `Int8()`
    /// (Functional convenience method)
    @inlinable
    var int8: Int8? { Int8(self) }
    
    /// Same as `UInt8()`
    /// (Functional convenience method)
    @inlinable
    var uInt8: UInt8? { UInt8(self) }
    
    /// Same as `Int16()`
    /// (Functional convenience method)
    @inlinable
    var int16: Int16? { Int16(self) }
    
    /// Same as `UInt16()`
    /// (Functional convenience method)
    @inlinable
    var uInt16: UInt16? { UInt16(self) }
    
    /// Same as `Int32()`
    /// (Functional convenience method)
    @inlinable
    var int32: Int32? { Int32(self) }
    
    /// Same as `UInt32()`
    /// (Functional convenience method)
    @inlinable
    var uInt32: UInt32? { UInt32(self) }
    
    /// Same as `Int64()`
    /// (Functional convenience method)
    @inlinable
    var int64: Int64? { Int64(self) }
    
    /// Same as `UInt64()`
    /// (Functional convenience method)
    @inlinable
    var uInt64: UInt64? { UInt64(self) }
}

// MARK: - String Formatting

extension BinaryInteger {
    /// Same as `String(describing: self)`
    /// (Functional convenience method)
    @inlinable
    var string: String { String(describing: self) }
}

// MARK: - Rounding

extension BinaryInteger {
    /// Rounds an integer away from zero to the nearest multiple of `toMultiplesOf`.
    ///
    /// Example:
    ///
    ///        1.roundedAwayFromZero(toMultiplesOf: 2) // 2
    ///        5.roundedAwayFromZero(toMultiplesOf: 4) // 8
    ///     (-1).roundedAwayFromZero(toMultiplesOf: 2) // -2
    ///
    @inlinable
    func roundedAwayFromZero(toMultiplesOf: Self) -> Self {
        let source: Self = self >= 0 ? self : 0 - self
        let isNegative: Bool = self < 0
        
        let rem = source % toMultiplesOf
        let divisions = rem == 0 ? source : source + toMultiplesOf - rem
        return isNegative ? 0 - divisions : divisions
    }
    
    /// Rounds an integer up to the nearest multiple of `toMultiplesOf`.
    ///
    /// Example:
    ///
    ///        1.roundedUp(toMultiplesOf: 2) // 2
    ///        5.roundedUp(toMultiplesOf: 4) // 8
    ///     (-3).roundedUp(toMultiplesOf: 2) // -2
    ///
    @inlinable
    func roundedUp(toMultiplesOf: Self) -> Self {
        if toMultiplesOf < 1 { return self }
        
        let source: Self = self >= 0 ? self : 0 - self
        let isNegative: Bool = self < 0
        
        let rem = source % toMultiplesOf
        let divisions = rem == 0 ? self : self + (isNegative ? rem : toMultiplesOf - rem)
        return divisions
    }
    
    /// Rounds an integer down to the nearest multiple of `toMultiplesOf`.
    ///
    /// Example:
    ///
    ///        1.roundedDown(toMultiplesOf: 2) // 0
    ///        3.roundedDown(toMultiplesOf: 4) // 0
    ///        5.roundedDown(toMultiplesOf: 4) // 4
    ///     (-1).roundedDown(toMultiplesOf: 4) // -4
    ///
    @inlinable
    func roundedDown(toMultiplesOf: Self) -> Self {
        let source: Self = self >= 0 ? self : 0 - self
        let isNegative: Bool = self < 0
        
        let rem = source % toMultiplesOf
        let divisions = rem == 0 ? self : self - (isNegative ? toMultiplesOf - rem : rem)
        return divisions
    }
}
