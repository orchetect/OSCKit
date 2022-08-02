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
        let val = OSCMessage.Value(Int32(123))
        XCTAssertEqual(val, .int32(123))
    }
    
    func testFloat32() {
        let val = OSCMessage.Value(Float32(123.45))
        XCTAssertEqual(val, .float32(123.45))
    }
    
    func testString() {
        let val1 = OSCMessage.Value("A string")
        XCTAssertEqual(val1, .string("A string"))
        
        // a single character string (grapheme cluster) could possibly be confused with an ASCIICharacter literal
        // this is avoided by giving the OSCMessage.Value init for .character an explicit label of OSCMessage.Value(character:)
        
        let val2 = OSCMessage.Value("A")
        XCTAssertEqual(val2, .string("A"))
    }
    
    func testBlob() {
        let val = OSCMessage.Value(Data([1, 2, 3, 4]))
        XCTAssertEqual(val, .blob(Data([1, 2, 3, 4])))
    }
    
    // MARK: - Extended types
    
    func testInt64() {
        let val = OSCMessage.Value(Int64(123))
        XCTAssertEqual(val, .int64(123))
    }
    
    func testTimeTag() {
        let val = OSCMessage.Value(timeTag: 123)
        XCTAssertEqual(val, .timeTag(123))
    }
    
    func testDouble() {
        let val = OSCMessage.Value(123.45)
        XCTAssertEqual(val, .double(123.45))
    }
    
    func testStringAlt() {
        let val1 = OSCMessage.Value(stringAlt: "A string")
        XCTAssertEqual(val1, .stringAlt("A string"))
        
        // a single character string (grapheme cluster) could possibly be confused with an ASCIICharacter literal
        // this is avoided by giving the OSCMessage.Value init for .character an explicit label of OSCMessage.Value(character:)
        
        let val2 = OSCMessage.Value(stringAlt: "A")
        XCTAssertEqual(val2, .stringAlt("A"))
    }
    
    func testCharacter() {
        let val = OSCMessage.Value(character: "A")
        XCTAssertEqual(val, .character("A"))
    }
    
    func testMIDI() {
        // enum
        let source: OSCMessage.Value = .midi(
            OSCMessage.Value.MIDIMessage(
                portID: 0x80,
                status: 0x50,
                data1: 0x40,
                data2: 0x50
            )
        )
        
        // OSCMessage.Value(MIDIMessage)
        XCTAssertEqual(
            source,
            OSCMessage.Value(OSCMessage.Value.MIDIMessage(
                portID: 0x80,
                status: 0x50,
                data1: 0x40,
                data2: 0x50
            ))
        )
        
        // OSCMessage.Value(MIDIMessage) as .init() shorthand
        XCTAssertEqual(
            source,
            .midi(.init(
                portID: 0x80,
                status: 0x50,
                data1: 0x40,
                data2: 0x50
            ))
        )
        
        // OSCMessage.Value.midi(MIDIMessage) static func
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
        let val1 = OSCMessage.Value(true)
        XCTAssertEqual(val1, .bool(true))
        
        let val2 = OSCMessage.Value(false)
        XCTAssertEqual(val2, .bool(false))
    }
}

#endif
