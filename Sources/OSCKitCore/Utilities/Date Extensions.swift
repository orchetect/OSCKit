//
//  Date Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension Date {
    /// Returns total seconds elapsed since 1990.
    @_disfavoredOverload
    public var timeIntervalSince1900: TimeInterval {
        timeIntervalSince(OSCTimeTag.primeEpoch)
    }
    
    /// Returns the NTP era.
    @_disfavoredOverload
    public var ntpEra: Int {
        Int(timeIntervalSince(OSCTimeTag.primeEpoch) / OSCTimeTag.eraDuration)
    }
}
