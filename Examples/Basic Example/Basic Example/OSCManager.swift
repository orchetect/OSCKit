//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKit

/// OSC lifecycle and send/receive manager.
final class OSCManager: ObservableObject, Sendable {
    private let client = OSCClient()
    private let server = OSCServer(port: 8000)
    
    init() {
        start()
    }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call this once on app launch.
    func start() {
        // setup client
        do { try client.start() } catch { print(error) }
        
        // setup server
        server.setHandler { [weak self] message, timeTag, host, port in
            self?.handle(message: message, timeTag: timeTag, host: host, port: port)
        }
        do { try server.start() } catch { print(error) }
    }
    
    func stop() {
        client.stop()
        server.stop()
    }
}

// MARK: - Receive

extension OSCManager {
    func handle(message: OSCMessage, timeTag: OSCTimeTag, host: String, port: UInt16) {
        print("\(message) with time tag: \(timeTag) from: \(host):\(port)")
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
