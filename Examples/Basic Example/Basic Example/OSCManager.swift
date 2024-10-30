//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

/// OSC lifecycle and send/receive manager.
final class OSCManager: ObservableObject {
    private let client = OSCClient()
    private let server = OSCServer(port: 8000)
    
    init() {
        Task { await start() }
    }
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
        print("\(message) with time tag: \(timeTag)")
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
