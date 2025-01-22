//
//  OSCSocket Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation
@testable import OSCKit
import Testing

@Suite(.serialized)
struct OSCSocket_Tests {
    @Test func emptyBundle() async throws {
        try await confirmation(expectedCount: 0) { confirmation in
            let socket = OSCSocket(remoteHost: "localhost")
            
            socket.setHandler { _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle()
            
            socket._handle(payload: bundle)
            
            try await Task.sleep(seconds: 1)
        }
    }
    
    /// Ensure rapidly received messages are dispatched in the order they are received.
    @Test(arguments: 0 ... 10)
    func messageOrdering(iteration: Int) async throws {
        _ = iteration // argument value not used, just a mechanism to repeat the test X number of times
        
        let server = OSCSocket()
        
        final class Receiver: @unchecked Sendable {
            var messages: [OSCMessage] = []
            func received(_ message: OSCMessage) {
                messages.append(message)
            }
        }
        
        let receiver = Receiver()
        
        server.setHandler { message, timeTag in
            // print("Handler received:", message.addressPattern)
            DispatchQueue.global().sync {
                receiver.received(message)
            }
        }
        
        let msg1 = OSCMessage("/one", values: [123, "string", 500.5, 1, 2, 3, 4, "string2", true, 12345])
        let msg2 = OSCMessage("/two")
        let msg3 = OSCMessage("/three")
        
        DispatchQueue.main.async {
            server._handle(payload: msg1)
        }
        DispatchQueue.main.async {
            server._handle(payload: msg2)
        }
        DispatchQueue.main.async {
            server._handle(payload: msg3)
        }
        
        try await Task.sleep(seconds: 0.5)
        
        try #require(receiver.messages.count == 3)
        
        #expect(receiver.messages[0] == msg1)
        #expect(receiver.messages[1] == msg2)
        #expect(receiver.messages[2] == msg3)
    }
}

#endif
