//
//  OSCTCPServer ClientConnection.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation
import OSCKitCore

extension OSCTCPServer {
    /// Internal class encapsulating a remote client connection session accepted by a local ``OSCTCPServer``.
    final class ClientConnection {
        weak var delegate: OSCTCPServerDelegate?
        let tcpSocket: GCDAsyncSocket
        let remoteHost: String // cached, since GCDAsyncSocket resets it upon disconnection
        let remotePort: UInt16 // cached, since GCDAsyncSocket resets it upon disconnection
        let tcpDelegate: OSCTCPClientDelegate
        let tcpSocketTag: Int
        let framingMode: OSCTCPFramingMode
        
        init(
            tcpSocket: GCDAsyncSocket,
            tcpSocketTag: Int,
            framingMode: OSCTCPFramingMode,
            delegate: OSCTCPServerDelegate?
        ) {
            self.tcpSocket = tcpSocket
            remoteHost = tcpSocket.connectedHost ?? ""
            remotePort = tcpSocket.connectedPort
            self.tcpSocketTag = tcpSocketTag
            self.framingMode = framingMode
            self.delegate = delegate
            
            tcpDelegate = OSCTCPClientDelegate()
            tcpDelegate.oscServer = self
        }
        
        deinit {
            close()
        }
    }
}

extension OSCTCPServer.ClientConnection: @unchecked Sendable { } // TODO: unchecked

// MARK: - Lifecycle

extension OSCTCPServer.ClientConnection {
    func close() {
        tcpSocket.disconnectAfterReadingAndWriting()
        tcpSocket.delegate = nil
    }
}

// MARK: - Communication

extension OSCTCPServer.ClientConnection: _OSCTCPSendProtocol {
    func send(_ oscPacket: OSCPacket) throws {
        try _send(oscPacket, tag: tcpSocketTag)
    }
    
    func send(_ oscBundle: OSCBundle) throws {
        try _send(oscBundle, tag: tcpSocketTag)
    }
    
    func send(_ oscMessage: OSCMessage) throws {
        try _send(oscMessage, tag: tcpSocketTag)
    }
}

extension OSCTCPServer.ClientConnection: _OSCTCPHandlerProtocol {
    var queue: DispatchQueue {
        tcpSocket.delegateQueue ?? .global()
    }
    
    var timeTagMode: OSCTimeTagMode {
        delegate?.oscServer?.timeTagMode ?? .ignore
    }
    
    var receiveHandler: OSCHandlerBlock? {
        delegate?.oscServer?.receiveHandler
    }
}

extension OSCTCPServer.ClientConnection: _OSCTCPGeneratesClientNotificationsProtocol {
    // note that this is never called because when a remote connection closes, its socket does not fire
    // `socketDidDisconnect(...)` in GCDAsyncSocketDelegate, but we have to implement this due to
    // other protocol requirements
    func _generateConnectedNotification() {
        delegate?.oscServer?._generateConnectedNotification(
            remoteHost: remoteHost,
            remotePort: remotePort,
            clientID: tcpSocketTag
        )
    }
    
    // note that this is never called because when a remote connection closes, its socket does not fire
    // `socketDidDisconnect(...)` in GCDAsyncSocketDelegate, but we have to implement this due to
    // other protocol requirements
    func _generateDisconnectedNotification(error: GCDAsyncSocketError?) {
        delegate?.oscServer?._generateDisconnectedNotification(
            remoteHost: remoteHost,
            remotePort: remotePort,
            clientID: tcpSocketTag,
            error: error
        )
    }
}

#endif
