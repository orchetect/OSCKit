//
//  OSCObject Tests.swift
//  OSCKitTests
//
//  Created by Steffan Andrews on 2017-04-09.
//  Copyright © 2017 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OSCKit

class OSCObjectTests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	
	// MARK: - OSCObject
	
	func testOSCObject() {
		
		let bundle = OSCBundle().rawData!
		let msg    = OSCMessage().rawData!
		
		// OSC bundle
		XCTAssert(     bundle.appearsToBeOSCObject == .bundle)
		XCTAssertFalse(bundle.appearsToBeOSCObject == .message)
		
		// OSC message
		XCTAssert(     msg   .appearsToBeOSCObject == .message)
		XCTAssertFalse(msg   .appearsToBeOSCObject == .bundle)
		
		// empty bytes
		XCTAssertNil(  Data().appearsToBeOSCObject)
		
		// garbage bytes
		XCTAssertNil(  Data([0x98, 0x42, 0x01, 0x7E]).appearsToBeOSCObject)
		
	}
	
}

#endif
