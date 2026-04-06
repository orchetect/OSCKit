//
//  Date Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Date
import typealias Foundation.TimeInterval
import struct Foundation.TimeZone
#else
import struct FoundationEssentials.Date
import typealias FoundationEssentials.TimeInterval
import struct FoundationEssentials.TimeZone
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

extension TimeZone {
    /// UTC timezone.
    package static let utc: TimeZone = TimeZone(abbreviation: "UTC") ?? {
        assertionFailure("Failed to create UTC timezone.")
        return if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            .gmt
        } else {
            .current
        }
    }()
}
