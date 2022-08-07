//
//  OSCTimeTag Utilities.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCTimeTag {
    /// Prime epoch (NTP era 0).
    static let primeEpoch: Date = DateComponents(
        calendar: .current,
        timeZone: .current,
        year: 1900,
        month: 1,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0
    ).date ?? Date()
    
    /// Duration in seconds of an NTP era (approx 136.1 years).
    static let eraDuration = TimeInterval(UInt32.max)
    
    /// Returns the current era.
    static var currentEra: Int {
        Int(Date().timeIntervalSince(primeEpoch) / eraDuration)
    }
}

extension TimeInterval {
    /// Returns raw OSC Time Tag value from TimeInterval as seconds from 1990.
    var oscTimeTag: (timeTag: OSCTimeTag.RawValue, era: Int) {
        // early return for negative values or zero
        guard self > .zero else {
            return (timeTag: 0, era: 0)
        }
        
        // early return for prime epoch period (era 0)
        if self <= Double(UInt32.max) {
            let timeTag = UInt64(self * 0x1_0000_0000)
            return (timeTag: timeTag, era: 0)
        }
        
        // calculate era (rollover count)
        let calc = quotientAndRemainder(dividingBy: OSCTimeTag.eraDuration)
        
        let timeTag = calc.remainder * 0x1_0000_0000
        
        return (timeTag: UInt64(timeTag), era: Int(calc.remainder))
    }
}

extension OSCTimeTag.RawValue {
    /// Returns total elapsed seconds of the Time Tag since prime epoch.
    func seconds(era: Int) -> TimeInterval {
        let secs = TimeInterval(self) / 0x1_0000_0000
        if era == 0 {
            return secs
        } else if era == 1 {
            return OSCTimeTag.eraDuration + secs
        } else {
            return (TimeInterval(era) * OSCTimeTag.eraDuration) + secs
        }
    }
}

extension Date {
    /// Returns total seconds elapsed since 1990.
    @_disfavoredOverload
    public var secondsSince1900: TimeInterval {
        timeIntervalSince(OSCTimeTag.primeEpoch)
    }
    
    /// Returns the NTP era.
    @_disfavoredOverload
    public var ntpEra: Int {
        Int(timeIntervalSince(OSCTimeTag.primeEpoch) / OSCTimeTag.eraDuration)
    }
}
