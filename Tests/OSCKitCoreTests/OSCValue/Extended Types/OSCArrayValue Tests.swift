//
//  OSCArrayValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCArrayValue_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testEmpty() throws {
        let msg = OSCMessage("/test", values: [OSCArrayValue([])])
        
        XCTAssertEqual(msg.values[0] as? OSCArrayValue, OSCArrayValue([]))
        
        // test encode and decode
        let rawData = try msg.rawData()
        let decodedMsg = try OSCMessage(from: rawData)
        XCTAssertEqual(msg, decodedMsg)
    }
    
    func testSimple() throws {
        let msg = OSCMessage("/test", values: [OSCArrayValue([Int32(123)])])
        
        XCTAssertEqual(msg.values[0] as? OSCArrayValue, OSCArrayValue([Int32(123)]))
        
        // test encode and decode
        let rawData = try msg.rawData()
        let decodedMsg = try OSCMessage(from: rawData)
        XCTAssertEqual(msg, decodedMsg)
    }
    
    func testNested() throws {
        let msg = OSCMessage(
            "/test",
            values: [
                Int32(123),
                
                OSCArrayValue([
                    true,
                    String("A string"),
                    OSCArrayValue([
                        false
                    ])
                ]),
                
                Double(1.5),
                
                OSCArrayValue([
                    // empty array
                ]),
                
                OSCArrayValue([
                    String("Another string")
                ])
            ]
        )
        
        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
        
        let val1 = try XCTUnwrap(msg.values[1] as? OSCArrayValue)
        XCTAssertEqual(val1.elements[0] as? Bool, true)
        XCTAssertEqual(val1.elements[1] as? String, String("A string"))
        let val1C = try XCTUnwrap(val1.elements[2] as? OSCArrayValue)
        XCTAssertEqual(val1C.elements[0] as? Bool, false)
        
        XCTAssertEqual(msg.values[2] as? Double, Double(1.5))
        
        let val3 = try XCTUnwrap(msg.values[3] as? OSCArrayValue)
        XCTAssertTrue(val3.elements.isEmpty)
        
        let val4 = try XCTUnwrap(msg.values[4] as? OSCArrayValue)
        XCTAssertEqual(val4.elements[0] as? String, String("Another string"))
        
        // test encode and decode
        let rawData = try msg.rawData()
        let decodedMsg = try OSCMessage(from: rawData)
        XCTAssertEqual(msg, decodedMsg)
    }
    
    // MARK: - `any OSCValue` Constructors
    
    func testOSCValue_array() {
        let val: any OSCValue = .array([Int32(123)])
        XCTAssertEqual(
            val as? OSCArrayValue,
            OSCArrayValue([Int32(123)])
        )
    }
}

#endif
