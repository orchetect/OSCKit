//
//  OSCTimeTag init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCTimeTag {
    /// Initialize from a raw OSC Time Tag value.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead.
    public init(_ rawValue: RawValue, era: Int = 0) {
        self.era = era
        self.rawValue = rawValue
    }
    
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead of `init(secondsSinceNow: 0.0)`.
    ///
    /// Passing `seconds` that is `< 0.0` will produce a Time Tag of `.now()`.
    public init(secondsSinceNow seconds: TimeInterval) {
        if seconds.isZero {
            self = Self.now()
            return
        }
        let futureDate = Date(timeIntervalSinceNow: seconds)
        self.init(future: futureDate)
    }
    
    /// Returns a Time Tag formed from total elapsed seconds since 1990 (prime epoch).
    public init(secondsSince1900 seconds: TimeInterval) {
        let converted = seconds.oscTimeTag
        self.init(converted.timeTag, era: converted.era)
    }
    
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead of `init(at: Date())`.
    ///
    /// Passing `Date` that is `< now` will produce a Time Tag of `.now()`.
    public init(future futureDate: Date) {
        self.init(secondsSince1900: futureDate.timeIntervalSince(Self.primeEpoch))
    }
}

// MARK: - Static Constructors

extension OSCTimeTag {
    /// Returns a Time Tag with value of `1`, a special time value indicating "now" in the OSC spec.
    public static func immediate() -> Self {
        self.init(1)
    }
    
    /// Returns a Time Tag representing the current time.
    /// To indicate immediate dispatch, use `.immediate()` instead.
    public static func now() -> Self {
        let nowRaw = Date().timeIntervalSince(primeEpoch)
            .oscTimeTag
        return Self(nowRaw.timeTag, era: nowRaw.era)
    }
    
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead of `init(secondsSinceNow: 0.0)`.
    ///
    /// Passing `seconds` that is `< 0.0` will produce a Time Tag of `.now()`.
    public static func secondsSinceNow(_ seconds: TimeInterval) -> Self {
        self.init(secondsSinceNow: seconds)
    }
    
    /// Returns a Time Tag formed from total elapsed seconds since 1990 (prime epoch).
    public static func secondsSince1900(_ seconds: TimeInterval) -> Self {
        self.init(secondsSince1900: seconds)
    }
    
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead of `init(at: Date())`.
    ///
    /// Passing `Date` that is `< now` will produce a Time Tag of `.now()`.
    public static func future(_ futureDate: Date) -> Self {
        self.init(future: futureDate)
    }
}
