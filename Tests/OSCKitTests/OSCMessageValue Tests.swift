//
//  OSCMessageValue Tests.swift
//  OSCKitTests
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import OSCKit

class OSCMessageValueTests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	
	// MARK: - OSCMessageValue stringValue
	
	// MARK: -- Core types
	
	func testOSCMessageValueStringValue_int32() {
		
		let val = OSCMessageValue.int32(123)
		XCTAssertEqual(val.stringValue(),					      "123")
		XCTAssertEqual(val.stringValue(withLabel: true),	"int32:123")
		
	}
	
	func testOSCMessageValueStringValue_float32() {
		
		let val = OSCMessageValue.float32(123.45)
		XCTAssertEqual(val.stringValue(),					        "123.45")
		XCTAssertEqual(val.stringValue(withLabel: true),	"float32:123.45")
		
	}
	
	func testOSCMessageValueStringValue_string() {
		
		let val = OSCMessageValue.string("A string")
		XCTAssertEqual(val.stringValue(),					         "A string")		// no wrapping quotes
		XCTAssertEqual(val.stringValue(withLabel: true),	#"string:"A string""#)		// wrapping quotes
		
	}
	
	func testOSCMessageValueStringValue_blob() {
		
		let val04 = OSCMessageValue.blob(Data([1,2,3,4]))
		XCTAssertEqual(val04.stringValue(),					     "4 bytes")				// no wrapping quotes
		XCTAssertEqual(val04.stringValue(withLabel: true),	"blob:4 bytes")				// wrapping quotes
		
	}
	
	// MARK: -- Extended types
	
	func testOSCMessageValueStringValue_int64() {
		
		let val05 = OSCMessageValue.int64(123)
		XCTAssertEqual(val05.stringValue(),					      "123")
		XCTAssertEqual(val05.stringValue(withLabel: true),	"int64:123")
		
	}
	
	func testOSCMessageValueStringValue_timeTag() {
		
		let val06 = OSCMessageValue.timeTag(123)
		XCTAssertEqual(val06.stringValue(),					        "123")
		XCTAssertEqual(val06.stringValue(withLabel: true),	"timeTag:123")
		
	}
	
	func testOSCMessageValueStringValue_double() {
		
		let val07 = OSCMessageValue.double(123.45)
		XCTAssertEqual(val07.stringValue(),					       "123.45")
		XCTAssertEqual(val07.stringValue(withLabel: true),	"double:123.45")
		
	}
	
	func testOSCMessageValueStringValue_stringAlt() {
		
		let val = OSCMessageValue.stringAlt("A string")
		XCTAssertEqual(val.stringValue(),					            "A string")		// no wrapping quotes
		XCTAssertEqual(val.stringValue(withLabel: true),	#"stringAlt:"A string""#)	// wrapping quotes
		
	}
	
	func testOSCMessageValueStringValue_character() {
		
		let val = OSCMessageValue.character("A")
		XCTAssertEqual(val.stringValue(),					"A")
		XCTAssertEqual(val.stringValue(withLabel: true),	"char:A")
		
	}
	
	func testOSCMessageValueStringValue_midi() {
		
		let val = OSCMessageValue.midi(OSCMIDIMessage(portID: 0x80, status: 0x50, data1: 0x40, data2: 0x50))
		XCTAssertEqual(val.stringValue(),					     "portID:80 status:50 data1:40 data2:50")
		XCTAssertEqual(val.stringValue(withLabel: true),	"midi:portID:80 status:50 data1:40 data2:50")
		
	}
	
	func testOSCMessageValueStringValue_bool() {
		
		let val1 = OSCMessageValue.bool(true)
		XCTAssertEqual(val1.stringValue(),					     "true")
		XCTAssertEqual(val1.stringValue(withLabel: true),	"bool:true")
		
		let val2 = OSCMessageValue.bool(false)
		XCTAssertEqual(val2.stringValue(),					     "false")
		XCTAssertEqual(val2.stringValue(withLabel: true),	"bool:false")
		
	}
	
	func testOSCMessageValueStringValue_null() {
		
		let val = OSCMessageValue.null
		XCTAssertEqual(val.stringValue(),					"Null")
		XCTAssertEqual(val.stringValue(withLabel: true),	"Null")
		
	}
	
	
	
	
	
	// MARK: - Utility functions
	
	func testNumberAsInt() {
		
		// core types
		XCTAssertEqual(OSCMessageValue.NumberAsInt(123 as Int),		123)
		XCTAssertEqual(OSCMessageValue.NumberAsInt(123 as Int32),	123)
		XCTAssertEqual(OSCMessageValue.NumberAsInt(123 as Float32),	123)
		
		// extended types
		XCTAssertEqual(OSCMessageValue.NumberAsInt(123 as Int64),	123)
		XCTAssertEqual(OSCMessageValue.NumberAsInt(123 as Double),	123)
		
		// unsuccessful
		XCTAssertNil(  OSCMessageValue.NumberAsInt(123.45 as Float32))
		
		// invalid
		XCTAssertNil(  OSCMessageValue.NumberAsInt("a string"))
		
	}
	
	func testNumberAsDouble() {
		
		// core types
		XCTAssertEqual(OSCMessageValue.NumberAsDouble(123 as Int),		123.0)
		XCTAssertEqual(OSCMessageValue.NumberAsDouble(123 as Int32),	123.0)
		XCTAssertEqual(OSCMessageValue.NumberAsDouble(123 as Float32),	123.0)
		
		// extended types
		XCTAssertEqual(OSCMessageValue.NumberAsDouble(123 as Int64),	123.0)
		XCTAssertEqual(OSCMessageValue.NumberAsDouble(123 as Double),	123.0)
		
		// unsuccessful
		XCTAssertNil(  OSCMessageValue.NumberAsDouble(Int.max as Int))
		
		// invalid
		XCTAssertNil(  OSCMessageValue.NumberAsDouble("a string"))
		
	}
	
}
