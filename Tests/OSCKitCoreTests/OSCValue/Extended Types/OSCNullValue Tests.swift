//
//  OSCNullValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import XCTest

final class OSCNullValue_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - `any OSCValue` Constructors
    
    func testOSCValue_null() {
        let val: any OSCValue = .null
        XCTAssertEqual(val as? OSCNullValue, OSCNullValue())
    }
}
