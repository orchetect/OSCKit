//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKit

/// OSC lifecycle and send/receive manager.
final class OSCManager: ObservableObject {
    private var socket: OSCSocket?
    
    @Published var localPort: UInt16 = 8000
    @Published var remoteHost: String = "localhost"
    @Published var remotePort: UInt16 = 8000
    @Published var isIPv4BroadcastEnabled: Bool = false
    @Published private(set) var isStarted: Bool = false
    
    init() { }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call this once on app launch.
    func start() {
        do {
            guard socket == nil else { return }
            
            let newSocket = OSCSocket(
                localPort: localPort,
                remoteHost: remoteHost,
                remotePort: remotePort,
                isIPv4BroadcastEnabled: isIPv4BroadcastEnabled
            )
            socket = newSocket
            
            newSocket.setHandler { message, timeTag in
                print(message, "with time tag: \(timeTag)")
            }
            
            try newSocket.start()
            
            isStarted = true
            
            let lp = newSocket.localPort
            let rp = newSocket.remotePort
            print("Using local port \(lp) and remote port \(rp) with remote host \(remoteHost).")
        } catch {
            print("Error while starting OSC socket: \(error)")
        }
    }
    
    func stop() {
        defer {
            isStarted = false
        }
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
