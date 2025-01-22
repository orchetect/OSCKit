//
//  OSCMessage Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCMessage_Tests {
    // MARK: - Equatable
    
    @Test
    func equatable() {
        let msg1 = OSCMessage("/msg1")
        let msg2 = OSCMessage("/msg2")
        let msg3 = OSCMessage("/msg1", values: [Int32(123)])
        
        #expect(msg1 == msg1)
        #expect(msg2 == msg2)
        #expect(msg3 == msg3)
        
        #expect(msg1 != msg2)
        #expect(msg1 != msg3)
        
        #expect(msg2 != msg3)
    }
    
    // MARK: - Hashable
    
    @Test
    func hashable() {
        let msg1 = OSCMessage("/msg1")
        let msg2 = OSCMessage("/msg2")
        let msg3 = OSCMessage("/msg1", values: [Int32(123)])
        
        let set: Set<OSCMessage> = [msg1, msg1, msg2, msg2, msg3, msg3]
        
        #expect(set == [msg1, msg2, msg3])
    }
    
    // MARK: - CustomStringConvertible
    
    @Test
    func customStringConvertible1() {
        let msg = OSCMessage("/")
        
        #expect(msg.description == #"OSCMessage("/")"#)
    }
    
    @Test
    func customStringConvertible2() {
        let msg = OSCMessage(
            "/address",
            values: [Int32(123), String("A string")]
        )
        
        #expect(
            msg.description ==
                #"OSCMessage("/address", values: [123, "A string"])"#
        )
    }
    
    @Test
    func descriptionPretty() {
        let msg = OSCMessage(
            "/address",
            values: [Int32(123), String("A string")]
        )
        
        #expect(
            msg.descriptionPretty ==
                #"""
                OSCMessage("/address") with values:
                  Int32: 123
                  String: A string
                """#
        )
    }
}
