//
//  OSCStringAltValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OSCKitCore

final class OSCStringAltValue_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - `any OSCValue` Constructors
    
    func testOSCValue_stringAlt() {
        let val: any OSCValue = .stringAlt("A string")
        XCTAssertEqual(val as? OSCStringAltValue, OSCStringAltValue("A string"))
    }
}
