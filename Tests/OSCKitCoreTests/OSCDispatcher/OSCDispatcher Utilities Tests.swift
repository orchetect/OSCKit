//
//  OSCDispatcher Utilities Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore

final class OSCDispatcher_Utilities_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testNodeValidateName() {
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "")
        )
        
        XCTAssertTrue(
            OSCDispatcher.Node.validate(name: "abcDEF1234")
        )
        
        XCTAssertTrue(
            OSCDispatcher.Node.validate(name: "abc]p} ,.DEF1234-")
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc?d")
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc*")
        )
        
        XCTAssertTrue(
            OSCDispatcher.Node.validate(name: "a bc")
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc{d,e}f")
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc{d,e}f")
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "/abcDEF1234")
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abcDEF1234/")
        )
    }
    
    func testNodeValidateNameStrict() {
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "", strict: true)
        )
        
        XCTAssertTrue(
            OSCDispatcher.Node.validate(name: "abcDEF1234", strict: true)
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc]p} ,.DEF1234-", strict: true)
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc?d", strict: true)
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc*", strict: true)
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "a bc", strict: true)
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "/abcDEF1234", strict: true)
        )
        
        XCTAssertFalse(
            OSCDispatcher.Node.validate(name: "abcDEF1234/", strict: true)
        )
    }
}

#endif
