//
//  OSCNullValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCNullValue_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - `any OSCValue` Constructors
    
    func testOSCValue_null() {
        let val: any OSCValue = .null
        XCTAssertEqual(val as? OSCNullValue, OSCNullValue())
    }
}

#endif
