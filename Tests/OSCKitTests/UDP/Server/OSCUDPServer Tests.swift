//
//  OSCUDPServer Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation
@testable import OSCKit
import Testing

@Suite(.serialized)
struct OSCUDPServer_Tests {
    /// Check that an empty OSC bundle does not produce any OSC messages.
    @Test
    func emptyBundle() async throws {
        try await confirmation(expectedCount: 0) { confirmation in
            let server = OSCUDPServer()
            
            server.setReceiveHandler { _, _, _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle()
            
            server._handle(payload: bundle, remoteHost: "localhost", remotePort: 8000)
            
            try await Task.sleep(seconds: 1)
        }
    }
    
    /// Ensure rapidly received messages are dispatched in the order they are received.
    @MainActor @Test(arguments: 0 ... 10)
    func messageOrdering(iteration: Int) async throws {
        _ = iteration // argument value not used, just a mechanism to repeat the test X number of times
        
        let server = OSCUDPServer()
        
        final actor Receiver {
            var messages: [(message: OSCMessage, host: String, port: UInt16)] = []
            func received(_ message: OSCMessage, host: String, port: UInt16) {
                messages.append((message, host, port))
            }
        }
        
        let receiver = Receiver()
        
        server.setReceiveHandler { message, timeTag, host, port in
            // print("Handler received:", message.addressPattern)
            Task { @MainActor in
                await receiver.received(message, host: host, port: port)
            }
        }
        
        let msg1 = OSCMessage("/one", values: [123, "string", 500.5, 1, 2, 3, 4, "string2", true, 12345])
        let msg2 = OSCMessage("/two")
        let msg3 = OSCMessage("/three")
        
        // use global thread to simulate internal network thread being a dedicated thread
        DispatchQueue.global().async {
            server._handle(payload: msg1, remoteHost: "localhost", remotePort: 8000)
            server._handle(payload: msg2, remoteHost: "192.168.0.25", remotePort: 8001)
            server._handle(payload: msg3, remoteHost: "10.0.0.50", remotePort: 8080)
        }
        
        try await wait(require: { await receiver.messages.count == 3 }, timeout: 5.0)
        
        let message1 = await receiver.messages[0]
        #expect(message1.message == msg1)
        #expect(message1.host == "localhost")
        #expect(message1.port == 8000)
        
        let message2 = await receiver.messages[1]
        #expect(message2.message == msg2)
        #expect(message2.host == "192.168.0.25")
        #expect(message2.port == 8001)
        
        let message3 = await receiver.messages[2]
        #expect(message3.message == msg3)
        #expect(message3.host == "10.0.0.50")
        #expect(message3.port == 8080)
    }
    
    /// Offline stress-test to ensure a large volume of OSC packets are received and dispatched in order.
    @MainActor @Test
    func stressTestOffline() async throws {
        let server = OSCUDPServer()
        
        final actor Receiver {
            var messages: [OSCMessage] = []
            func received(_ message: OSCMessage) {
                messages.append(message)
            }
        }
        
        let receiver = Receiver()
        
        server.setReceiveHandler { message, timeTag, host, port in
            Task { @MainActor in
                await receiver.received(message)
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
                server._handle(payload: message, remoteHost: "localhost", remotePort: 8000)
            }
        }
        
        try await wait(require: { await receiver.messages.count == 1000 }, timeout: 5.0)
        
        await #expect(receiver.messages == sourceMessages)
    }
    
    /// Online stress-test to ensure a large volume of OSC packets are received and dispatched in order.
    @MainActor @Test
    func stressTestOnline() async throws {
        let isFlakey = !isSystemTimingStable()
        
        let server = OSCUDPServer(port: 8888, timeTagMode: .ignore, queue: nil, receiveHandler: nil)
        try await Task.sleep(seconds: isFlakey ? 5.0 : 0.1)
        
        try server.start()
        try await Task.sleep(seconds: isFlakey ? 5.0 : 0.5)
        
        print("Using server listen port \(server.localPort)")
        
        final actor Receiver {
            var messages: [OSCMessage] = []
            func received(_ message: OSCMessage) {
                messages.append(message)
            }
        }
        
        let receiver = Receiver()
        
        server.setReceiveHandler { message, timeTag, host, port in
            Task { @MainActor in
                await receiver.received(message)
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
        
        let client = OSCUDPClient()
        try await Task.sleep(seconds: isFlakey ? 5.0 : 0.1)
        
        // use global thread to simulate internal network thread being a dedicated thread
        let srcLocSendToServer: SourceLocation = #_sourceLocation
        DispatchQueue.global().async {
            for message in sourceMessages {
                do { try client.send(message, to: "localhost", port: 8888) }
                catch { Issue.record(error, sourceLocation: srcLocSendToServer) }
            }
        }
        
        await wait(expect: { await receiver.messages.count == 1000 }, timeout: isFlakey ? 20.0 : 5.0)
        try await #require(receiver.messages.count == 1000)
        
        await #expect(receiver.messages == sourceMessages)
    }
}

#endif
