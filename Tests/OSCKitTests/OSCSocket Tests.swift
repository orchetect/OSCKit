//
//  OSCSocket Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation
@testable import OSCKit
import Testing

@Suite(.serialized)
struct OSCSocket_Tests {
    /// Check that an empty OSC bundle does not produce any OSC messages.
    @Test
    func emptyBundle() async throws {
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
            DispatchQueue.main.async {
                receiver.received(message)
            }
        }
        
        let msg1 = OSCMessage("/one", values: [123, "string", 500.5, 1, 2, 3, 4, "string2", true, 12345])
        let msg2 = OSCMessage("/two")
        let msg3 = OSCMessage("/three")
        
        // use global thread to simulate internal network thread being a dedicated thread
        DispatchQueue.global().async {
            server._handle(payload: msg1)
            server._handle(payload: msg2)
            server._handle(payload: msg3)
        }
        
        try await wait(require: { receiver.messages.count == 3 }, timeout: 5.0)
        
        #expect(receiver.messages[0] == msg1)
        #expect(receiver.messages[1] == msg2)
        #expect(receiver.messages[2] == msg3)
    }
    
    /// Offline stress-test to ensure a large volume of OSC packets are received and dispatched in order.
    @Test
    func stressTestOffline() async throws {
        let socket = OSCSocket(
            localPort: nil,
            remoteHost: "localhost",
            remotePort: nil,
            timeTagMode: .ignore,
            isIPv4BroadcastEnabled: false,
            receiveQueue: nil,
            handler: nil
        )
        try socket.start()
        
        final class Receiver: @unchecked Sendable {
            var messages: [OSCMessage] = []
            func received(_ message: OSCMessage) {
                messages.append(message)
            }
        }
        
        let receiver = Receiver()
        
        socket.setHandler { message, timeTag in
            DispatchQueue.main.async {
                receiver.received(message)
            }
        }
        
        let possibleValuePacks: [OSCValues] = [
            [],
            [UUID().uuidString],
            [Int.random(in: 10_000 ... 10_000_000)],
            [Int.random(in: 10_000 ... 10_000_000), UUID().uuidString, 456.78, true]
        ]
        
        let sourceMessages: [OSCMessage] = Array(1 ... 1000).map { value in
            OSCMessage("/some/address/\(UUID().uuidString)", values: possibleValuePacks.randomElement()!)
        }
        
        // use global thread to simulate internal network thread being a dedicated thread
        DispatchQueue.global().async {
            for message in sourceMessages {
                socket._handle(payload: message)
            }
        }
        
        try await wait(require: { receiver.messages.count == 1000 }, timeout: 5.0)
        
        #expect(receiver.messages == sourceMessages)
    }
    
    /// Online stress-test to ensure a large volume of OSC packets are received and dispatched in order.
    @Test
    func stressTestOnline() async throws {
        let socket = OSCSocket(
            localPort: nil,
            remoteHost: "localhost",
            remotePort: nil,
            timeTagMode: .ignore,
            isIPv4BroadcastEnabled: false,
            receiveQueue: nil,
            handler: nil
        )
        try await Task.sleep(seconds: 0.2) // short wait for network layer setup
        
        try socket.start()
        try await Task.sleep(seconds: 0.5) // short wait for network layer setup
        
        final class Receiver: @unchecked Sendable {
            var messages: [OSCMessage] = []
            func received(_ message: OSCMessage) {
                messages.append(message)
            }
        }
        
        let receiver = Receiver()
        
        socket.setHandler { message, timeTag in
            DispatchQueue.main.async {
                receiver.received(message)
            }
        }
        
        let possibleValuePacks: [OSCValues] = [
            [],
            [UUID().uuidString],
            [Int.random(in: 10_000 ... 10_000_000)],
            [Int.random(in: 10_000 ... 10_000_000), UUID().uuidString, 456.78, true]
        ]
        
        let sourceMessages: [OSCMessage] = Array(1 ... 1000).map { value in
            OSCMessage("/some/address/\(UUID().uuidString)", values: possibleValuePacks.randomElement()!)
        }
        
        // use global thread to simulate internal network thread being a dedicated thread
        DispatchQueue.global().async {
            for message in sourceMessages {
                try? socket.send(message)
            }
        }
        
        try await wait(require: { receiver.messages.count == 1000 }, timeout: 10.0)
        
        #expect(receiver.messages == sourceMessages)
    }
}

#endif
