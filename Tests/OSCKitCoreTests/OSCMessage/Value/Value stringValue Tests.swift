//
//  Value stringValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCMessage_Value_stringValue_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Core types
    
    func testInt32() {
        let val = OSCValue.int32(123)
        XCTAssertEqual(val.stringValue(), "123")
        XCTAssertEqual(val.stringValue(withLabel: true), "int32:123")
    }
    
    func testFloat32() {
        let val = OSCValue.float32(123.45)
        XCTAssertEqual(val.stringValue(), "123.45")
        XCTAssertEqual(val.stringValue(withLabel: true), "float32:123.45")
    }
    
    func testString() {
        let val = OSCValue.string("A string")
        XCTAssertEqual(
            val.stringValue(),
            "A string"
        )   // no wrapping quotes
        XCTAssertEqual(
            val.stringValue(withLabel: true),
            #"string:"A string""#
        ) // wrapping quotes
    }
    
    func testBlob() {
        let val04 = OSCValue.blob(Data([1, 2, 3, 4]))
        XCTAssertEqual(
            val04.stringValue(),
            "4 bytes"
        )        // no wrapping quotes
        XCTAssertEqual(
            val04.stringValue(withLabel: true),
            "blob:4 bytes"
        )        // wrapping quotes
    }
    
    // MARK: - Extended types
    
    func testInt64() {
        let val = OSCValue.int64(123)
        XCTAssertEqual(val.stringValue(), "123")
        XCTAssertEqual(val.stringValue(withLabel: true), "int64:123")
    }
    
    func testTimeTag() {
        let val = OSCValue.timeTag(.init(123))
        XCTAssertEqual(val.stringValue(), "123")
        XCTAssertEqual(val.stringValue(withLabel: true), "timeTag:123")
    }
    
    func testDouble() {
        let val = OSCValue.double(123.45)
        XCTAssertEqual(val.stringValue(), "123.45")
        XCTAssertEqual(val.stringValue(withLabel: true), "double:123.45")
    }
    
    func testStringAlt() {
        let val = OSCValue.stringAlt("A string")
        XCTAssertEqual(
            val.stringValue(),
            "A string"
        )     // no wrapping quotes
        XCTAssertEqual(
            val.stringValue(withLabel: true),
            #"stringAlt:"A string""#
        )   // wrapping quotes
    }
    
    func testCharacter() {
        let val = OSCValue.character("A")
        XCTAssertEqual(val.stringValue(), "A")
        XCTAssertEqual(val.stringValue(withLabel: true), "char:A")
    }
    
    func testMIDI() {
        let val = OSCValue.midi(portID: 0x80, status: 0x50, data1: 0x40, data2: 0x50)
        XCTAssertEqual(
            val.stringValue(),
            "MIDIMessage(portID:80 status:50 data1:40 data2:50)"
        )
        XCTAssertEqual(
            val.stringValue(withLabel: true),
            "MIDIMessage(portID:80 status:50 data1:40 data2:50)"
        )
    }
    
    func testBool() {
        let val1 = OSCValue.bool(true)
        XCTAssertEqual(val1.stringValue(), "true")
        XCTAssertEqual(val1.stringValue(withLabel: true), "bool:true")
        
        let val2 = OSCValue.bool(false)
        XCTAssertEqual(val2.stringValue(), "false")
        XCTAssertEqual(val2.stringValue(withLabel: true), "bool:false")
    }
    
    func testNull() {
        let val = OSCValue.null
        XCTAssertEqual(val.stringValue(), "Null")
        XCTAssertEqual(val.stringValue(withLabel: true), "Null")
    }
}

#endif
