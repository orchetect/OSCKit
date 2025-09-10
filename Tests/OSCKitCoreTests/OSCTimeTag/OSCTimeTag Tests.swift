//
//  OSCTimeTag Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing

@Suite struct OSCTimeTag_Tests {
    // De-flake mitigation: allow more time variance for CI pipeline
    #if os(macOS)
    let tolerance: TimeInterval = 0.001
    #elseif targetEnvironment(macCatalyst) || os(iOS) || os(tvOS) || os(watchOS)
    let tolerance: TimeInterval = 0.01
    #else // linux
    let tolerance: TimeInterval = 0.001
    #endif
    
    @Test
    func init_RawValue() {
        // ensure all raw values including 0 and 1 are allowed
        #expect(OSCTimeTag(0).rawValue == 0)
        #expect(OSCTimeTag(1).rawValue == 1)
        #expect(OSCTimeTag(2).rawValue == 2)
        #expect(OSCTimeTag(timeTag1Jan2022).rawValue == timeTag1Jan2022)
        #expect(OSCTimeTag(timeTag1Jan2050, era: 1).rawValue == timeTag1Jan2050)
        #expect(OSCTimeTag(timeTag1Jan2200, era: 2).rawValue == timeTag1Jan2200)
        #expect(OSCTimeTag(UInt64.max).rawValue == UInt64.max)
    }
    
    // MARK: - .init(timeIntervalSinceNow:)
    
    @Test
    func init_timeIntervalSinceNow_Zero() {
        let tag = OSCTimeTag(timeIntervalSinceNow: 0.0)
        
        #expect(tag.rawValue > timeTag1Jan2022)
        #expect(tag.era == 0)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
    }
    
    @Test
    func init_timeIntervalSinceNow_EdgeCase_Negative() {
        let tag = OSCTimeTag(timeIntervalSinceNow: -10.0)
        
        #expect(tag.rawValue != 0)
        #expect(tag.rawValue != 1)
        #expect(tag.era == 0)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
        #expect(tag.date < Date())
        #expect(tag.timeIntervalSinceNow().isApproximatelyEqual(to: -10.0, absoluteTolerance: tolerance))
    }
    
    // MARK: - .init(timeIntervalSince1900:)
    
    @Test
    func init_timeIntervalSince1900_Zero() {
        let tag = OSCTimeTag(timeIntervalSince1900: 0.0)
        
        #expect(tag.rawValue == 0)
        #expect(tag.era == 0)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
        #expect(tag.date == primeEpoch)
        #expect(tag.timeIntervalSinceNow() < 0.0)
    }
    
    @Test
    func init_timeIntervalSince1900() {
        let tag = OSCTimeTag(timeIntervalSince1900: 10.0)
        
        #expect(tag.rawValue == 10 << 32)
        #expect(tag.era == 0)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
        #expect(tag.date == primeEpoch + 10.0)
        #expect(tag.timeIntervalSinceNow() < 10.0)
    }
    
    @Test
    func init_timeIntervalSince1900_EdgeCase_Negative() {
        // negative values should clamp to 0.
        let tag = OSCTimeTag(timeIntervalSince1900: -1.0)
        
        #expect(tag.rawValue == 0)
        #expect(tag.era == 0)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
        #expect(tag.date == primeEpoch)
        #expect(tag.timeIntervalSinceNow() < 0.0)
    }
    
    @Test
    func init_timeIntervalSince1900_Known() {
        let tag = OSCTimeTag(timeIntervalSince1900: seconds1Jan2022)
        
        #expect(tag.rawValue == timeTag1Jan2022)
        #expect(tag.era == 0)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
        #expect(tag.date == date1Jan2022)
        #expect(tag.timeIntervalSinceNow() < 0.0)
        #expect(tag.timeInterval(since: primeEpoch) == seconds1Jan2022)
    }
    
    @Test
    func knownEra0TimeTag() {
        // use a known raw time tag value to test calculations
        // (for this test to succeed, the system's date must be > Jan 1st 2022)
        
        let tag = OSCTimeTag(timeTag1Jan2022)
        
        #expect(tag.rawValue == timeTag1Jan2022)
        #expect(tag.era == 0)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
        #expect(tag.date < Date())
        #expect(tag.timeIntervalSinceNow() < 0.0)
        #expect(tag.timeInterval(since: primeEpoch) == seconds1Jan2022)
    }
    
