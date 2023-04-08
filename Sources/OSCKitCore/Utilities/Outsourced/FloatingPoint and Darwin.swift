/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Darwin/FloatingPoint and Darwin.swift
///
/// Borrowed from OTCore 1.4.10 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import Darwin

extension FloatingPoint {
    /// Similar to `Int.quotientAndRemainder(dividingBy:)` from the standard Swift library.
    func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
        let calculation = self / rhs
        let integral = trunc(calculation)
        let fraction = self - (integral * rhs)
        return (quotient: integral, remainder: fraction)
    }
    
    /// Returns both integral part and fractional part.
    ///
    /// - Note: This method is more computationally efficient than calling both `.integral` and
    ///   `.fraction` properties separately unless you only require one or the other.
    ///
    /// This method can result in a non-trivial loss of precision for the fractional part.
    @inlinable
    var integralAndFraction: (integral: Self, fraction: Self) {
        let integral = trunc(self)
        let fraction = self - integral
        return (integral: integral, fraction: fraction)
    }
    
    /// Returns the integral part (digits before the decimal point)
    @inlinable
    var integral: Self {
        integralAndFraction.integral
    }
    
    /// Returns the fractional part (digits after the decimal point)
    ///
    /// - Note: this method can result in a non-trivial loss of precision for the fractional part.
    @inlinable
    var fraction: Self {
        integralAndFraction.fraction
    }
}
