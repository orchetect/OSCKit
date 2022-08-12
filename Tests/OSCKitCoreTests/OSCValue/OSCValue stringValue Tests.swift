//
//  OSCValue stringValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCValue_stringValue_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Core types
    
    func testInt32() {
        let val: any OSCValue = Int32(123)
        XCTAssertEqual("\(val)", "123")
    }
    
    func testFloat32() {
        let val: any OSCValue = Float32(123.45)
        XCTAssertEqual("\(val)", "123.45")
    }
    
    func testString() {
        let val: any OSCValue = String("A string")
        XCTAssertEqual("\(val)", "A string")
    }
    
    func testBlob() {
        let val: any OSCValue = Data([1, 2, 3, 4])
        XCTAssertEqual("\(val)", "4 bytes")
    }
    
    // MARK: - Extended types
    
    func testInt64() {
        let val: any OSCValue = Int64(123)
        XCTAssertEqual("\(val)", "123")
    }
    
    func testTimeTag() {
        let val: any OSCValue = OSCTimeTag(.init(123))
        XCTAssertEqual("\(val)", "123")
    }
    
    func testDouble() {
        let val: any OSCValue = Double(123.45)
        XCTAssertEqual("\(val)", "123.45")
    }
    
    func testStringAlt() {
        let val: any OSCValue = OSCStringAltValue("A string")
        XCTAssertEqual("\(val)", "A string")
    }
    
    func testCharacter() {
        let val: any OSCValue = Character("A")
        XCTAssertEqual("\(val)", "A")
    }
    
    func testMIDI() {
        let val = OSCMIDIValue(portID: 0x80, status: 0x50, data1: 0x40, data2: 0x50)
        XCTAssertEqual("\(val)", "OSCMIDIValue(portID:80 status:50 data1:40 data2:50)")
    }
    
    func testBool() {
        let val1: any OSCValue = true
        XCTAssertEqual("\(val1)", "true")
        
        let val2: any OSCValue = false
        XCTAssertEqual("\(val2)", "false")
    }
    
    func testNull() {
        let val: any OSCValue = OSCNullValue()
        XCTAssertEqual("\(val)", "Null")
    }
    
    // TODO: add tests for new value types added in OSCKit 0.4.0
}

#endif
