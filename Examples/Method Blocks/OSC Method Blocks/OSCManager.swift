//
//  OSCManager.swift
//  SwiftOSC I/O: Cocoa • https://github.com/orchetect/swift-osc-io-cocoa
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftOSCIOCocoa

/// OSC lifecycle and send/receive manager.
@MainActor
final class OSCManager: ObservableObject {
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
        do { try client.start() } catch { print(error.localizedDescription) }

        // setup server
        server.setReceiveHandler { [weak self] message, timeTag, host, port in
            Task {
                await self?.receiver.handle(message: message, timeTag: timeTag, host: host, port: port)
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
    func send(
        _ message: OSCMessage,
        to host: String,
        port: UInt16
    ) {
        do {
            try client.send(message, to: host, port: port)
        } catch {
            print(error.localizedDescription)
        }
    }
}
