//
//  OSCTimeTag init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCTimeTag {
    /// Returns a Time Tag representing a time in the future.
    ///
    /// If the intention is to produce an immediate Time Tag, use `.immediate()` instead of `init(secondsFromNow: 0.0)`.
    ///
    /// Passing `secondsFromNow` that is `< 0.0` will produce a Time Tag of `.now()`.
    public init(secondsFromNow seconds: TimeInterval) {
        if seconds.isZero {
            self = Self.now()
            return
        }
        let futureDate = Date(timeIntervalSinceNow: seconds)
            .timeIntervalSince(Self.primeEpoch)
        
        self.init(secondsSince1900: futureDate)
    }
    
    /// Returns a Time Tag formed from total elapsed seconds since 1990 (prime epoch).
    public init(secondsSince1900 seconds: TimeInterval) {
        let converted = seconds.oscTimeTag
        self.init(converted.timeTag, era: converted.era)
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
}
