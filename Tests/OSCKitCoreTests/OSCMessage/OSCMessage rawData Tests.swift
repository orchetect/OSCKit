//
//  OSCMessage rawData Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCMessage_rawData_Tests {
    // swiftformat:options --wrapcollections preserve
    
    // MARK: - Core Types
    
    @Test
    func empty() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.isEmpty)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func int32() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? Int32)
        #expect(val == 255)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func float32() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? Float32)
        #expect(val == 123.45)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func string() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val: String = try #require(msg.values.first as? String)
        #expect(val == "This is an example string.")
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func blob() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? Data)
        #expect(val == Data([0x01, 0x02, 0x03]))
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    // MARK: - Extended Types
    
    @Test
    func int64() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? Int64)
        #expect(val == 255)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func timeTag() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? OSCTimeTag)
        #expect(val.rawValue == 255)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func double() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? Double)
        #expect(val == 123.45)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func stringAlt() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? OSCStringAltValue)
        #expect(val.string == "This is an example string.")
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func character() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? Character)
        #expect(val == "a" as Character)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func midi() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? OSCMIDIValue)
        #expect(val == OSCMIDIValue(portID: 0x01, status: 0x02, data1: 0x03, data2: 0x04))
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func bool() async throws {
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
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 2)
        #expect(msg.values[0] as? Bool == true)
        #expect(msg.values[1] as? Bool == false)
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func null() async throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x4E, 0x00, 0x00] // ",N" null null
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values.first as? OSCNullValue)
        #expect(val == OSCNullValue())
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func impulse() async throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x49, 0x00, 0x00] // ",I" null null
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values[0] as? OSCImpulseValue)
        #expect(val == OSCImpulseValue())
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
    
    @Test
    func array() async throws {
        // test an OSC message containing a single value
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x5B, 0x73, 0x69, // ",[si"
                                 0x5D, 0x00, 0x00, 0x00] // "]" null null null
        // string
        knownGoodOSCRawBytes += [0x61, 0x62, 0x63, 0x00] // "abc" null
        // int21
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // decode
        
        let msg = try OSCMessage(from: knownGoodOSCRawBytes.data)
        #expect(msg.addressPattern.stringValue == "/testaddress")
        #expect(msg.values.count == 1)
        let val = try #require(msg.values[0] as? OSCArrayValue)
        #expect(val == OSCArrayValue(["abc", 255]))
        
        // re-encode
        
        let newMsg = OSCMessage(msg.addressPattern.stringValue, values: msg.values)
        #expect(try newMsg.rawData() == knownGoodOSCRawBytes.data)
    }
}
