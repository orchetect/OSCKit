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
    
    func testOSCValue_TimeTagNow() {
        let val: any OSCValue = .timeTagNow()
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag.now())
    }
    
    func testOSCValue_TimeTagSecondsSinceNow() {
        let val: any OSCValue = .timeTag(secondsSinceNow: 5.0)
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag(secondsSinceNow: 5.0))
    }
    
    func testOSCValue_TimeTagSecondsSince1900() {
        let val: any OSCValue = .timeTag(secondsSince1900: 9467107200.0)
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag(secondsSince1900: 9467107200.0))
    }
    
    func testOSCValue_TimeTagFuture() {
        let futureDate = Date().advanced(by: 200.0)
        let val: any OSCValue = .timeTag(future: futureDate)
        XCTAssertEqual(val as? OSCTimeTag, OSCTimeTag(future: futureDate))
    }
}

#endif
