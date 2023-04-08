//
//  OSCMessage rawData Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore
import SwiftASCII

final class OSCMessage_rawData_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Core Types
    
    func testEmpty() throws {
        // test an OSC message containing no values
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x00, 0x00, 0x00] // "," null null null
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 0)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testInt32() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x69, 0x00, 0x00] // ",i" null null
        // int32
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? Int32)
        XCTAssertEqual(val, 255)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testFloat32() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x66, 0x00, 0x00] // ",f" null null
        // float32
        knownGoodOSCRawBytes += [0x42, 0xF6, 0xE6, 0x66] // 123.45, big-endian
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? Float32)
        XCTAssertEqual(val, 123.45)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testString() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x73, 0x00, 0x00] // ",s" null null
        // string
        knownGoodOSCRawBytes += [0x54, 0x68, 0x69, 0x73,
                                 0x20, 0x69, 0x73, 0x20,
                                 0x61, 0x6E, 0x20, 0x65,
                                 0x78, 0x61, 0x6D, 0x70,
                                 0x6C, 0x65, 0x20, 0x73,
                                 0x74, 0x72, 0x69, 0x6E,
                                 0x67, 0x2E, 0x00, 0x00] // "This is an example string." null null
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? String)
        XCTAssertEqual(val, "This is an example string.")
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testBlob() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x62, 0x00, 0x00] // ",b" null null
        // length of blob
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x03] // 3, int32 big-endian
        // blob
        knownGoodOSCRawBytes += [0x01, 0x02, 0x03, 0x00] // "This is an example string." null null
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? Data)
        XCTAssertEqual(val, Data([0x01, 0x02, 0x03]))
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    // MARK: - Extended Types
    
    func testInt64() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x68, 0x00, 0x00] // ",h" null null
        // int64
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? Int64)
        XCTAssertEqual(val, 255)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testTimeTag() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x74, 0x00, 0x00] // ",t" null null
        // timetag (int64 big-endian)
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? OSCTimeTag)
        XCTAssertEqual(val.rawValue, 255)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testDouble() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x64, 0x00, 0x00] // ",d" null null
        // double / float64     205 204 204 204 204 220 94 64
        knownGoodOSCRawBytes += [0x40, 0x5E, 0xDC, 0xCC,
                                 0xCC, 0xCC, 0xCC, 0xCD] // 123.45, big-endian
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? Double)
        XCTAssertEqual(val, 123.45)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testStringAlt() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x53, 0x00, 0x00] // ",S" null null
        // string
        knownGoodOSCRawBytes += [0x54, 0x68, 0x69, 0x73,
                                 0x20, 0x69, 0x73, 0x20,
                                 0x61, 0x6E, 0x20, 0x65,
                                 0x78, 0x61, 0x6D, 0x70,
                                 0x6C, 0x65, 0x20, 0x73,
                                 0x74, 0x72, 0x69, 0x6E,
                                 0x67, 0x2E, 0x00, 0x00] // "This is an example string." null null
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? OSCStringAltValue)
        XCTAssertEqual(val.string, "This is an example string.")
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testCharacter() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x63, 0x00, 0x00] // ",c" null null
        // ascii char number as int32
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x61] // "a" as ascii char 97, int32 big-endian
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? Character)
        XCTAssertEqual(val, "a" as Character)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testMIDI() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x6D, 0x00, 0x00] // ",m" null null
        // 4 midi bytes: portID, status, data1, data2
        knownGoodOSCRawBytes += [0x01, 0x02, 0x03, 0x04] // 4 midi bytes
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? OSCMIDIValue)
        XCTAssertEqual(val, OSCMIDIValue(portID: 0x01, status: 0x02, data1: 0x03, data2: 0x04))
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testBool() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x54, 0x46, 0x00] // ",TF" null
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 2)
        let val1 = try XCTUnwrap(msg.values[0] as? Bool)
        XCTAssertEqual(val1, true)
        let val2 = try XCTUnwrap(msg.values[1] as? Bool)
        XCTAssertEqual(val2, false)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
    
    func testNull() throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x4E, 0x00, 0x00] // ",TF" null
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        let val = try XCTUnwrap(msg.values.first as? OSCNullValue)
        XCTAssertEqual(val, OSCNullValue())
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        XCTAssertEqual(try newMsg.rawData(), knownGoodOSCRawBytes.data)
    }
}

#endif
