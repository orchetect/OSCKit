//
//  OSCPacket Properties Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing

@Suite struct OSCPacket_Properties_Tests {
    @Test
    func messages_Message() throws {
        let msg = OSCMessage("/test", values: [123, "a string"])
        let packet: OSCPacket = .message(msg)
        
        #expect(packet.messages == [msg])
    }
    
    @Test
    func messages_Bundle_empty() throws {
        let bundle = OSCBundle()
        let packet: OSCPacket = .bundle(bundle)
        
        #expect(packet.messages == [])
    }
    
    @Test
    func messages_Bundle_oneMessage() throws {
        let msg = OSCMessage("/test", values: [123, "a string"])
        let bundle = OSCBundle([.message(msg)])
        let packet: OSCPacket = .bundle(bundle)
        
        #expect(packet.messages == [msg])
    }
    
    @Test
    func messages_Bundle_multipleMessages() throws {
        let msg1 = OSCMessage("/test1", values: [123, "a string"])
        let msg2 = OSCMessage("/test2", values: [true])
        let bundle = OSCBundle([.message(msg1), .message(msg2)])
        let packet: OSCPacket = .bundle(bundle)
        
        #expect(packet.messages == [msg1, msg2])
    }
    
    @Test
    func messages_Bundle_nestedBundles() throws {
        let msg3 = OSCMessage("/test3", values: [.null])
        let msg4 = OSCMessage("/test4", values: [.impulse])
        let bundle1 = OSCBundle([.message(msg3), .message(msg4)])
        
        let msg5 = OSCMessage("/test5", values: [.stringAlt("hello")])
        let msg6 = OSCMessage("/test6", values: [.midi(status: 0xF7)])
        let bundle2 = OSCBundle([.message(msg5), .bundle(bundle1), .message(msg6)])
        
        let msg1 = OSCMessage("/test1", values: [123, "a string"])
        let msg2 = OSCMessage("/test2", values: [true])
        let bundle3 = OSCBundle([.message(msg1), .message(msg2), .bundle(bundle2)])
        
        let packet: OSCPacket = .bundle(bundle3)
        
        #expect(packet.messages == [msg1, msg2, msg5, msg3, msg4, msg6])
    }
}
