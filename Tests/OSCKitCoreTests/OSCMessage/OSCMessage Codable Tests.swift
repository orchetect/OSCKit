//
//  OSCMessage Codable Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import SwiftRadix
import SwiftASCII

final class OSCMessage_Codable_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    fileprivate let encoder = JSONEncoder()
    fileprivate let decoder = JSONDecoder()
    
    func testAddressOnly() throws {
        let msg = OSCMessage(address: "/test/address")
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    // MARK: - Core Types
    
    func testInt32() throws {
        let msg = OSCMessage(address: "/test/address", values: [.int32(123)])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testFloat32() throws {
        let msg = OSCMessage(address: "/test/address", values: [.float32(123)])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testString() throws {
        let msg = OSCMessage(address: "/test/address", values: [.string("A string.")])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testBlob() throws {
        let msg = OSCMessage(address: "/test/address", values: [.blob(Data([0x01, 0x02]))])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    // MARK: - Extended Types
    
    func testInt64() throws {
        let msg = OSCMessage(address: "/test/address", values: [.int64(123)])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testTimeTag() throws {
        let msg = OSCMessage(address: "/test/address", values: [.timeTag(.init(123))])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testDouble() throws {
        let msg = OSCMessage(address: "/test/address", values: [.double(123.45)])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testStringAlt() throws {
        let msg = OSCMessage(address: "/test/address", values: [.stringAlt("A string.")])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testCharacter() throws {
        let msg = OSCMessage(address: "/test/address", values: [.character("A")])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testMIDIMessage() throws {
        let msg = OSCMessage(address: "/test/address", values: [
            .midi(portID: 0x01, status: 0xB0, data1: 0x01, data2: 0x60)
        ])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testBool() throws {
        let msg = OSCMessage(address: "/test/address", values: [.bool(true)])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    func testNull() throws {
        let msg = OSCMessage(address: "/test/address", values: [.null])
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
    
    // MARK: - Multiple values
    
    func testMultipleValues() throws {
        let msg = OSCMessage(
            address: "/test/address",
            values: [
                .int32(123),
                .string("A string."),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01, 0x02]))
            ]
        )
        
        let encoded = try encoder.encode(msg)
        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
        
        XCTAssertEqual(msg, decoded)
    }
}

#endif
