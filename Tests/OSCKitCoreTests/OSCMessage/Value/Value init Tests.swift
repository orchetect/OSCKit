//
//  Value init Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCMessage_Value_init_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Core types
    
    func testInt32() {
        let val = OSCValue(Int32(123))
        XCTAssertEqual(val, .int32(123))
    }
    
    func testFloat32() {
        let val = OSCValue(Float32(123.45))
        XCTAssertEqual(val, .float32(123.45))
    }
    
    func testString() {
        let val1 = OSCValue("A string")
        XCTAssertEqual(val1, .string("A string"))
        
        // a single character string (grapheme cluster) could possibly be confused with an ASCIICharacter literal
        // this is avoided by giving the OSCValue init for .character an explicit label of OSCValue(character:)
        
        let val2 = OSCValue("A")
        XCTAssertEqual(val2, .string("A"))
    }
    
    func testBlob() {
        let val = OSCValue(Data([1, 2, 3, 4]))
        XCTAssertEqual(val, .blob(Data([1, 2, 3, 4])))
    }
    
    // MARK: - Extended types
    
    func testInt64() {
        let val = OSCValue(Int64(123))
        XCTAssertEqual(val, .int64(123))
    }
    
    func testTimeTag() {
        let val = OSCValue(timeTag: .init(123))
        XCTAssertEqual(val, .timeTag(.init(123)))
    }
    
    func testDouble() {
        let val = OSCValue(123.45)
        XCTAssertEqual(val, .double(123.45))
    }
    
    func testStringAlt() {
        let val1 = OSCValue(stringAlt: "A string")
        XCTAssertEqual(val1, .stringAlt("A string"))
        
        // a single character string (grapheme cluster) could possibly be confused with an ASCIICharacter literal
        // this is avoided by giving the OSCValue init for .character an explicit label of OSCValue(character:)
        
        let val2 = OSCValue(stringAlt: "A")
        XCTAssertEqual(val2, .stringAlt("A"))
    }
    
    func testCharacter() {
        let val = OSCValue(character: "A")
        XCTAssertEqual(val, .character("A"))
    }
    
    func testMIDI() {
        // enum
        let source: OSCValue = .midi(
            OSCValue.MIDIMessage(
                portID: 0x80,
                status: 0x50,
                data1: 0x40,
                data2: 0x50
            )
        )
        
        // OSCValue(MIDIMessage)
        XCTAssertEqual(
            source,
            OSCValue(OSCValue.MIDIMessage(
                portID: 0x80,
                status: 0x50,
                data1: 0x40,
                data2: 0x50
            ))
        )
        
        // OSCValue(MIDIMessage) as .init() shorthand
        XCTAssertEqual(
            source,
            .midi(.init(
                portID: 0x80,
                status: 0x50,
                data1: 0x40,
                data2: 0x50
            ))
        )
        
        // OSCValue.midi(MIDIMessage) static func
        XCTAssertEqual(
            source,
            .midi(
                portID: 0x80,
                status: 0x50,
                data1: 0x40,
                data2: 0x50
            )
        )
    }
    
    func testBool() {
        let val1 = OSCValue(true)
        XCTAssertEqual(val1, .bool(true))
        
        let val2 = OSCValue(false)
        XCTAssertEqual(val2, .bool(false))
    }
}

#endif
