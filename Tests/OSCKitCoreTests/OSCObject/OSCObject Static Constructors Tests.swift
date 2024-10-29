//
//  OSCObject Static Constructors Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCObject_StaticConstructors_Tests {
    // MARK: - OSCMessage
    
    @Test func oscMessage_AddressPatternString() throws {
        let addr = String("/msg1")
        let obj: any OSCObject = .message(
            addr,
            values: [Int32(123)]
        )
        
        let msg: OSCMessage = try #require(obj as? OSCMessage)
        
        #expect(msg.addressPattern.stringValue == "/msg1")
        #expect(msg.values[0] as? Int32 == Int32(123))
    }
    
    @Test func oscMessage_AddressPattern() throws {
        let obj: any OSCObject = .message(
            OSCAddressPattern("/msg1"),
            values: [Int32(123)]
        )
        
        let msg: OSCMessage = try #require(obj as? OSCMessage)
        
        #expect(msg.addressPattern.stringValue == "/msg1")
        #expect(msg.values[0] as? Int32 == Int32(123))
    }
    
    // MARK: - OSCBundle
    
    @Test func oscBundle() throws {
        let obj: any OSCObject = .bundle([
            .message("/", values: [Int32(123)])
        ])
        
        let bundle: OSCBundle = try #require(obj as? OSCBundle)
        
        #expect(bundle.elements.count == 1)
        
        let msg = try #require(bundle.elements[0] as? OSCMessage)
        #expect(msg.values[0] as? Int32 == Int32(123))
    }
}
