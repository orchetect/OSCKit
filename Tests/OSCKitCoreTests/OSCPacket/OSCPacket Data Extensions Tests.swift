//
//  OSCPacket Data Extensions Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing

@Suite struct OSCPacket_Data_Extensions_Tests {
    @Test
    func oscPacketType() throws {
        let bundle = try OSCBundle([]).rawData()
        let msg = try OSCMessage("/").rawData()
        
        // OSC bundle
        #expect(bundle.oscPacketType == .bundle)
        #expect(bundle.oscPacketType != .message)
        
        // OSC message
        #expect(msg.oscPacketType == .message)
        #expect(msg.oscPacketType != .bundle)
        
        // empty bytes
        #expect(Data().oscPacketType == nil)
        
        // garbage bytes
        #expect(Data([0x98, 0x42, 0x01, 0x7E]).oscPacketType == nil)
    }
}
