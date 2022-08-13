//
//  AnyOSCValue Equatable Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class AnyOSCValue_Equatable_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Core types
    
    func testBlob() {
        let val: any OSCValue = Data([1, 2, 3, 4])
        XCTAssertTrue(val == Data([1, 2, 3, 4]))
    }

    func testInt32() {
        let val: any OSCValue = Int32(123)
        XCTAssertTrue(val == Int32(123))
    }

    func testFloat32() {
        let val: any OSCValue = Float32(123.45)
        XCTAssertTrue(val == Float32(123.45))
    }

    func testString() {
        let val: any OSCValue = String("A string")
        XCTAssertTrue(val == String("A string"))
    }

    // MARK: - Extended types

    func testOSCArrayValue_Simple() {
        let val: any OSCValue = OSCArrayValue([Int32(123)])
        XCTAssertTrue(val == OSCArrayValue([Int32(123)]))
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
        XCTAssertTrue(
            val == OSCArrayValue([
                Int32(123),
                String("A String"),
                OSCArrayValue([
                    true,
                    Double(1.5)
                ])
            ])
        )
    }

    func testBool() {
        let val1: any OSCValue = true
        XCTAssertTrue(val1 == true)

        let val2: any OSCValue = false
        XCTAssertTrue(val2 == false)
    }

    func testCharacter() {
        let val: any OSCValue = Character("A")
        XCTAssertTrue(val == Character("A"))
    }

    func testDouble() {
        let val: any OSCValue = Double(123.45)
        XCTAssertTrue(val == Double(123.45))
    }

    func testInt64() {
        let val: any OSCValue = Int64(123)
        XCTAssertTrue(val == Int64(123))
    }

    func testImpulse() {
        let val: any OSCValue = OSCImpulseValue()
        XCTAssertTrue(val == OSCImpulseValue())
    }

    func testMIDI() {
        let val = OSCMIDIValue(portID: 0x01, status: 0x80, data1: 0x40, data2: 0x51)
        XCTAssertTrue(val == OSCMIDIValue(portID: 0x01, status: 0x80, data1: 0x40, data2: 0x51))
    }

    func testNull() {
        let val: any OSCValue = OSCNullValue()
        XCTAssertTrue(val == OSCNullValue())
    }

    func testStringAlt() {
        let val: any OSCValue = OSCStringAltValue("A string")
        XCTAssertTrue(val == OSCStringAltValue("A string"))
    }
    
    func testTimeTag() {
        let val: any OSCValue = OSCTimeTag(.init(123))
        XCTAssertTrue(val == OSCTimeTag(.init(123)))
    }
}

#endif
