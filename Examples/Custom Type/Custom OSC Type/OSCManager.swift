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
    
    init() {
        do {
            try OSCSerialization.shared.registerType(CustomType.self)
        } catch {
            print(error.localizedDescription)
        }
        
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
        server.setReceiveHandler { [weak self] message, timeTag, host, port in
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
        do {
            let customTypeValue = try message.values.masked(CustomType.self)
            
            let msg = message.addressPattern.stringValue
            let id = customTypeValue.id
            let name = customTypeValue.name
            print(
                "OSC message from \(host):\(port), address \"\(msg)\", CustomType value containing id:\(id) and name:\(name)"
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
