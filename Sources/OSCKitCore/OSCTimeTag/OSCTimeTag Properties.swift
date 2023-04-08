//
//  OSCTimeTag Properties.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

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
        isImmediate
            ? Date()
            : Self.primeEpoch.addingTimeInterval(rawValue.seconds(era: era))
    }
    
    /// Returns the delta time interval in seconds between _now_ and the Time Tag.
    public func timeIntervalSinceNow() -> TimeInterval {
        timeInterval(since: Date())
    }
    
    /// Returns the delta time interval in seconds between an arbitrary `Date` and the Time Tag.
    public func timeInterval(since other: Date) -> TimeInterval {
        isImmediate
            ? 0.0
            : date.timeIntervalSince(other)
    }
}
