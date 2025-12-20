//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKit

/// OSC lifecycle and send/receive manager.
@MainActor final class OSCManager: ObservableObject {
    private let client = OSCUDPClient()
    private let server = OSCUDPServer(port: 8000)
    private var receiver: OSCReceiver?
    
    init() {
        Task { await start() }
    }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call once at app startup.
    func start() async {
        // setup client
        do { try client.start() } catch { print(error.localizedDescription) }
        
        receiver = await OSCReceiver()
        
        // setup server
        server.setReceiveHandler { [weak self] message, timeTag, host, port in
            Task {
                do {
                    try await self?.receiver?.handle(message: message, timeTag: timeTag, host: host, port: port)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        do { try server.start() } catch { print(error.localizedDescription) }
    }
    
    func stop() {
        client.stop()
        server.stop()
    }
}

// MARK: - Send

extension OSCManager {
    func send(_ message: OSCMessage, to host: String, port: UInt16) {
        do {
            try client.send(message, to: host, port: port)
        } catch {
            print(error.localizedDescription)
        }
    }
}
