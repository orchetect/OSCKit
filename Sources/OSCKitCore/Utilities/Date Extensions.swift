//
//  Date Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Date
import typealias Foundation.TimeInterval
#else
import struct FoundationEssentials.Date
import typealias FoundationEssentials.TimeInterval
#endif

extension Date {
    /// Returns total seconds elapsed since 1990 (prime epoch, NTP era 0).
    @_disfavoredOverload
    package var timeIntervalSince1900: TimeInterval {
        timeIntervalSince(OSCTimeTag.primeEpoch)
    }
    
    /// Returns the NTP era.
    @_disfavoredOverload
    package var ntpEra: Int {
        Int(timeIntervalSince(OSCTimeTag.primeEpoch) / OSCTimeTag.eraDuration)
    }
}
