//
//  OSCAddressSpace Utilities Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore

final class OSCAddressSpace_Utilities_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testNodeValidateName() {
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "")
        )
        
        XCTAssertTrue(
            OSCAddressSpace.Node.validate(name: "abcDEF1234")
        )
        
        XCTAssertTrue(
            OSCAddressSpace.Node.validate(name: "abc]p} ,.DEF1234-")
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc?d")
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc*")
        )
        
        XCTAssertTrue(
            OSCAddressSpace.Node.validate(name: "a bc")
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc{d,e}f")
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc{d,e}f")
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "/abcDEF1234")
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abcDEF1234/")
        )
    }
    
    func testNodeValidateNameStrict() {
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "", strict: true)
        )
        
        XCTAssertTrue(
            OSCAddressSpace.Node.validate(name: "abcDEF1234", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc]p} ,.DEF1234-", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc?d", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc*", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "a bc", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "/abcDEF1234", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddressSpace.Node.validate(name: "abcDEF1234/", strict: true)
        )
    }
}

#endif
