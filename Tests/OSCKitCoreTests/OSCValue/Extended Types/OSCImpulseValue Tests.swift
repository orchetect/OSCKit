//
//  OSCImpulseValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCImpulseValue_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - `any OSCValue` Constructors
    
    func testOSCValue_impulse() {
        let val: any OSCValue = .impulse
        XCTAssertEqual(val as? OSCImpulseValue, OSCImpulseValue())
    }
}

#endif
