//
//  OSCTimeTag Static Constructors.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

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
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead of `init(timeIntervalSinceNow: 0.0)`.
    ///
    /// Passing `seconds` that is `< 0.0` will produce a Time Tag of `.now()`.
    public static func timeIntervalSinceNow(_ seconds: TimeInterval) -> Self {
        self.init(timeIntervalSinceNow: seconds)
    }
    
    /// Returns a Time Tag formed from total elapsed seconds since 1990 (prime epoch).
    public static func timeIntervalSince1900(_ seconds: TimeInterval) -> Self {
        self.init(timeIntervalSince1900: seconds)
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

// MARK: - `any OSCValue` Constructors

extension OSCValue where Self == OSCTimeTag {
    /// Initialize from a raw OSC Time Tag value.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead.
    @inlinable
    public static func timeTag(_ rawValue: Self.RawValue, era: Int = 0) -> Self {
        OSCTimeTag(rawValue, era: era)
    }
    
    /// Returns a Time Tag with value of `1`, a special time value indicating "now" in the OSC spec.
    @inlinable
    public static func timeTagImmediate() -> Self {
        OSCTimeTag.immediate()
    }
    
    /// Returns a Time Tag representing the current time.
    /// To indicate immediate dispatch, use `.immediate()` instead.
    @inlinable
    public static func timeTagNow() -> Self {
        OSCTimeTag.now()
    }
    
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead of `init(timeIntervalSinceNow: 0.0)`.
    ///
    /// Passing `seconds` that is `< 0.0` will produce a Time Tag of `.now()`.
    @inlinable
    public static func timeTag(timeIntervalSinceNow seconds: TimeInterval) -> Self {
        OSCTimeTag(timeIntervalSinceNow: seconds)
    }
    
    /// Returns a Time Tag formed from total elapsed seconds since 1990 (prime epoch).
    @inlinable
    public static func timeTag(timeIntervalSince1900 seconds: TimeInterval) -> Self {
        OSCTimeTag(timeIntervalSince1900: seconds)
    }
    
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead of `init(at: Date())`.
    ///
    /// Passing `Date` that is `< now` will produce a Time Tag of `.now()`.
    @inlinable
    public static func timeTag(future futureDate: Date) -> Self {
        OSCTimeTag(future: futureDate)
    }
}
