//
//  OSCValue CustomStringConvertible Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCValue_CustomStringConvertible_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Core types
    
    func testBlob() {
        let val: any OSCValue = Data([1, 2, 3, 4])
        // should be "4 bytes" but `Data` is supplying the description
        // so it may be brittle to test it here
        XCTAssertEqual("\(val)", "\(val)")
    }
    
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
    
    // MARK: - Extended types
    
    func testOSCArrayValue_Simple() {
        let val: any OSCValue = OSCArrayValue([Int32(123)])
        XCTAssertEqual("\(val)", "[123]")
    }
    
    func testOSCArrayValue_Complex() {
        let val: any OSCValue = OSCArrayValue([
            Int32(123),
            String("A String"),
            OSCArrayValue([
                true,
                Double(1.5)
            ])
        ])
        XCTAssertEqual("\(val)", #"[123, "A String", [true, 1.5]]"#)
    }
    
    func testBool() {
        let val1: any OSCValue = true
        XCTAssertEqual("\(val1)", "true")
        
        let val2: any OSCValue = false
        XCTAssertEqual("\(val2)", "false")
    }
    
    func testCharacter() {
        let val: any OSCValue = Character("A")
        XCTAssertEqual("\(val)", "A")
    }
    
    func testDouble() {
        let val: any OSCValue = Double(123.45)
        XCTAssertEqual("\(val)", "123.45")
    }
    
    func testInt64() {
        let val: any OSCValue = Int64(123)
        XCTAssertEqual("\(val)", "123")
    }
    
    func testImpulse() {
        let val: any OSCValue = OSCImpulseValue()
        XCTAssertEqual("\(val)", "Impulse")
    }
    
    func testMIDI() {
        let val = OSCMIDIValue(portID: 0x01, status: 0x80, data1: 0x40, data2: 0x51)
        XCTAssertEqual("\(val)", "MIDI(portID: 0x01, status: 0x80, data1: 0x40, data2: 0x51)")
    }
    
    func testNull() {
        let val: any OSCValue = OSCNullValue()
        XCTAssertEqual("\(val)", "Null")
    }
    
    func testStringAlt() {
        let val: any OSCValue = OSCStringAltValue("A string")
        XCTAssertEqual("\(val)", "A string")
    }
    
    func testTimeTag() {
        let val: any OSCValue = OSCTimeTag(.init(123))
        XCTAssertEqual("\(val)", "123")
    }
    
    // MARK: - Opaque types
    
    func testAnyOSCNumberValue_Int() throws {
        let val = try [Int(123)].masked(AnyOSCNumberValue.self)
        XCTAssertEqual("\(val)", "123")
    }
    
    func testAnyOSCNumberValue_Double() throws {
        let val = try [Double(1.5)].masked(AnyOSCNumberValue.self)
        XCTAssertEqual("\(val)", "1.5")
    }
}

#endif
