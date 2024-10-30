//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

/// OSC lifecycle and send/receive manager.
final class OSCManager {
    private let client = OSCClient()
    private let server = OSCServer(port: 8000)
    
    init() { }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call this once on app launch.
    func start() async {
        // setup client
        do { try client.start() } catch { print(error) }
        
        // setup server
        await server.setHandler { [weak self] message, timeTag in
            self?.handle(message: message, timeTag: timeTag)
        }
        do { try await server.start() } catch { print(error) }
    }
    
    func stop() async {
        client.stop()
        await server.stop()
    }
}

// MARK: - Receive

extension OSCManager {
    func handle(message: OSCMessage, timeTag: OSCTimeTag) {
        do {
            let customTypeValue = try message.values.masked(CustomType.self)
            
            let msg = message.addressPattern.stringValue
            let id = customTypeValue.id
            let name = customTypeValue.name
            print(
                "OSC message with address \"\(msg)\" with CustomType value containing id:\(id) and name:\(name)"
            )
        } catch {
            print("OSC message received that did not have exactly one value of type CustomType.")
        }
    }
}

// MARK: - Send

extension OSCManager {
    func send(_ message: OSCMessage, to host: String, port: UInt16) {
        do {
            try client.send(message, to: host, port: port)
        } catch {
            print(error)
        }
    }
}
