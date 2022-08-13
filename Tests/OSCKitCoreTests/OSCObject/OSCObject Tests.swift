//
//  OSCObject Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCObject_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testAppearsToBeOSC() throws {
        let bundle = try OSCBundle([]).rawData()
        let msg    = try OSCMessage("/").rawData()
        
        // OSC bundle
        XCTAssert(bundle.appearsToBeOSC == .bundle)
        XCTAssertFalse(bundle.appearsToBeOSC == .message)
        
        // OSC message
        XCTAssert(msg.appearsToBeOSC == .message)
        XCTAssertFalse(msg.appearsToBeOSC == .bundle)
        
        // empty bytes
        XCTAssertNil(Data().appearsToBeOSC)
        
        // garbage bytes
        XCTAssertNil(Data([0x98, 0x42, 0x01, 0x7E]).appearsToBeOSC)
    }
}

#endif
