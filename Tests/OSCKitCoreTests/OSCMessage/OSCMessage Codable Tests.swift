//
//  OSCMessage Codable Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import XCTest

final class OSCMessage_Codable_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    fileprivate let encoder = JSONEncoder()
    fileprivate let decoder = JSONDecoder()
    
    // TODO: uncomment these tests once `OSCMessage.Codable` conformance is fixed
    // TODO: these need reordering and new types added (ie: OSCImpulseValue)
    
//    func testAddressOnly() throws {
//        let msg = OSCMessage(address: "/test/address")
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    // MARK: - Core Types
//
//    func testInt32() throws {
//        let msg = OSCMessage(address: "/test/address", values: [Int32(123)])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testFloat32() throws {
//        let msg = OSCMessage(address: "/test/address", values: [Float32(123)])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testString() throws {
//        let msg = OSCMessage(address: "/test/address", values: [String("A string.")])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testBlob() throws {
//        let msg = OSCMessage(address: "/test/address", values: [Data([0x01, 0x02])])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    // MARK: - Extended Types
//
//    func testInt64() throws {
//        let msg = OSCMessage(address: "/test/address", values: [Int64(123)])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testTimeTag() throws {
//        let msg = OSCMessage(address: "/test/address", values: [OSCTimeTag(.init(123))])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testDouble() throws {
//        let msg = OSCMessage(address: "/test/address", values: [Double(123.45)])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testStringAlt() throws {
//        let msg = OSCMessage(address: "/test/address", values: [OSCStringAltValue("A string.")])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testCharacter() throws {
//        let msg = OSCMessage(address: "/test/address", values: [Character("A")])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testMIDIMessage() throws {
//        let msg = OSCMessage(address: "/test/address", values: [
//            OSCMIDIValue(portID: 0x01, status: 0xB0, data1: 0x01, data2: 0x60)
//        ])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testBool() throws {
//        let msg = OSCMessage(address: "/test/address", values: [true])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    func testNull() throws {
//        let msg = OSCMessage(address: "/test/address", values: [OSCNullValue()])
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
//
//    // MARK: - Multiple values
//
//    func testMultipleValues() throws {
//        let msg = OSCMessage(
//            address: "/test/address",
//            values: [
//                Int32(123),
//                String("A string."),
//                Bool(true),
//                Float32(123.45),
//                Data([0x01, 0x02])
//            ]
//        )
//
//        let encoded = try encoder.encode(msg)
//        let decoded = try decoder.decode(OSCMessage.self, from: encoded)
//
//        XCTAssertEqual(msg, decoded)
//    }
}
