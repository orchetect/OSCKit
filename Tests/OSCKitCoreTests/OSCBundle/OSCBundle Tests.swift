//
//  OSCBundle Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCBundle_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Equatable
    
    func testEquatable() {
        let msg1 = OSCMessage(address: "/msg1")
        let msg2 = OSCMessage(address: "/msg2")
        let msg3 = OSCMessage(address: "/msg1", values: [.int32(123)])
        
        let bundle1 = OSCBundle(elements: [.message(msg1)])
        let bundle2 = OSCBundle(elements: [.message(msg3)])
        let bundle3 = OSCBundle(elements: [
            .bundle(bundle1),
            .bundle(bundle2),
            .message(msg2)
        ])
        
        XCTAssert(bundle1 == bundle1)
        XCTAssert(bundle2 == bundle2)
        XCTAssert(bundle3 == bundle3)
        
        XCTAssert(bundle1 != bundle2)
        XCTAssert(bundle1 != bundle3)
        
        XCTAssert(bundle2 != bundle3)
    }
    
    // MARK: - Hashable
    
    func testHashable() {
        let msg1 = OSCMessage(address: "/msg1")
        let msg2 = OSCMessage(address: "/msg2")
        let msg3 = OSCMessage(address: "/msg1", values: [.int32(123)])
        
        let bundle1 = OSCBundle(elements: [.message(msg1)])
        let bundle2 = OSCBundle(elements: [.message(msg3)])
        let bundle3 = OSCBundle(elements: [
            .bundle(bundle1),
            .bundle(bundle2),
            .message(msg2)
        ])
        
        let set: Set<OSCBundle> = [bundle1, bundle1, bundle2, bundle2, bundle3, bundle3]
        
        XCTAssertTrue(set == [bundle1, bundle2, bundle3])
    }
    
    // MARK: - CustomStringConvertible
    
    func testCustomStringConvertible1() {
        let bundle = OSCBundle(elements: [])
        
        let desc = bundle.description
        
        XCTAssertEqual(desc, "OSCBundle(timeTag: 1)")
    }
    
    func testCustomStringConvertible2() {
        let bundle = OSCBundle(elements: [
            .message(
                address: "/address",
                values: [
                    .int32(123),
                    .string("A string")
                ]
            )
        ])
        
        let desc = bundle.description
        
        XCTAssertEqual(
            desc,
            #"OSCBundle(timeTag: 1, elements: [OSCMessage(address: "/address", values: [int32:123, string:"A string"])])"#
        )
    }
    
    func testDescriptionPretty() {
        let bundle = OSCBundle(elements: [
            .message(
                address: "/address",
                values: [
                    .int32(123),
                    .string("A string")
                ]
            )
        ])
        
        let desc = bundle.descriptionPretty
        
        XCTAssertEqual(
            desc,
            #"""
            OSCBundle(timeTag: 1) Elements:
              OSCMessage(address: "/address", values: [int32:123, string:"A string"])
            """#
        )
    }
    
    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let str = OSCBundle(elements: [
            .bundle(elements: [
                .message(
                    address: "/test/address1",
                    values: [.int32(123), .string("A string.")]
                )
            ]),
            
            .message(
                address: "/test/address2",
                values: [.int32(456), .string("Another string.")]
            )
        ], timeTag: 123_456)
        
        let encoded = try encoder.encode(str)
        let decoded = try decoder.decode(OSCBundle.self, from: encoded)
        
        XCTAssertEqual(str, decoded)
    }
}

#endif
