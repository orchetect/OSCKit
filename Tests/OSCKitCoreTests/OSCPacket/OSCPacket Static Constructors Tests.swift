//
//  OSCPacket Static Constructors Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCPacket_StaticConstructors_Tests {
    // MARK: - OSCMessage
    
    @Test
    func oscPacket_message_AddressPatternString() throws {
        let addr = String("/msg1")
        let packet: OSCPacket = .message(
            addr,
            values: [Int32(123)]
        )
        
        guard case let .message(msg) = packet else {
            Issue.record()
            return
        }
        
        #expect(msg.addressPattern.stringValue == "/msg1")
        #expect(msg.values[0] as? Int32 == Int32(123))
    }
    
    @Test
    func oscPacket_message_AddressPattern() throws {
        let packet: OSCPacket = .message(
            OSCAddressPattern("/msg1"),
            values: [Int32(123)]
        )
        
        guard case let .message(msg) = packet else {
            Issue.record()
            return
        }
        
        #expect(msg.addressPattern.stringValue == "/msg1")
        #expect(msg.values[0] as? Int32 == Int32(123))
    }
    
    // MARK: - OSCBundle
    
    @Test
    func oscPacket_bundle() throws {
        let packet: OSCPacket = .bundle([
            .message("/", values: [Int32(123)])
        ])
        
        guard case let .bundle(bundle) = packet else {
            Issue.record()
            return
        }
        
        #expect(bundle.elements.count == 1)
        
        guard case let .message(msg) = bundle.elements[0] else {
            Issue.record()
            return
        }
        
        #expect(msg.values[0] as? Int32 == Int32(123))
    }
}
