//
//  OSCBundle Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing

@Suite struct OSCBundle_Tests {
    // MARK: - Equatable
    
    @Test
    func equatable() {
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
        
        #expect(bundle1 == bundle1)
        #expect(bundle2 == bundle2)
        #expect(bundle3 == bundle3)
        
        #expect(bundle1 != bundle2)
        #expect(bundle1 != bundle3)
        
        #expect(bundle2 != bundle3)
    }
    
    // MARK: - Hashable
    
    @Test
    func hashable() {
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
        
        #expect(set == [bundle1, bundle2, bundle3])
    }
    
    // MARK: - CustomStringConvertible
    
    @Test
    func customStringConvertible_Immediate_EmptyElements() {
        let bundle = OSCBundle([])
        
        let desc = bundle.description
        
        #expect(desc == "OSCBundle()")
    }
    
    @Test
    func customStringConvertible_SpecificTimeTag_EmptyElements() {
        let bundle = OSCBundle(timeTag: .init(123_456), [])
        
        let desc = bundle.description
        
        #expect(desc == "OSCBundle(timeTag: 123456)")
    }
    
    @Test
    func customStringConvertible_Immediate_OneMessage() {
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
        
        #expect(
            desc ==
                #"OSCBundle(elements: [OSCMessage("/address", values: [123, "A string"])])"#
        )
    }
    
    @Test
    func customStringConvertible_SpecificTimeTag_OneMessage() {
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
        
        #expect(
            desc ==
                #"OSCBundle(timeTag: 123456, elements: [OSCMessage("/address", values: [123, "A string"])])"#
        )
    }
    
    @Test
    func descriptionPretty_Immediate_OneMessage() {
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
        
        #expect(
            desc ==
                #"""
                OSCBundle() with elements:
                  OSCMessage("/address", values: [123, "A string"])
                """#
        )
    }
    
    @Test
    func descriptionPretty_SpecificTimeTag_OneMessage() {
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
        
        #expect(
            desc ==
                #"""
                OSCBundle(timeTag: 123456) with elements:
                  OSCMessage("/address", values: [123, "A string"])
                """#
        )
    }
    
    // TODO: test is written correctly but Codable conformance on OSCBundle needs to be fixed
    // @Test func codable() throws {
    //     let encoder = JSONEncoder()
    //     let decoder = JSONDecoder()
    //
    //     let str = OSCBundle(timeTag: .init(123_456), [
    //         .bundle([
    //             .message(
    //                 "/test/address1",
    //                 values: [Int32(123), String("A string.")]
    //             )
    //         ]),
    //         .message(
    //             "/test/address2",
    //             values: [Int32(456), String("Another string.")]
    //         )
    //     ])
    //
    //     let encoded = try encoder.encode(str)
    //     let decoded = try decoder.decode(OSCBundle.self, from: encoded)
    //
    //     #expect(str == decoded)
    // }
}