    @Test
    func knownEra1TimeTag() {
        // use a known raw time tag value to test calculations
        
        let tag = OSCTimeTag(timeTag1Jan2050, era: 1)
        
        #expect(tag.rawValue == timeTag1Jan2050)
        #expect(tag.era == 1)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
        #expect(tag.date == date1Jan2050)
        #expect(tag.timeIntervalSinceNow() > 0.0)
        #expect(tag.timeInterval(since: primeEpoch) == seconds1Jan2050)
    }
    
    @Test
    func knownEra2TimeTag() {
        // use a known raw time tag value to test calculations
        
        let tag = OSCTimeTag(timeTag1Jan2200, era: 2)
        
        #expect(tag.rawValue == timeTag1Jan2200)
        #expect(tag.era == 2)
        #expect(!tag.isImmediate)
        #expect(!tag.isFuture)
        #expect(tag.date == date1Jan2200)
        #expect(tag.timeIntervalSinceNow() > 0.0)
        #expect(tag.timeInterval(since: primeEpoch) == seconds1Jan2200)
    }
    
    // MARK: - .immediate() (raw value of 1)
    
    @Test
    func immediate_Basics() {
        let tag = OSCTimeTag.immediate()
        #expect(tag.rawValue == 1)
        #expect(tag.era == Date().ntpEra)
        #expect(tag.isImmediate)
        #expect(!tag.isFuture)
    }
    
    @Test
    func immediate_date() {
        let tag = OSCTimeTag.immediate()
        let date = Date()
        #expect(tag.date.timeIntervalSince(date).isApproximatelyEqual(to: 0.0, absoluteTolerance: tolerance))
    }
    
    @Test
    func immediate_timeIntervalSinceNow() {
        let tag = OSCTimeTag.immediate()
        let captureSecondsFromNow = tag.timeIntervalSinceNow()
        #expect(captureSecondsFromNow.isApproximatelyEqual(to: 0.0, absoluteTolerance: tolerance))
    }
    
    // MARK: - .now()
    
    @Test
    func now_rawValue() {
        let tag = OSCTimeTag.now()
        #expect(tag.rawValue > timeTag1Jan2022)
    }
    
    @Test
    func now_era() {
        let tag = OSCTimeTag.now()
        #expect(tag.era == Date().ntpEra)
    }
    
    @Test
    func now_isImmediate() {
        let tag = OSCTimeTag.now()
        #expect(!tag.isImmediate)
    }
    
    @Test
    func now_isFuture() {
        let tag = OSCTimeTag.now()
        #expect(!tag.isFuture)
    }
    
    @Test
    func now_date() {
        let tag = OSCTimeTag.now()
        let captureDate = tag.date
        #expect(Date().timeIntervalSince(captureDate).isApproximatelyEqual(to: 0.0, absoluteTolerance: tolerance))
    }
    
    @Test
    func now_timeIntervalSinceNow() {
        let tag = OSCTimeTag.now()
        let captureSecondsFromNow = tag.timeIntervalSinceNow()
        #expect(captureSecondsFromNow.isApproximatelyEqual(to: 0.0, absoluteTolerance: tolerance))
    }
}

// MARK: - Helpers

/// NTP prime epoch, a.k.a. era 0.
private let primeEpoch: Date = DateComponents(
    calendar: .current,
    timeZone: .current,
    year: 1900,
    month: 1,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0
).date!

/// For testing purposes, a known era-0 Time Tag value describing January 1st 2022.
private let timeTag1Jan2022: UInt64 = 16_535_555_370_123_264_000
private let seconds1Jan2022 = 3_849_984_000.0
private let date1Jan2022: Date = DateComponents(
    calendar: .current,
    timeZone: .current,
    year: 2022,
    month: 1,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0
).date!

/// For testing purposes, a known era-1 Time Tag value describing January 1st 2050.
private let timeTag1Jan2050: UInt64 = 1_883_899_379_035_668_480
private let seconds1Jan2050 = 4_733_596_800.0
private let date1Jan2050: Date = DateComponents(
    calendar: .current,
    timeZone: .current,
    year: 2050,
    month: 1,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0
).date!

/// For testing purposes, a known era-2 Time Tag value describing January 1st 2200.
private let timeTag1Jan2200: UInt64 = 3_767_427_672_896_962_560
private let seconds1Jan2200 = 9_467_107_200.0
private let date1Jan2200: Date = DateComponents(
    calendar: .current,
    timeZone: .current,
    year: 2200,
    month: 1,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0
).date!
