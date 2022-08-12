//
//  OSCTimeTag init Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCTimeTag_init_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Static Constructors
    
    func testTimeTagImmediate() {
        let val: OSCTimeTag = .immediate()
        XCTAssertEqual(val, OSCTimeTag(1))
    }
    
    // MARK: - `any OSCValue` Constructors
    
    func testOSCValue_TimeTag() {
        let val: any OSCValue = .timeTag(123, era: 1)
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag(123, era: 1))
    }
    
    func testOSCValue_TimeTagImmediate() {
        let val: any OSCValue = .timeTagImmediate()
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag.immediate())
    }
    
    func testOSCValue_TimeTagNow() throws {
        let val: any OSCValue = .timeTagNow()
        let now = OSCTimeTag.now()
        
        let valTI = try XCTUnwrap((val as? OSCTimeTag)?.timeInterval(since: primeEpoch))
        let nowTI = now.timeInterval(since: primeEpoch)
        
        XCTAssertEqual(valTI, nowTI, accuracy: 0.001)
    }
    
    func testOSCValue_TimeTagTimeIntervalSinceNow() throws {
        let val: any OSCValue = .timeTag(timeIntervalSinceNow: 5.0)
        let now = OSCTimeTag(timeIntervalSinceNow: 5.0)
        
        let valTI = try XCTUnwrap((val as? OSCTimeTag)?.timeInterval(since: primeEpoch))
        let nowTI = now.timeInterval(since: primeEpoch)
        
        XCTAssertEqual(valTI, nowTI, accuracy: 0.001)
    }
    
    func testOSCValue_TimeTagTimeIntervalSince1900() {
        let val: any OSCValue = .timeTag(timeIntervalSince1900: 9467107200.0)
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag(timeIntervalSince1900: 9467107200.0))
    }
    
    func testOSCValue_TimeTagFuture() {
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

#endif
