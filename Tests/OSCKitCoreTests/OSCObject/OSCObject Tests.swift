//
//  OSCObject Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing

@Suite struct OSCObject_Tests {
    @Test func appearsToBeOSC() throws {
        let bundle = try OSCBundle([]).rawData()
        let msg    = try OSCMessage("/").rawData()
        
        // OSC bundle
        #expect(bundle.oscObjectType == .bundle)
        #expect(bundle.oscObjectType != .message)
        
        // OSC message
        #expect(msg.oscObjectType == .message)
        #expect(msg.oscObjectType != .bundle)
        
        // empty bytes
        #expect(Data().oscObjectType == nil)
        
        // garbage bytes
        #expect(Data([0x98, 0x42, 0x01, 0x7E]).oscObjectType == nil)
    }
}
