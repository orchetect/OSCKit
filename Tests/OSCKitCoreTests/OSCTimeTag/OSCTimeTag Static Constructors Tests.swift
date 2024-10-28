//
//  OSCTimeTag Static Constructors Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import XCTest

final class OSCTimeTag_StaticConstructors_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Static Constructors
    
    func testTimeTagImmediate() {
        let val: OSCTimeTag = .immediate()
        XCTAssertEqual(val, OSCTimeTag(1))
    }
    
    // MARK: - `any OSCValue` Constructors
    
    func testOSCValue_timeTag() {
        let val: any OSCValue = .timeTag(123, era: 1)
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag(123, era: 1))
    }
    
    func testOSCValue_timeTagImmediate() {
        let val: any OSCValue = .timeTagImmediate()
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag.immediate())
    }
    
    func testOSCValue_timeTagNow() throws {
        let val: any OSCValue = .timeTagNow()
        let now = OSCTimeTag.now()
        
        let valTI = try XCTUnwrap((val as? OSCTimeTag)?.timeInterval(since: primeEpoch))
        let nowTI = now.timeInterval(since: primeEpoch)
        
        XCTAssertEqual(valTI, nowTI, accuracy: 0.001)
    }
    
    func testOSCValue_timeTagTimeIntervalSinceNow() throws {
        let val: any OSCValue = .timeTag(timeIntervalSinceNow: 5.0)
        let now = OSCTimeTag(timeIntervalSinceNow: 5.0)
        
        let valTI = try XCTUnwrap((val as? OSCTimeTag)?.timeInterval(since: primeEpoch))
        let nowTI = now.timeInterval(since: primeEpoch)
        
        XCTAssertEqual(valTI, nowTI, accuracy: 0.001)
    }
    
    func testOSCValue_timeTagTimeIntervalSince1900() {
        let val: any OSCValue = .timeTag(timeIntervalSince1900: 9_467_107_200.0)
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag(timeIntervalSince1900: 9_467_107_200.0))
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6, *)
    func testOSCValue_timeTagFuture() {
        let futureDate = Date().advanced(by: 200.0)
        let val: any OSCValue = .timeTag(future: futureDate)
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag(future: futureDate))
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
