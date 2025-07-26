//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKit

/// OSC lifecycle and send/receive manager.
final class OSCManager: ObservableObject, Sendable {
    private let client = OSCUDPClient()
    private let server = OSCUDPServer(port: 8000)
    private let receiver = OSCReceiver()
    
    init() {
        start()
    }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call once at app startup.
    func start() {
        // setup client
        do { try client.start() } catch { print(error) }
        
        // setup server
        server.setReceiveHandler { [weak self] message, timeTag, host, port in
            do {
                try self?.receiver.handle(message: message, timeTag: timeTag, host: host, port: port)
            } catch {
                print(error)
            }
        }
        do { try server.start() } catch { print(error) }
    }
    
    func stop() {
        client.stop()
        server.stop()
    }
}

// MARK: - Send

extension OSCManager {
    func send(
        _ message: OSCMessage,
        to host: String,
        port: UInt16
    ) {
        do {
            try client.send(message, to: host, port: port)
        } catch {
            print(error)
        }
    }
}
