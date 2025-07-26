//
//  OSCManager.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKit

/// OSC lifecycle and send/receive manager.
@MainActor
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
        
        newServer.setReceiveHandler { [weak self] message, timeTag, host, port in
            Task { @MainActor in
                self?.handle(messageFromClient: message, timeTag: timeTag, host: host, port: port)
            }
        }
        
        newServer.setNotificationHandler { [weak self] notification in
            Task { @MainActor in
                self?.handle(serverNotification: notification)
            }
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
        
        newClient.setReceiveHandler { [weak self] message, timeTag, host, port in
            Task { @MainActor in
                self?.handle(messageFromServer: message, timeTag: timeTag, host: host, port: port)
            }
        }
        
        newClient.setNotificationHandler { [weak self] notification in
            Task { @MainActor in
                self?.handle(clientNotification: notification)
            }
        }
        
        do {
            try newClient.connect(timeout: 5)
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

// MARK: - Receive

extension OSCManager {
    func handle(messageFromClient message: OSCMessage, timeTag: OSCTimeTag, host: String, port: UInt16) {
        print("From client: \(message) with time tag: \(timeTag) from: \(host) port \(port)")
    }
    
    func handle(messageFromServer message: OSCMessage, timeTag: OSCTimeTag, host: String, port: UInt16) {
        print("From server: \(message) with time tag: \(timeTag) from: \(host) port \(port)")
    }
    
    func handle(clientNotification notification: OSCTCPClient.Notification) {
        switch notification {
        case .connected:
            print("Local client connected to remote server")
            
            isClientConnected = true
            
        case let .disconnected(error: error):
            var logMessage = "Local client disconnected from remote server"
            if let error {
                logMessage += " due to error: \(error.localizedDescription)"
            }
            print(logMessage)
            
            isClientConnected = false
        }
    }
    
    func handle(serverNotification notification: OSCTCPServer.Notification) {
        switch notification {
        case let .connected(remoteHost: remoteHost, remotePort: remotePort, clientID: _):
            print("Local server accepted connection from remote client \(remoteHost) port \(remotePort)")
            
        case let .disconnected(remoteHost: remoteHost, remotePort: remotePort, clientID: _, error: error):
            var logMessage = "Local server was notified that remote client \(remoteHost) port \(remotePort) has disconnected"
            if let error {
                logMessage += " due to error: \(error.localizedDescription)"
            }
            print(logMessage)
            
            isClientConnected = false
        }
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
