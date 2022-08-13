//
//  OSCObject Static Constructors Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import SwiftRadix
import SwiftASCII

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
    
    func testOSCMessage_AddressPatternString_VariadicValues_SingleValue() throws {
        let addr = String("/msg1")
        let obj: any OSCObject = .message(
            addr,
            values: Int32(123)
        )
        
        let msg = try XCTUnwrap(obj as? OSCMessage)
        
        XCTAssertEqual(msg.addressPattern.stringValue, "/msg1")
        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
    }
    
    func testOSCMessage_AddressPattern_VariadicValues_MultipleValues() throws {
        let obj: any OSCObject = .message(
            OSCAddressPattern("/msg1"),
            values: Int32(123), String("A string"), Float32(123.45)
        )
        
        let msg = try XCTUnwrap(obj as? OSCMessage)
        
        XCTAssertEqual(msg.addressPattern.stringValue, "/msg1")
        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
        XCTAssertEqual(msg.values[1] as? String, "A string")
        XCTAssertEqual(msg.values[2] as? Float32, Float32(123.45))
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
    
    func testOSCBundle_VariadicElements() throws {
        let obj: any OSCObject = .bundle(
            .message("/", values: Int32(123))
        )
        
        let bundle = try XCTUnwrap(obj as? OSCBundle)
        
        XCTAssertEqual(bundle.elements.count, 1)
        
        let msg = try XCTUnwrap(bundle.elements[0] as? OSCMessage)
        XCTAssertEqual(msg.values[0] as? Int32, Int32(123))
    }
}

#endif
