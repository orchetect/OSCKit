//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKit

/// OSC lifecycle and send/receive manager.
final class OSCManager: ObservableObject {
    private var client: OSCTCPClient?
    private var server: OSCTCPServer?
    
    @Published var serverPort: UInt16 = 3032
    @Published var clientHost: String = "localhost"
    @Published var clientPort: UInt16 = 3032
    @Published var framingMode: OSCTCPFramingMode = .osc1_1
    @Published private(set) var isServerStarted: Bool = false
    @Published private(set) var isClientConnected: Bool = false
    
    init() { }
}

// MARK: - Lifecycle

extension OSCManager {
    /// Call this once on app launch.
    func startServer() {
        // setup server
        let newServer = OSCTCPServer(port: serverPort, framingMode: framingMode)
        server = newServer
        newServer.setReceiveHandler { /* [weak self] */ message, timeTag, host, port in
            print("From client: \(message) with time tag: \(timeTag) from: \(host):\(port)")
        }
        do {
            try newServer.start()
            isServerStarted = true
        } catch {
            print(error)
            isServerStarted = false
        }
    }
    
    func connectClient() {
        let newClient = OSCTCPClient(remoteHost: clientHost, remotePort: clientPort, framingMode: framingMode)
        client = newClient
        newClient.setReceiveHandler { /* [weak self] */ message, timeTag, host, port in
            print("From server: \(message) with time tag: \(timeTag) from: \(host):\(port)")
        }
        
        do {
            try newClient.connect()
            isClientConnected = true
        } catch {
            print(error)
            isClientConnected = false
        }
    }
    
    func disconnectClient() {
        client?.close()
        isClientConnected = false
    }
    
    func stopServer() {
        server?.stop()
        isServerStarted = false
    }
}

// MARK: - Send

extension OSCManager {
    func sendToServer(_ message: OSCMessage) {
        do {
            try client?.send(message)
        } catch {
            print(error)
        }
    }
    
    func sendToAllClients(_ message: OSCMessage) {
        do {
            try server?.send(message)
        } catch {
            print(error)
        }
    }
}
