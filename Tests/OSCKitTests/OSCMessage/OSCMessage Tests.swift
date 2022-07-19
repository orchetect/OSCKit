//
//  OSCMessage Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit
import SwiftRadix
import SwiftASCII

final class OSCMessage_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Equatable
    
    func testEquatable() {
        
        let msg1 = OSCMessage(address: "/msg1")
        let msg2 = OSCMessage(address: "/msg2")
        let msg3 = OSCMessage(address: "/msg1", values: [.int32(123)])
        
        XCTAssert(msg1 == msg1)
        XCTAssert(msg2 == msg2)
        XCTAssert(msg3 == msg3)
        
        XCTAssert(msg1 != msg2)
        XCTAssert(msg1 != msg3)
        
        XCTAssert(msg2 != msg3)
        
    }
    
    // MARK: - Hashable
    
    func testHashable() {
        
        let msg1 = OSCMessage(address: "/msg1")
        let msg2 = OSCMessage(address: "/msg2")
        let msg3 = OSCMessage(address: "/msg1", values: [.int32(123)])
        
        let set: Set<OSCMessage> = [msg1, msg1, msg2, msg2, msg3, msg3]
        
        XCTAssertTrue(set == [msg1, msg2, msg3])
        
    }
    
    // MARK: - CustomStringConvertible
    
    func testCustomStringConvertible1() {
        
        let msg = OSCMessage(address: "/")
        
        let desc = msg.description
        
        XCTAssertEqual(desc, "OSCMessage(address: \"/\")")
        
    }
    
    func testCustomStringConvertible2() {
        
        let msg = OSCMessage(address: "/address",
                             values: [.int32(123), .string("A string")])
        
        let desc = msg.description
        
        XCTAssertEqual(desc, #"OSCMessage(address: "/address", values: [int32:123, string:"A string"])"#)
        
    }
    
    func testDescriptionPretty() {
        
        let msg = OSCMessage(address: "/address",
                             values: [.int32(123), .string("A string")])
        
        let desc = msg.descriptionPretty
        
        XCTAssertEqual(desc,
            #"""
            OSCMessage(address: "/address") Values:
              int32:123
              string:"A string"
            """#)
        
    }
    
}

#endif
