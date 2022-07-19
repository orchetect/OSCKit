//
//  OSCMessageValue init Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit

final class OSCMessageValue_init_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Core types
    
    func testInt32() {
        
        let val = OSCMessageValue(Int32(123))
        XCTAssertEqual(val, .int32(123))
        
    }
    
    func testFloat32() {
        
        let val = OSCMessageValue(Float32(123.45))
        XCTAssertEqual(val, .float32(123.45))
        
    }
    
    func testString() {
        
        let val1 = OSCMessageValue("A string")
        XCTAssertEqual(val1, .string("A string"))
        
        // a single character string (grapheme cluster) could possibly be confused with an ASCIICharacter literal
        // this is avoided by giving the OSCMessageValue init for .character an explicit label of OSCMessageValue(character:)
        
        let val2 = OSCMessageValue("A")
        XCTAssertEqual(val2, .string("A"))
        
    }
    
    func testBlob() {
        
        let val = OSCMessageValue(Data([1,2,3,4]))
        XCTAssertEqual(val, .blob(Data([1,2,3,4])))
        
    }
    
    // MARK: - Extended types
    
    func testInt64() {
        
        let val = OSCMessageValue(Int64(123))
        XCTAssertEqual(val, .int64(123))
        
    }
    
    func testTimeTag() {
        
        let val = OSCMessageValue(timeTag: 123)
        XCTAssertEqual(val, .timeTag(123))
        
    }
    
    func testDouble() {
        
        let val = OSCMessageValue(123.45)
        XCTAssertEqual(val, .double(123.45))
        
    }
    
    func testStringAlt() {
        
        let val1 = OSCMessageValue(stringAlt: "A string")
        XCTAssertEqual(val1, .stringAlt("A string"))
        
        // a single character string (grapheme cluster) could possibly be confused with an ASCIICharacter literal
        // this is avoided by giving the OSCMessageValue init for .character an explicit label of OSCMessageValue(character:)
        
        let val2 = OSCMessageValue(stringAlt: "A")
        XCTAssertEqual(val2, .stringAlt("A"))
        
    }
    
    func testCharacter() {
        
        let val = OSCMessageValue(character: "A")
        XCTAssertEqual(val, .character("A"))
        
    }
    
    func testMIDI() {
        
        // enum
        let source: OSCMessageValue = .midi(
            OSCMessageValue.MIDIMessage(portID: 0x80,
                                        status: 0x50,
                                        data1: 0x40,
                                        data2: 0x50)
        )
        
        // OSCMessageValue(MIDIMessage)
        XCTAssertEqual(
            source,
            OSCMessageValue(OSCMessageValue.MIDIMessage(portID: 0x80,
                                                        status: 0x50,
                                                        data1: 0x40,
                                                        data2: 0x50))
            
        )
        
        // OSCMessageValue(MIDIMessage) as .init() shorthand
        XCTAssertEqual(
            source,
            .midi(.init(portID: 0x80,
                        status: 0x50,
                        data1: 0x40,
                        data2: 0x50))
        )
        
        // OSCMessageValue.midi(MIDIMessage) static func
        XCTAssertEqual(
            source,
            .midi(portID: 0x80,
                  status: 0x50,
                  data1: 0x40,
                  data2: 0x50)
        )
        
    }
    
    func testBool() {
        
        let val1 = OSCMessageValue(true)
        XCTAssertEqual(val1, .bool(true))
        
        let val2 = OSCMessageValue(false)
        XCTAssertEqual(val2, .bool(false))
        
    }
    
}

#endif
