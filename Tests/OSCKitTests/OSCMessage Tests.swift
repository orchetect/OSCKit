//
//  OSCMessage Tests.swift
//  OSCKitTests
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
import OSCKit
import SwiftRadix
import SwiftASCII

final class OSCMessageTests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	
	// MARK: - OSCMessage: Constructors
	
	func testOSCMessageConstructors() {
		
		// this does not necessarily prove that encoding or decoding actually matches OSC spec, it simply ensures that a message that OSCMessage generates can also be decoded
		
		// empty
		
		_ = OSCMessage(address: "/")
		
		// encode
		
		let msg = OSCMessage(
			address: "/test",
			values: [
				.int32(123),
				.float32(123.45),
				.string("A test string."),
				.blob(Data([0,1,2]))
			])
			.rawData
		
		// decode
		
		let decoded = try! OSCMessage(from: msg)
		
		// just for debug log analysis, if needed
		
		print("Address:", decoded.address)
		print("Values:", decoded.values.mapDebugString())
		
		print("All values decoded:")
		decoded.values.forEach { val in
			switch val {
			case .blob(let data): print("data:", data.hex.stringValueArrayLiteral)
			default: print(val)
			}
		}
		
		// check values
		
		XCTAssertEqual(decoded.values.count, 4)
		
		guard case .int32(let val1) = decoded.values[safe: 0] else { XCTFail() ; return }
		XCTAssertEqual(val1, 123)
		
		guard case .float32(let val2) = decoded.values[safe: 1] else { XCTFail() ; return }
		XCTAssertEqual(val2, 123.45)
		
		guard case .string(let val3) = decoded.values[safe: 2] else { XCTFail() ; return }
		XCTAssertEqual(val3, "A test string.")
		
		guard case .blob(let val4) = decoded.values[safe: 3] else { XCTFail() ; return }
		XCTAssertEqual(val4, Data([0,1,2]))
		
	}
	
	
	// MARK: - OSCMessage: Core Types
	
	func testOSCMessage_empty() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 0)
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_int32() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .int32(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, 255)
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_float32() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .float32(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, 123.45)
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_string() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .string(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, "This is an example string.")
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_blob() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .blob(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, Data([0x01, 0x02, 0x03]))
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	
	// MARK: - OSCMessage: Extended Types
	
	
	func testOSCMessage_int64() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .int64(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, 255)
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_timeTag() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .timeTag(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, 255)
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_double() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .double(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, 123.45)
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_stringAlt() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .stringAlt(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, "This is an example string.")
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_character() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .character(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, "a" as ASCIICharacter)
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_midi() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .midi(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, OSCMIDIMessage(portID: 0x01, status: 0x02, data1: 0x03, data2: 0x04))
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_bool() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 2)
		guard case .bool(let val1) = msg.values[safe: 0] else { XCTFail() ; return }
		XCTAssertEqual(val1, true)
		guard case .bool(let val2) = msg.values[safe: 1] else { XCTFail() ; return }
		XCTAssertEqual(val2, false)
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCMessage_null() {
		
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
		
		let msg = try! OSCMessage(from: knownGoodOSCRawBytes.data)
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .null = msg.values[safe: 0] else { XCTFail() ; return }
		
		// re-encode
		
		XCTAssertEqual(msg.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	
	// MARK: - OSCMessage: CustomStringConvertible
	
	func testOSCMessageCustomStringConvertible1() {
		
		let msg = OSCMessage(address: "/")
		
		let desc = msg.description
		
		XCTAssertEqual(desc, "OSCMessage(address: \"/\")")
		
	}
	
	func testOSCMessageCustomStringConvertible2() {
		
		let msg = OSCMessage(address: "/address",
							 values: [.int32(123), .string("A string")])
		
		let desc = msg.description
		
		XCTAssertEqual(desc, #"OSCMessage(address: "/address", values: [int32:123, string:"A string"])"#)
		
	}
	
	func testOSCMessageDescriptionPretty() {
		
		let msg = OSCMessage(address: "/address",
							 values: [.int32(123), .string("A string")])
		
		let desc = msg.descriptionPretty
		
		XCTAssertEqual(desc,
					#"""
					OSCMessage(address: "/address") Values:
					  int32:123
					  string:"A string"
					"""#)
		
	}
	
}

#endif
