//
//  OSCBundle Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCBundle_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Equatable
    
    func testEquatable() {
        let msg1 = OSCMessage("/msg1")
        let msg2 = OSCMessage("/msg2")
        let msg3 = OSCMessage("/msg1", values: [Int32(123)])
        
        let bundle1 = OSCBundle([msg1])
        let bundle2 = OSCBundle([msg3])
        let bundle3 = OSCBundle([
            bundle1,
            bundle2,
            msg2
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
        let msg1 = OSCMessage("/msg1")
        let msg2 = OSCMessage("/msg2")
        let msg3 = OSCMessage("/msg1", values: [Int32(123)])
        
        let bundle1 = OSCBundle([msg1])
        let bundle2 = OSCBundle([msg3])
        let bundle3 = OSCBundle([
            bundle1,
            bundle2,
            msg2
        ])
        
        let set: Set<OSCBundle> = [bundle1, bundle1, bundle2, bundle2, bundle3, bundle3]
        
        XCTAssertTrue(set == [bundle1, bundle2, bundle3])
    }
    
    // MARK: - CustomStringConvertible
    
    func testCustomStringConvertible_Immediate_EmptyElements() {
        let bundle = OSCBundle([])
        
        let desc = bundle.description
        
        XCTAssertEqual(desc, "OSCBundle()")
    }
    
    func testCustomStringConvertible_SpecificTimeTag_EmptyElements() {
        let bundle = OSCBundle(timeTag: .init(123_456), [])
        
        let desc = bundle.description
        
        XCTAssertEqual(desc, "OSCBundle(timeTag: 123456)")
    }
    
    func testCustomStringConvertible_Immediate_OneMessage() {
        let bundle = OSCBundle([
            .message(
                "/address",
                values: [
                    Int32(123),
                    String("A string")
                ]
            )
        ])
        
        let desc = bundle.description
        
        XCTAssertEqual(
            desc,
            #"OSCBundle(elements: [OSCMessage("/address", values: [123, "A string"])])"#
        )
    }
    
    func testCustomStringConvertible_SpecificTimeTag_OneMessage() {
        let bundle = OSCBundle(
            timeTag: .init(123_456),
            [
                .message(
                    "/address",
                    values: [
                        Int32(123),
                        String("A string")
                    ]
                )
            ]
        )
        
        let desc = bundle.description
        
        XCTAssertEqual(
            desc,
            #"OSCBundle(timeTag: 123456, elements: [OSCMessage("/address", values: [123, "A string"])])"#
        )
    }
    
    func testDescriptionPretty_Immediate_OneMessage() {
        let bundle = OSCBundle([
            .message(
                "/address",
                values: [
                    Int32(123),
                    String("A string")
                ]
            )
        ])
        
        let desc = bundle.descriptionPretty
        
        XCTAssertEqual(
            desc,
            #"""
            OSCBundle() with elements:
              OSCMessage("/address", values: [123, "A string"])
            """#
        )
    }
    
    func testDescriptionPretty_SpecificTimeTag_OneMessage() {
        let bundle = OSCBundle(
            timeTag: .init(123_456),
            [
                .message(
                    "/address",
                    values: [
                        Int32(123),
                        String("A string")
                    ]
                )
            ]
        )
        
        let desc = bundle.descriptionPretty
        
        XCTAssertEqual(
            desc,
            #"""
            OSCBundle(timeTag: 123456) with elements:
              OSCMessage("/address", values: [123, "A string"])
            """#
        )
    }
    
    // TODO: test is written correctly but Codable conformance on OSCBundle needs to be fixed
//    func testCodable() throws {
//        let encoder = JSONEncoder()
//        let decoder = JSONDecoder()
//
//        let str = OSCBundle(elements: [
//            .bundle(elements: [
//                .message(
//                    "/test/address1",
//                    values: [Int32(123), String("A string.")]
//                )
//            ]),
//            .message(
//                "/test/address2",
//                values: [Int32(456), String("Another string.")]
//            )
//        ], timeTag: .init(123_456))
//
//        let encoded = try encoder.encode(str)
//        let decoded = try decoder.decode(OSCBundle.self, from: encoded)
//
//        XCTAssertEqual(str, decoded)
//    }
}

#endif
