//
//  Dispatcher Utilities Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCAddress_Dispatcher_Utilities_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testNodeValidateName() {
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Dispatcher.Node.validate(name: "abcDEF1234")
        )
        
        XCTAssertTrue(
            OSCAddress.Dispatcher.Node.validate(name: "abc]p} ,.DEF1234-")
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc?d")
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc*")
        )
        
        XCTAssertTrue(
            OSCAddress.Dispatcher.Node.validate(name: "a bc")
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc{d,e}f")
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc{d,e}f")
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "/abcDEF1234")
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abcDEF1234/")
        )
        
    }
    
    func testNodeValidateNameStrict() {
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "", strict: true)
        )
        
        XCTAssertTrue(
            OSCAddress.Dispatcher.Node.validate(name: "abcDEF1234", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc]p} ,.DEF1234-", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc?d", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc*", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "a bc", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "/abcDEF1234", strict: true)
        )
        
        XCTAssertFalse(
            OSCAddress.Dispatcher.Node.validate(name: "abcDEF1234/", strict: true)
        )
        
    }
    
}

#endif
