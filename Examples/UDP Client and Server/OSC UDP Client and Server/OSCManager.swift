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

    init() {
        start()
    }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call this once on app launch.
    func start() {
        // setup client
        do { try client.start() } catch { print(error.localizedDescription) }

        // setup server
        server.setReceiveHandler { [weak self] message, timeTag, host, port in
            Task { @MainActor in
                self?.handle(message: message, timeTag: timeTag, host: host, port: port)
            }
        }
        do { try server.start() } catch { print(error.localizedDescription) }
    }

    func stop() {
        client.stop()
        server.stop()
    }
}

// MARK: - Receive

extension OSCManager {
    func handle(message: OSCMessage, timeTag: OSCTimeTag, host: String, port: UInt16) {
        print("\(message) with time tag: \(timeTag) from: \(host) port \(port)")
    }
}

// MARK: - Send

extension OSCManager {
    func send(_ packet: OSCPacket, to host: String, port: UInt16) {
        do {
            try client.send(packet, to: host, port: port)
        } catch {
            print(error.localizedDescription)
        }
    }
}
