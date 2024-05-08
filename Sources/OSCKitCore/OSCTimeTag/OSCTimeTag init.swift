//
//  OSCTimeTag init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCTimeTag {
    /// Initialize from a raw OSC Time Tag value.
    ///
    /// If the intention is to produce an immediate Time Tag, use ``immediate()`` instead.
    public init(_ rawValue: RawValue, era: Int = 0) {
        self.era = era
        self.rawValue = rawValue
    }
    
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use ``immediate()`` instead of
    /// `init(timeIntervalSinceNow: 0.0)`.
    ///
    /// Passing `seconds` that is `< 0.0` will produce a Time Tag of ``now()``.
    public init(timeIntervalSinceNow seconds: TimeInterval) {
        if seconds.isZero {
            self = Self.now()
            return
        }
        let futureDate = Date(timeIntervalSinceNow: seconds)
        self.init(future: futureDate)
    }
    
    /// Returns a Time Tag formed from total elapsed seconds since 1990 (prime epoch).
    public init(timeIntervalSince1900 seconds: TimeInterval) {
        let converted = seconds.oscTimeTag
        self.init(converted.timeTag, era: converted.era)
    }
    
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use ``immediate()`` instead of
    /// `init(at: Date())`.
    ///
    /// Passing `Date` that is `< now` will produce a Time Tag of ``now()``.
    public init(future futureDate: Date) {
        self.init(timeIntervalSince1900: futureDate.timeIntervalSince(Self.primeEpoch))
    }
}
