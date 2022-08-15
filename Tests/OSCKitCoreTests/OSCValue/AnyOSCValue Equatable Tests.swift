//
//  AnyOSCValue Equatable Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class AnyOSCValue_Equatable_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // since == and != are each custom implementations,
    // we need to test all conditions of both
    
    // MARK: - Core types
    
    func testBlob() {
        let val = Data([1, 2, 3, 4])
        let sameValue = val
        let sameTypeDifferentValue = Data([1, 2, 3])
        let relatedTypeSameValue = Int32(123)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testInt32() {
        let val = Int32(123)
        let sameValue = val
        let sameTypeDifferentValue = Int32(456)
        let relatedTypeSameValue = Int64(123)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertTrue(val == relatedTypeSameValue) // BinaryInteger comparison
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertFalse(val != relatedTypeSameValue) // BinaryInteger comparison
    }

    func testFloat32() {
        let val = Float32(1.0)
        let sameValue = val
        let sameTypeDifferentValue = Float32(2.0)
        let relatedTypeSameValue = Double(1.0)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertTrue(val == relatedTypeSameValue) // BinaryFloatingPoint comparison
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertFalse(val != relatedTypeSameValue) // BinaryFloatingPoint comparison
    }

    func testString() {
        let val = String("A string")
        let sameValue = val
        let sameTypeDifferentValue = String("Other")
        let relatedTypeSameValue = OSCStringAltValue("A string")
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    // MARK: - Extended types

    func testOSCArrayValue_Simple() {
        let val = OSCArrayValue([Int32(123)])
        let sameValue = val
        let sameTypeDifferentValue = OSCArrayValue([Int32(456)])
        let relatedTypeSameValue = Int32(123)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testOSCArrayValue_Complex() {
        let val = OSCArrayValue([
            Int32(123),
            String("A String"),
            OSCArrayValue([
                true,
                Double(1.5)
            ])
        ])
        let sameValue = val
        let sameTypeDifferentValue = OSCArrayValue([
            Int32(123),
            String("A String"),
            OSCArrayValue([
                true,
                Double(2.0)
            ])
        ])
        let relatedTypeSameValue = Int32(123)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testBool() {
        let val = true
        let sameValue = val
        let sameTypeDifferentValue = false
        let relatedTypeSameValue = Int32(1)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testCharacter() {
        let val = Character("A")
        let sameValue = val
        let sameTypeDifferentValue = Character("B")
        let relatedTypeSameValue = String("A")
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testDouble() {
        let val = Double(123.45)
        let sameValue = val
        let sameTypeDifferentValue = Double(456.78)
        let relatedTypeSameValue = Float32(123.45)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testInt64() {
        let val = Int64(123)
        let sameValue = val
        let sameTypeDifferentValue = Int64(456)
        let relatedTypeSameValue = Int32(123)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertTrue(val == relatedTypeSameValue) // BinaryInteger comparison
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertFalse(val != relatedTypeSameValue) // BinaryInteger comparison
    }

    func testImpulse() {
        let val = OSCImpulseValue()
        let sameValue = val
        let relatedTypeSameValue = OSCNullValue()
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testMIDI() {
        let val = OSCMIDIValue(portID: 0x01, status: 0x80, data1: 0x40, data2: 0x51)
        let sameValue = val
        let sameTypeDifferentValue = OSCMIDIValue(
            portID: 0x02,
            status: 0x80,
            data1: 0x40,
            data2: 0x51
        )
        let relatedTypeSameValue = Data([0x01, 0x80, 0x40, 0x51])
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testNull() {
        let val = OSCNullValue()
        let sameValue = val
        let relatedTypeSameValue = OSCImpulseValue()
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }

    func testStringAlt() {
        let val = OSCStringAltValue("A string")
        let sameValue = val
        let sameTypeDifferentValue = OSCStringAltValue("Other")
        let relatedTypeSameValue = String("A string")
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }
    
    func testTimeTag() {
        let val = OSCTimeTag(.init(123))
        let sameValue = val
        let sameTypeDifferentValue = OSCTimeTag(.init(456))
        let relatedTypeSameValue = UInt64(123)
        
        // ==
        XCTAssertTrue(val == sameValue)
        XCTAssertFalse(val == sameTypeDifferentValue)
        XCTAssertFalse(val == relatedTypeSameValue)
        
        // !=
        XCTAssertFalse(val != sameValue)
        XCTAssertTrue(val != sameTypeDifferentValue)
        XCTAssertTrue(val != relatedTypeSameValue)
    }
}

#endif
