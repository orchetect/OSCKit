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
        
        let bundle1 = OSCBundle([.message(msg1)])
        let bundle2 = OSCBundle([.message(msg3)])
        let bundle3 = OSCBundle([
            .bundle(bundle1),
            .bundle(bundle2),
            .message(msg2)
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
        
        let bundle1 = OSCBundle([.message(msg1)])
        let bundle2 = OSCBundle([.message(msg3)])
        let bundle3 = OSCBundle([
            .bundle(bundle1),
            .bundle(bundle2),
            .message(msg2)
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
}
