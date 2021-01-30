//
//  OSCBundle Tests.swift
//  OSCKitTests
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
import OSCKit

final class OSCBundleTests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	
	// MARK: - OSCBundle: Constructors
	
	func testOSCBundleConstructors() {
		
		// empty
		
		let emptyBundle = OSCBundle(elements: [])
		XCTAssertEqual(emptyBundle.timeTag, 1)
		XCTAssertEqual(emptyBundle.elements.count, 0)
		
		// timetag only
		
		let timeTagOnly = OSCBundle(elements: [],
									timeTag: 20)
		XCTAssertEqual(timeTagOnly.timeTag, 20)
		XCTAssertEqual(timeTagOnly.elements.count, 0)
		
		// elements only
		
		let elementsOnly = OSCBundle(elements: [OSCMessage(address: "/")])
		XCTAssertEqual(elementsOnly.timeTag, 1)
		XCTAssertEqual(elementsOnly.elements.count, 1)
		
		// timetag and elements
		
		let elementsAndTT = OSCBundle(elements: [OSCMessage(address: "/")],
									  timeTag: 20)
		XCTAssertEqual(elementsAndTT.timeTag, 20)
		XCTAssertEqual(elementsAndTT.elements.count, 1)
		
		// raw data
		
		let rawData = try! OSCBundle(from: OSCBundle.header + 20.int64.toData(.bigEndian))
		XCTAssertEqual(rawData.timeTag, 20)
		XCTAssertEqual(rawData.elements.count, 0)
		
	}
	
	
	// MARK: - OSCBundle: Contents
	
	func testOSCBundle_Empty() {
		
		// tests an empty OSC bundle
		
		// manually build a raw OSC bundle
		
		var knownGoodOSCRawBytes: [UInt8] = []
		
		// #bundle header
		knownGoodOSCRawBytes += [0x23, 0x62, 0x75, 0x6E, // "#bun"
								 0x64, 0x6C, 0x65, 0x00] // "dle" null
		// timetag
		knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
								 0x00, 0x00, 0x00, 0x01] // 1, int64 big-endian
		
		// decode
		
		let bundle = try! OSCBundle(from: knownGoodOSCRawBytes.data)
		
		XCTAssertEqual(bundle.timeTag, 1)
		XCTAssertEqual(bundle.elements.count, 0)
		
		// re-encode
		
		XCTAssertEqual(bundle.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	func testOSCBundle_OSCMessage() {
		
		// tests an OSC bundle, with one message containing an int32 value
		
		// manually build a raw OSC bundle
		
		var knownGoodOSCRawBytes: [UInt8] = []
		
		// #bundle header
		knownGoodOSCRawBytes += [0x23, 0x62, 0x75, 0x6E, // "#bun"
								 0x64, 0x6C, 0x65, 0x00] // "dle" null
		// timetag
		knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
								 0x00, 0x00, 0x00, 0x01] // 1, int64 big-endian
		// size of first bundle element
		knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x18] // 24, int32 big-endian
		
		// first bundle element: OSC Message
		
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
		
		let bundle = try! OSCBundle(from: knownGoodOSCRawBytes.data)
		
		XCTAssertEqual(bundle.timeTag, 1)
		XCTAssertEqual(bundle.elements.count, 1)
		
		guard let msg = bundle.elements.first as? OSCMessage else { XCTFail() ; return }
		XCTAssertEqual(msg.address, "/testaddress")
		XCTAssertEqual(msg.values.count, 1)
		guard case .int32(let val) = msg.values.first else { XCTFail() ; return }
		XCTAssertEqual(val, 255)
		
		// re-encode
		
		XCTAssertEqual(bundle.rawData, knownGoodOSCRawBytes.data)
		
	}
	
	
	// MARK: - OSCBundle: Complex messages
	
	func testOSCBundle_Complex() {
		
		// this does not necessarily prove that encoding or decoding actually matches OSC spec, it simply ensures that rawData that OSCBundle generates can be decoded
		
		// build bundle
		
		let oscBundle = OSCBundle(
			elements:
				[
					// element 1
					OSCBundle(elements: [OSCMessage(address: "/bundle1/msg")]),
					
					// element 2
					OSCBundle(elements: [
						OSCMessage(address: "/bundle2/msg1",
								   values: [.int32(500000),
											.string("some string here")]),
						OSCMessage(address: "/bundle2/msg2",
								   values: [.float32(8795.4556),
											.int32(75)])
					]),
					
					// element 3
					OSCMessage(address: "/msg1",
							   values: [.blob(Data([1,2,3]))]),
					
					// element 4
					OSCBundle(elements: [])
				]
		)
		
		// encode
		
		let encodedOSCbundle = oscBundle.rawData
		
		// decode
		
		let decodedOSCbundle = try! OSCBundle(from: encodedOSCbundle)
		
		// verify contents
		
		XCTAssertEqual(decodedOSCbundle.timeTag, 1)
		XCTAssertEqual(decodedOSCbundle.elements.count, 4)
		
		// element 1
		guard let element1 = decodedOSCbundle.elements[safe: 0] as? OSCBundle else { XCTFail() ; return }
		XCTAssertEqual(element1.timeTag, 1)
		XCTAssertEqual(element1.elements.count, 1)
		
		guard let element1A = element1.elements[safe: 0] as? OSCMessage else { XCTFail() ; return }
		XCTAssertEqual(element1A.address, "/bundle1/msg")
		XCTAssertEqual(element1A.values.count, 0)
		
		// element 2
		guard let element2 = decodedOSCbundle.elements[safe: 1] as? OSCBundle else { XCTFail() ; return }
		XCTAssertEqual(element2.timeTag, 1)
		XCTAssertEqual(element2.elements.count, 2)
		
		guard let element2A = element2.elements[safe: 0] as? OSCMessage else { XCTFail() ; return }
		XCTAssertEqual(element2A.address, "/bundle2/msg1")
		XCTAssertEqual(element2A.values.count, 2)
		guard case .int32(let element2A1) = element2A.values[safe: 0] else { XCTFail() ; return }
		XCTAssertEqual(element2A1, 500000)
		guard case .string(let element2A2) = element2A.values[safe: 1] else { XCTFail() ; return }
		XCTAssertEqual(element2A2, "some string here")
		
		guard let element2B = element2.elements[safe: 1] as? OSCMessage else { XCTFail() ; return }
		XCTAssertEqual(element2B.address, "/bundle2/msg2")
		XCTAssertEqual(element2B.values.count, 2)
		guard case .float32(let element2B1) = element2B.values[safe: 0] else { XCTFail() ; return }
		XCTAssertEqual(element2B1, 8795.4556)
		guard case .int32(let element2B2) = element2B.values[safe: 1] else { XCTFail() ; return }
		XCTAssertEqual(element2B2, 75)
		
		// element 3
		guard let element3 = decodedOSCbundle.elements[safe: 2] as? OSCMessage else { XCTFail() ; return }
		XCTAssertEqual(element3.values.count, 1)
		XCTAssertEqual(element3.address, "/msg1")
		
		// element 4
		guard let element4 = decodedOSCbundle.elements[safe: 3] as? OSCBundle else { XCTFail() ; return }
		XCTAssertEqual(element4.timeTag, 1)
		XCTAssertEqual(element4.elements.count, 0)
		
	}
	
	
	// MARK: - OSCMessage: Equatable, Hashable
	
	func testEquatable() {
		
		let msg1 = OSCMessage(address: "/msg1")
		let msg2 = OSCMessage(address: "/msg2")
		let msg3 = OSCMessage(address: "/msg1", values: [.int32(123)])
		
		let bundle1 = OSCBundle(elements: [msg1])
		let bundle2 = OSCBundle(elements: [msg3])
		let bundle3 = OSCBundle(elements: [bundle1, bundle2, msg2])
		
		XCTAssert(bundle1 == bundle1)
		XCTAssert(bundle2 == bundle2)
		XCTAssert(bundle3 == bundle3)
		
		XCTAssert(bundle1 != bundle2)
		XCTAssert(bundle1 != bundle3)
		
		XCTAssert(bundle2 != bundle3)
		
	}
	
	func testHashable() {
		
		let msg1 = OSCMessage(address: "/msg1")
		let msg2 = OSCMessage(address: "/msg2")
		let msg3 = OSCMessage(address: "/msg1", values: [.int32(123)])
		
		let bundle1 = OSCBundle(elements: [msg1])
		let bundle2 = OSCBundle(elements: [msg3])
		let bundle3 = OSCBundle(elements: [bundle1, bundle2, msg2])
		
		let set: Set<OSCBundle> = [bundle1, bundle1, bundle2, bundle2, bundle3, bundle3]
		
		XCTAssertTrue(set == [bundle1, bundle2, bundle3])
		
	}
	
	
	// MARK: - OSCBundle: CustomStringConvertible
	
	func testOSCBundleCustomStringConvertible1() {
		
		let bundle = OSCBundle(elements: [])
		
		let desc = bundle.description
		
		XCTAssertEqual(desc, "OSCBundle(timeTag: 1)")
		
	}
	
	func testOSCBundleCustomStringConvertible2() {
		
		let bundle = OSCBundle(elements: [
			OSCMessage(address: "/address",
					   values: [.int32(123),
								.string("A string")])
		])
		
		
		let desc = bundle.description
		
		XCTAssertEqual(desc, #"OSCBundle(timeTag: 1, elements: [OSCMessage(address: "/address", values: [int32:123, string:"A string"])])"#)
		
	}
	
	func testOSCBundleDescriptionPretty() {
		
		let bundle = OSCBundle(elements: [
			OSCMessage(address: "/address",
					   values: [.int32(123),
								.string("A string")])
		])
		
		let desc = bundle.descriptionPretty
		
		XCTAssertEqual(desc,
					#"""
					OSCBundle(timeTag: 1) Elements:
					  OSCMessage(address: "/address", values: [int32:123, string:"A string"])
					"""#)
		
	}
	
}

#endif
