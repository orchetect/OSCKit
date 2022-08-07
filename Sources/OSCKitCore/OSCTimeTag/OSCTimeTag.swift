//
//  OSCTimeTag.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// OSCTimeTag
///
/// - remark: OSC 1.0 Spec:
///
/// "Time tags are represented by a 64 bit fixed point number. The first 32 bits specify the number of seconds since midnight on January 1, 1900, and the last 32 bits specify fractional parts of a second to a precision of about 200 picoseconds. This is the representation used by Internet NTP timestamps.
///
/// The time tag value consisting of 63 zero bits followed by a one in the least significant bit (essentially a `UInt64` integer value of 1) is a special case meaning 'immediately.'"

public struct OSCTimeTag: Equatable, Hashable {
    /// Raw value type (aka `UInt64`)
    public typealias RawValue = UInt64
    
    /// NTP time format era number.
    ///
    /// The OSC Time Tag encoding uses NTPv3 time encoding which specifies 32 bits for seconds and 32 bits for fractional sections. Given that the prime epoch (era 0) is the year 1990, 32 bit seconds storage rolls over approximate every 136 years. Every time this rollover occurs, the era increments by 1.
    ///
    /// Hence, the period between 1 Jan 1900 and 7 Feb 2036 is considered era 0. Dates after 7 Feb 2036 for the following 136 years are considered era 1. And so on.
    ///
    /// - Note:
    ///
    /// See https://www.eecis.udel.edu/~mills/y2k.html for details.
    public let era: Int
    
    /// Raw Time Tag value as encoded in OSC.
    public let rawValue: RawValue
    
    /// Initialize from a raw OSC Time Tag value.
    public init(_ rawValue: RawValue, era: Int = 0) {
        self.era = era
        self.rawValue = rawValue
    }
}

// MARK: - Properties

extension OSCTimeTag {
    /// Returns `true` if the Time Tag is considered immediate.
    /// (Special raw value of 1).
    public var isImmediate: Bool {
        rawValue == 1
    }
    
    /// Returns `true` if the Time Tag is a time in the future.
    public var isFuture: Bool {
        guard !isImmediate else { return false }
        return rawValue > OSCTimeTag.now().rawValue
    }
    
    /// Returns the time tag converted to a `Date` instance.
    public var date: Date {
        return isImmediate
            ? Date()
            : Self.primeEpoch.addingTimeInterval(rawValue.seconds(era: era))
    }
    
    /// Returns the delta time interval in seconds between _now_ and the Time Tag.
    public func secondsFromNow() -> TimeInterval {
        secondsFrom(Date())
    }
    
    /// Returns the delta time interval in seconds between an arbitrary `date` and the Time Tag.
    public func secondsFrom(_ other: Date) -> TimeInterval {
        isImmediate
            ? 0.0
            : date.timeIntervalSince(other)
    }
}
