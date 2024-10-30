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
    var isIPv4BroadcastEnabled: Bool = false
    
    init() { }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call this once on app launch.
    func start() async {
        do {
            guard socket == nil else { return }
            
            let newSocket = OSCSocket(
                localPort: localPort,
                remoteHost: remoteHost,
                remotePort: remotePort,
                isIPv4BroadcastEnabled: isIPv4BroadcastEnabled
            )
            socket = newSocket
            
            await newSocket.setHandler { message, timeTag in
                print(message, "with time tag: \(timeTag)")
            }
            
            try await newSocket.start()
            
            let lp = await newSocket.localPort
            let rp = await newSocket.remotePort
            print(
                "Using local port \(lp) and remote port \(rp) with remote host \(remoteHost)."
            )
        } catch {
            print("Error while starting OSC socket: \(error)")
        }
    }
    
    func stop() async {
        await socket?.stop()
        socket = nil
    }
}

// MARK: - Send

extension OSCManager {
    func send(_ message: OSCMessage) async {
        do {
            try await socket?.send(message)
        } catch {
            print(error)
        }
    }
}
