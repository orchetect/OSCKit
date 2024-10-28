//
//  OSCObject Static Constructors Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import SwiftASCII
import XCTest

final class OSCObject_StaticConstructors_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - OSCMessage
    
    func testOSCMessage_AddressPatternString() throws {
        let addr = String("/msg1")
        let obj: any OSCObject = .message(
            addr,
            values: [Int32(123)]
        )
        
        let msg = try XCTUnwrap(obj as? OSCMessage)
        
        XCTAssertEqual(msg.addressPattern.stringValue, "/msg1")
        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
    }
    
    func testOSCMessage_AddressPattern() throws {
        let obj: any OSCObject = .message(
            OSCAddressPattern("/msg1"),
            values: [Int32(123)]
        )
        
        let msg = try XCTUnwrap(obj as? OSCMessage)
        
        XCTAssertEqual(msg.addressPattern.stringValue, "/msg1")
        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
    }
    
    // MARK: - OSCBundle
    
    func testOSCBundle() throws {
        let obj: any OSCObject = .bundle([
            .message("/", values: [Int32(123)])
        ])
        
        let bundle = try XCTUnwrap(obj as? OSCBundle)
        
        XCTAssertEqual(bundle.elements.count, 1)
        
        let msg = try XCTUnwrap(bundle.elements[0] as? OSCMessage)
        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
    }
}
