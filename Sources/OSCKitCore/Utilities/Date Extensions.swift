//
//  Date Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

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
