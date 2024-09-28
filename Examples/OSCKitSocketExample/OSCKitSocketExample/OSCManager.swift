//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

/// OSC lifecycle and send/receive manager.
final class OSCManager {
    private var socket: OSCSocket?
    
    var localPort: UInt16?
    var remoteHost: String = ""
    var remotePort: UInt16?
    var isPortReuseEnabled: Bool = false
    var isIPv4BroadcastEnabled: Bool = false
    
    init() { }
    
    deinit {
        stop()
    }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call this once on app launch.
    func start() {
        guard socket == nil else { return }
        
        do {
            let newSocket = OSCSocket(
                localPort: localPort,
                remoteHost: remoteHost,
                remotePort: remotePort
            ) { message, timeTag in
                print(message, "with time tag: \(timeTag)")
            }
            socket = newSocket
            
            newSocket.isPortReuseEnabled = isPortReuseEnabled
            newSocket.isIPv4BroadcastEnabled = isIPv4BroadcastEnabled
            
            try newSocket.start()
            
            print(
                "Using local port \(newSocket.localPort) and remote port \(newSocket.remotePort) with remote host \(remoteHost)."
            )
        } catch {
            print("Error while starting OSC socket: \(error)")
        }
    }
    
    func stop() {
        socket?.stop()
        socket = nil
    }
}

// MARK: - Send

extension OSCManager {
    func send(_ message: OSCMessage) {
        do {
            try socket?.send(message)
        } catch {
            print(error)
        }
    }
}
