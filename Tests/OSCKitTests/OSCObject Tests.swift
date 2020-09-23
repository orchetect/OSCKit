//
//  OSCObject Tests.swift
//  OSCKitTests
//
//  Created by Steffan Andrews on 2017-04-09.
//  Copyright © 2017 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import OSCKit

class OSCObjectTests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	
	// MARK: - OSCObject
	
	func testOSCObject() {
		
		let bundle = OSCBundle().rawData!
		let msg    = OSCMessage().rawData!
		
		XCTAssert(     bundle.appearsToBeOSCObject is OSCBundle.Type)
		XCTAssertFalse(bundle.appearsToBeOSCObject is OSCMessage.Type)
		
		XCTAssert(     msg   .appearsToBeOSCObject is OSCMessage.Type)
		XCTAssertFalse(msg   .appearsToBeOSCObject is OSCBundle.Type)
		
		XCTAssertNil(  Data().appearsToBeOSCObject)
		
	}
	
}
