//
//  OSCManager.swift
//  SwiftOSC I/O: Cocoa • https://github.com/orchetect/swift-osc-io-cocoa
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftOSCIO

/// OSC lifecycle and send/receive manager.
@MainActor
final class OSCManager: ObservableObject {
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
        do { try client.start() } catch { print(error) }

        receiver = await OSCReceiver()

        // setup server
        server.setReceiveHandler(.messages { [weak self] message, timeTag, host, port in
            Task {
                do {
                    try await self?.receiver?.handle(message: message, timeTag: timeTag, host: host, port: port)
                } catch {
                    print(error)
                }
            }
        })
        do { try server.start() } catch { print(error) }
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
            print(error)
        }
    }
}
