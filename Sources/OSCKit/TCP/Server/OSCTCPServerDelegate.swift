//
//  OSCTCPServerDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation

/// Internal TCP receiver class so as to not expose `GCDAsyncSocketDelegate` methods as public.
final class OSCTCPServerDelegate: NSObject {
    weak var oscServer: _OSCTCPServerProtocol?
    let framingMode: OSCTCPFramingMode
    
    /// Currently connected client sessions.
    var clients: [OSCTCPClientSessionID: OSCTCPServer.ClientConnection] = [:]
    
    init(framingMode: OSCTCPFramingMode) {
        self.framingMode = framingMode
    }
    
    deinit {
        closeClients()
    }
}

extension OSCTCPServerDelegate: @unchecked Sendable { } // TODO: unchecked

extension OSCTCPServerDelegate: GCDAsyncSocketDelegate {
    func newSocketQueueForConnection(fromAddress address: Data, on sock: GCDAsyncSocket) -> dispatch_queue_t? {
        oscServer?.queue
    }
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        // add new connection to connections dictionary
        let clientID = newClientID()
        let newConnection = OSCTCPServer.ClientConnection(
            tcpSocket: newSocket,
            tcpSocketTag: clientID,
            framingMode: framingMode,
            delegate: self
        )
        clients[clientID] = newConnection
        newSocket.delegate = self
        
        // read initial data
        newSocket.readData(withTimeout: -1, tag: clientID)
        
        // send notification
        oscServer?.notificationHandler?(
            .connected(remoteHost: sock.connectedHost ?? "", remotePort: sock.connectedPort)
        )
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        defer {
            // request socket to continue reading data
            sock.readData(withTimeout: -1, tag: tag)
        }
        
        oscServer?._handle(receivedData: data, on: sock, tag: tag)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: (any Error)?) {
        // remove connection from connections dictionary
        
        let disconnectedClients = clients
            .filter { $0.value.tcpSocket == sock }
        
        for (sockID, socket) in disconnectedClients {
            socket.delegate = nil
            clients[sockID] = nil
        }
        
        // send notification
        oscServer?.notificationHandler?(
            .disconnected(remoteHost: sock.connectedHost ?? "", remotePort: sock.connectedPort)
        )
    }
}

// MARK: - Methods

extension OSCTCPServerDelegate {
    /// Close connections for any connected clients and remove them from the list of connected clients.
    func closeClients() {
        clients.forEach { $0.value.close() }
        clients.removeAll()
    }
}

// MARK: - Utilities

extension OSCTCPServerDelegate {
    /// Generate a new client ID that is not currently in use by any connected client(s).
    private func newClientID() -> OSCTCPClientSessionID {
        var clientID: Int = 0
        while clientID == 0 || clients.keys.contains(clientID) {
            // don't allow 0 or negative numbers
            clientID = Int.random(in: 1 ... Int.max)
        }
        assert(clientID > 0)
        return clientID
    }
}

#endif
