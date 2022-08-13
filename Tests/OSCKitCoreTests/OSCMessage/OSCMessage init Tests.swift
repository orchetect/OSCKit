//
//  OSCMessage init Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import SwiftRadix
import SwiftASCII

final class OSCMessage_init_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
//    func testVariadicValues_SingleValue() {
//        let msg = OSCMessage(
//            "/msg1",
//            values: Int32(123)
//        )
//        
//        XCTAssertEqual(msg.addressPattern.stringValue, "/msg1")
//        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
//    }
//    
//    func testVariadicValues_MultipleValues() {
//        let msg = OSCMessage(
//            "/msg1",
//            values: Int32(123), String("A string"), Float32(123.45)
//        )
//        
//        XCTAssertEqual(msg.addressPattern.stringValue, "/msg1")
//        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
//        XCTAssertEqual(msg.values[1] as? String, "A string")
//        XCTAssertEqual(msg.values[2] as? Float32, Float32(123.45))
//    }
}

#endif
