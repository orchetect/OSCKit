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
    private let receiver = OSCReceiver()
    
    init() { }
    
    deinit {
        stop()
    }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call once at app startup.
    func start() {
        // setup client
        
        // client.isPortReuseEnabled = true // optionally enable port reuse
        // client.isIPv4BroadcastEnabled = true // optionally enable IPv4 broadcast
        do { try client.start() } catch { print(error) }
        
        // setup server
        
        server.setHandler { [weak self] message, timeTag in
            do {
                try self?.receiver.handle(
                    message: message,
                    timeTag: timeTag
                )
            } catch {
                print(error)
            }
        }
        
        // server.isPortReuseEnabled = true // optionally enable port reuse
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
