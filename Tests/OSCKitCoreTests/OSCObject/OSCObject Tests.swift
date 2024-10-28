//
//  OSCObject Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import XCTest

final class OSCObject_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testAppearsToBeOSC() throws {
        let bundle = try OSCBundle([]).rawData()
        let msg    = try OSCMessage("/").rawData()
        
        // OSC bundle
        XCTAssert(bundle.oscObjectType == .bundle)
        XCTAssertFalse(bundle.oscObjectType == .message)
        
        // OSC message
        XCTAssert(msg.oscObjectType == .message)
        XCTAssertFalse(msg.oscObjectType == .bundle)
        
        // empty bytes
        XCTAssertNil(Data().oscObjectType)
        
        // garbage bytes
        XCTAssertNil(Data([0x98, 0x42, 0x01, 0x7E]).oscObjectType)
    }
}
