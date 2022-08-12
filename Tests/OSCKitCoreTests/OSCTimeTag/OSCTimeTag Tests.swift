//
//  OSCTimeTag Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCTimeTag_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit_RawValue() {
        // ensure all raw values including 0 and 1 are allowed
        XCTAssertEqual(OSCTimeTag(0).rawValue, 0)
        XCTAssertEqual(OSCTimeTag(1).rawValue, 1)
        XCTAssertEqual(OSCTimeTag(2).rawValue, 2)
        XCTAssertEqual(OSCTimeTag(timeTag1Jan2022).rawValue, timeTag1Jan2022)
        XCTAssertEqual(OSCTimeTag(timeTag1Jan2050, era: 1).rawValue, timeTag1Jan2050)
        XCTAssertEqual(OSCTimeTag(timeTag1Jan2200, era: 2).rawValue, timeTag1Jan2200)
        XCTAssertEqual(OSCTimeTag(UInt64.max).rawValue, UInt64.max)
    }
    
    // MARK: - .init(timeIntervalSinceNow:)
    
    func testInit_timeIntervalSinceNow_Zero() {
        let tag = OSCTimeTag(timeIntervalSinceNow: 0.0)
        
        XCTAssertGreaterThan(tag.rawValue, timeTag1Jan2022)
        XCTAssertEqual(tag.era, 0)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
    }
    
    func testInit_timeIntervalSinceNow_EdgeCase_Negative() {
        let tag = OSCTimeTag(timeIntervalSinceNow: -10.0)
        
        XCTAssertNotEqual(tag.rawValue, 0)
        XCTAssertNotEqual(tag.rawValue, 1)
        XCTAssertEqual(tag.era, 0)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertLessThan(tag.date, Date())
        XCTAssertEqual(tag.timeIntervalSinceNow(), -10.0, accuracy: 0.001)
    }
    
    // MARK: - .init(timeIntervalSince1900:)
    
    func testInit_timeIntervalSince1900_Zero() {
        let tag = OSCTimeTag(timeIntervalSince1900: 0.0)
        
        XCTAssertEqual(tag.rawValue, 0)
        XCTAssertEqual(tag.era, 0)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertEqual(tag.date, primeEpoch)
        XCTAssertLessThan(tag.timeIntervalSinceNow(), 0.0)
    }
    
    func testInit_timeIntervalSince1900() {
        let tag = OSCTimeTag(timeIntervalSince1900: 10.0)
        
        XCTAssertEqual(tag.rawValue, 10 << 32)
        XCTAssertEqual(tag.era, 0)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertEqual(tag.date, primeEpoch + 10.0)
        XCTAssertLessThan(tag.timeIntervalSinceNow(), 10.0)
    }
    
    func testInit_timeIntervalSince1900_EdgeCase_Negative() {
        // negative values should clamp to 0.
        let tag = OSCTimeTag(timeIntervalSince1900: -1.0)
        
        XCTAssertEqual(tag.rawValue, 0)
        XCTAssertEqual(tag.era, 0)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertEqual(tag.date, primeEpoch)
        XCTAssertLessThan(tag.timeIntervalSinceNow(), 0.0)
    }
    
    func testInit_timeIntervalSince1900_Known() {
        let tag = OSCTimeTag(timeIntervalSince1900: seconds1Jan2022)
        
        XCTAssertEqual(tag.rawValue, timeTag1Jan2022)
        XCTAssertEqual(tag.era, 0)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertEqual(tag.date, date1Jan2022)
        XCTAssertLessThan(tag.timeIntervalSinceNow(), 0.0)
        XCTAssertEqual(tag.timeInterval(since: primeEpoch), seconds1Jan2022)
    }
    
    func testKnownEra0TimeTag() {
        // use a known raw time tag value to test calculations
        // (for this test to succeed, the system's date must be > Jan 1st 2022)
        
        let tag = OSCTimeTag(timeTag1Jan2022)
        
        XCTAssertEqual(tag.rawValue, timeTag1Jan2022)
        XCTAssertEqual(tag.era, 0)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertLessThan(tag.date, Date())
        XCTAssertLessThan(tag.timeIntervalSinceNow(), 0.0)
        XCTAssertEqual(tag.timeInterval(since: primeEpoch), seconds1Jan2022)
    }
    
    func testKnownEra1TimeTag() {
        // use a known raw time tag value to test calculations
        
        let tag = OSCTimeTag(timeTag1Jan2050, era: 1)
        
        XCTAssertEqual(tag.rawValue, timeTag1Jan2050)
        XCTAssertEqual(tag.era, 1)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertEqual(tag.date, date1Jan2050)
        XCTAssertGreaterThan(tag.timeIntervalSinceNow(), 0.0)
        XCTAssertEqual(tag.timeInterval(since: primeEpoch), seconds1Jan2050)
    }
    
    func testKnownEra2TimeTag() {
        // use a known raw time tag value to test calculations
        
        let tag = OSCTimeTag(timeTag1Jan2200, era: 2)
        
        XCTAssertEqual(tag.rawValue, timeTag1Jan2200)
        XCTAssertEqual(tag.era, 2)
        XCTAssertFalse(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertEqual(tag.date, date1Jan2200)
        XCTAssertGreaterThan(tag.timeIntervalSinceNow(), 0.0)
        XCTAssertEqual(tag.timeInterval(since: primeEpoch), seconds1Jan2200)
    }
    
    // MARK: - .immediate() (raw value of 1)
    
    func testImmediate() {
        let tag = OSCTimeTag.immediate()
        
        XCTAssertEqual(tag.rawValue, 1)
        XCTAssertEqual(tag.era, Date().ntpEra)
        XCTAssertTrue(tag.isImmediate)
        XCTAssertFalse(tag.isFuture)
        XCTAssertEqual(
            tag.date.timeIntervalSince(Date()),
            0.0
        )
        XCTAssertEqual(tag.timeIntervalSinceNow(), 0.0)
    }
    
    // MARK: - .now()
    
    func testNow_rawValue() {
        let tag = OSCTimeTag.now()
        XCTAssertGreaterThan(tag.rawValue, timeTag1Jan2022)
    }
    
    func testNow_era() {
        let tag = OSCTimeTag.now()
        XCTAssertEqual(tag.era, Date().ntpEra)
    }
    
    func testNow_isImmediate() {
        let tag = OSCTimeTag.now()
        XCTAssertFalse(tag.isImmediate)
    }
    
    func testNow_isFuture() {
        let tag = OSCTimeTag.now()
        XCTAssertFalse(tag.isFuture)
    }
    
    func testNow_date() {
        let tag = OSCTimeTag.now()
        let captureDate = tag.date
        XCTAssertEqual(
            Date().timeIntervalSince(captureDate),
            0.0,
            accuracy: 0.001
        )
    }
    
    func testNow_timeIntervalSinceNow() {
        let tag = OSCTimeTag.now()
        let captureSecondsFromNow = tag.timeIntervalSinceNow()
        XCTAssertEqual(
            captureSecondsFromNow,
            0.0,
            accuracy: 0.001
        )
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

#endif
