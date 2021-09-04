//
//  OSCMessageValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if !os(watchOS)

import XCTest
import OSCKit

final class OSCMessageValueTests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    
    // MARK: - OSCMessageValue stringValue
    
    // MARK: -- Core types
    
    func testOSCMessageValueStringValue_int32() {
        
        let val = OSCMessageValue.int32(123)
        XCTAssertEqual(val.stringValue(),                         "123")
        XCTAssertEqual(val.stringValue(withLabel: true),    "int32:123")
        
    }
    
    func testOSCMessageValueStringValue_float32() {
        
        let val = OSCMessageValue.float32(123.45)
        XCTAssertEqual(val.stringValue(),                           "123.45")
        XCTAssertEqual(val.stringValue(withLabel: true),    "float32:123.45")
        
    }
    
    func testOSCMessageValueStringValue_string() {
        
        let val = OSCMessageValue.string("A string")
        XCTAssertEqual(val.stringValue(),                            "A string")   // no wrapping quotes
        XCTAssertEqual(val.stringValue(withLabel: true),    #"string:"A string""#) // wrapping quotes
        
    }
    
    func testOSCMessageValueStringValue_blob() {
        
        let val04 = OSCMessageValue.blob(Data([1,2,3,4]))
        XCTAssertEqual(val04.stringValue(),                      "4 bytes")        // no wrapping quotes
        XCTAssertEqual(val04.stringValue(withLabel: true),  "blob:4 bytes")        // wrapping quotes
        
    }
    
    // MARK: -- Extended types
    
    func testOSCMessageValueStringValue_int64() {
        
        let val = OSCMessageValue.int64(123)
        XCTAssertEqual(val.stringValue(),                         "123")
        XCTAssertEqual(val.stringValue(withLabel: true),    "int64:123")
        
    }
    
    func testOSCMessageValueStringValue_timeTag() {
        
        let val = OSCMessageValue.timeTag(123)
        XCTAssertEqual(val.stringValue(),                           "123")
        XCTAssertEqual(val.stringValue(withLabel: true),    "timeTag:123")
        
    }
    
    func testOSCMessageValueStringValue_double() {
        
        let val = OSCMessageValue.double(123.45)
        XCTAssertEqual(val.stringValue(),                          "123.45")
        XCTAssertEqual(val.stringValue(withLabel: true),    "double:123.45")
        
    }
    
    func testOSCMessageValueStringValue_stringAlt() {
        
        let val = OSCMessageValue.stringAlt("A string")
        XCTAssertEqual(val.stringValue(),                               "A string")     // no wrapping quotes
        XCTAssertEqual(val.stringValue(withLabel: true),    #"stringAlt:"A string""#)   // wrapping quotes
        
    }
    
    func testOSCMessageValueStringValue_character() {
        
        let val = OSCMessageValue.character("A")
        XCTAssertEqual(val.stringValue(),                   "A")
        XCTAssertEqual(val.stringValue(withLabel: true),    "char:A")
        
    }
    
    func testOSCMessageValueStringValue_midi() {
        
        let val = OSCMessageValue.midi(portID: 0x80, status: 0x50, data1: 0x40, data2: 0x50)
        XCTAssertEqual(val.stringValue(),                        "portID:80 status:50 data1:40 data2:50")
        XCTAssertEqual(val.stringValue(withLabel: true),    "midi:portID:80 status:50 data1:40 data2:50")
        
    }
    
    func testOSCMessageValueStringValue_bool() {
        
        let val1 = OSCMessageValue.bool(true)
        XCTAssertEqual(val1.stringValue(),                       "true")
        XCTAssertEqual(val1.stringValue(withLabel: true),   "bool:true")
        
        let val2 = OSCMessageValue.bool(false)
        XCTAssertEqual(val2.stringValue(),                       "false")
        XCTAssertEqual(val2.stringValue(withLabel: true),   "bool:false")
        
    }
    
    func testOSCMessageValueStringValue_null() {
        
        let val = OSCMessageValue.null
        XCTAssertEqual(val.stringValue(),                   "Null")
        XCTAssertEqual(val.stringValue(withLabel: true),    "Null")
        
    }
    
    
    // MARK: - Initializers
    
    func testOSCMessageValueInit_int32() {
        
        let val = OSCMessageValue(Int32(123))
        XCTAssertEqual(val, .int32(123))
        
    }
    
    func testOSCMessageValueInit_float32() {
        
        let val = OSCMessageValue(Float32(123.45))
        XCTAssertEqual(val, .float32(123.45))
        
    }
    
    func testOSCMessageValueInit_string() {
        
        let val1 = OSCMessageValue("A string")
        XCTAssertEqual(val1, .string("A string"))
        
        // a single character string (grapheme cluster) could possibly be confused with an ASCIICharacter literal
        // this is avoided by giving the OSCMessageValue init for .character an explicit label of OSCMessageValue(character:)
        
        let val2 = OSCMessageValue("A")
        XCTAssertEqual(val2, .string("A"))
        
    }
    
    func testOSCMessageValueInit_blob() {
        
        let val = OSCMessageValue(Data([1,2,3,4]))
        XCTAssertEqual(val, .blob(Data([1,2,3,4])))
        
    }
    
    // MARK: -- Extended types
    
    func testOSCMessageValueInit_int64() {
        
        let val = OSCMessageValue(Int64(123))
        XCTAssertEqual(val, .int64(123))
        
    }
    
    func testOSCMessageValueInit_timeTag() {
        
        let val = OSCMessageValue(timeTag: 123)
        XCTAssertEqual(val, .timeTag(123))
        
    }
    
    func testOSCMessageValueInit_double() {
        
        let val = OSCMessageValue(123.45)
        XCTAssertEqual(val, .double(123.45))
        
    }
    
    func testOSCMessageValueInit_stringAlt() {
        
        let val1 = OSCMessageValue(stringAlt: "A string")
        XCTAssertEqual(val1, .stringAlt("A string"))
        
        // a single character string (grapheme cluster) could possibly be confused with an ASCIICharacter literal
        // this is avoided by giving the OSCMessageValue init for .character an explicit label of OSCMessageValue(character:)
        
        let val2 = OSCMessageValue(stringAlt: "A")
        XCTAssertEqual(val2, .stringAlt("A"))
        
    }
    
    func testOSCMessageValueInit_character() {
        
        let val = OSCMessageValue(character: "A")
        XCTAssertEqual(val, .character("A"))
        
    }
    
    func testOSCMessageValueInit_midi() {
        
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
    
    func testOSCMessageValueInit_bool() {
        
        let val1 = OSCMessageValue(true)
        XCTAssertEqual(val1, .bool(true))
        
        let val2 = OSCMessageValue(false)
        XCTAssertEqual(val2, .bool(false))
        
    }
    
    
    // MARK: - Utility functions
    
    func testNumberAsInt() {
        
        // core types
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Int),     123)
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Int32),   123)
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Float32), 123)
        
        // extended types
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Int64),   123)
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Double),  123)
        
        // unsuccessful
        XCTAssertNil(  OSCMessageValue.numberAsInt(123.45 as Float32))
        
        // invalid
        XCTAssertNil(  OSCMessageValue.numberAsInt("a string"))
        
    }
    
    func testNumberAsDouble() {
        
        // core types
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Int),      123.0)
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Int32),    123.0)
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Float32),  123.0)
        
        // extended types
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Int64),    123.0)
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Double),   123.0)
        
        // unsuccessful
        XCTAssertNil(  OSCMessageValue.numberAsDouble(Int.max as Int))
        
        // invalid
        XCTAssertNil(  OSCMessageValue.numberAsDouble("a string"))
        
    }
    
}

#endif
