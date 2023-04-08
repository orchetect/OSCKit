//
//  OSCMessage Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import SwiftASCII

final class OSCMessage_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Equatable
    
    func testEquatable() {
        let msg1 = OSCMessage("/msg1")
        let msg2 = OSCMessage("/msg2")
        let msg3 = OSCMessage("/msg1", values: [Int32(123)])
        
        XCTAssert(msg1 == msg1)
        XCTAssert(msg2 == msg2)
        XCTAssert(msg3 == msg3)
        
        XCTAssert(msg1 != msg2)
        XCTAssert(msg1 != msg3)
        
        XCTAssert(msg2 != msg3)
    }
    
    // MARK: - Hashable
    
    func testHashable() {
        let msg1 = OSCMessage("/msg1")
        let msg2 = OSCMessage("/msg2")
        let msg3 = OSCMessage("/msg1", values: [Int32(123)])
        
        let set: Set<OSCMessage> = [msg1, msg1, msg2, msg2, msg3, msg3]
        
        XCTAssertTrue(set == [msg1, msg2, msg3])
    }
    
    // MARK: - CustomStringConvertible
    
    func testCustomStringConvertible1() {
        let msg = OSCMessage("/")
        
        XCTAssertEqual(msg.description, #"OSCMessage("/")"#)
    }
    
    func testCustomStringConvertible2() {
        let msg = OSCMessage(
            "/address",
            values: [Int32(123), String("A string")]
        )
        
        XCTAssertEqual(
            msg.description,
            #"OSCMessage("/address", values: [123, "A string"])"#
        )
    }
    
    func testDescriptionPretty() {
        let msg = OSCMessage(
            "/address",
            values: [Int32(123), String("A string")]
        )
        
        XCTAssertEqual(
            msg.descriptionPretty,
            #"""
            OSCMessage("/address") with values:
              Int32: 123
              String: A string
            """#
        )
    }
}

#endif
