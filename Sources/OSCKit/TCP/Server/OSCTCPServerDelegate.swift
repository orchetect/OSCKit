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
    weak var oscServer: (any _OSCTCPHandlerProtocol & _OSCTCPGeneratesServerNotificationsProtocol)?
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
        
        // send notification
        oscServer?._generateConnectedNotification(
            remoteHost: newSocket.connectedHost ?? "",
            remotePort: newSocket.connectedPort,
            clientID: clientID
        )
        
        // read initial data
        newSocket.readData(withTimeout: -1, tag: clientID)
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
        
        // in almost all cases, this should only return one client,
        // however for sake of over-engineering, we'll remove all matches
        let disconnectedClients: [(clientID: Int, host: String, port: UInt16)] = clients
            .filter { $0.value.tcpSocket == sock }
            .map {
                (
                    clientID: $0.key,
                    host: $0.value.remoteHost,
                    port: $0.value.remotePort
                )
            }
        
        for (clientID, _, _) in disconnectedClients {
            clients[clientID]?.delegate = nil
            clients[clientID] = nil
        }
        
        // errors should only ever be of type `GCDAsyncSocketError`
        var error = err as? GCDAsyncSocketError
        // CocoaAsyncSocket populates `err` with GCDAsyncSocketError.closedError
        // whenever the remote peer closes its connection intentionally,
        // so we'll interpret that as a non-error condition
        if error?.code == GCDAsyncSocketError.closedError {
            error = nil
        }
        
        // send notification
        // note that sock.connectedHost will be nil, and sock.connectedPort will be 0
        // so we need to grab host/port from the local clients info
        for (clientID, host, port) in disconnectedClients {
            oscServer?._generateDisconnectedNotification(
                remoteHost: host,
                remotePort: port,
                clientID: clientID,
                error: error
            )
        }
    }
}

// MARK: - Methods

extension OSCTCPServerDelegate {
    /// Close connections for any connected clients and remove them from the list of connected clients.
    func closeClients() {
        for clientID in clients.keys {
            closeClient(clientID: clientID)
        }
    }
    
    /// Close a connection and remove it from the list of connected clients.
    func closeClient(clientID: Int) {
        clients[clientID]?.close()
        clients[clientID] = nil
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
