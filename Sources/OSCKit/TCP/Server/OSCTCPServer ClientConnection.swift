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

extension OSCTCPServer.ClientConnection: _OSCTCPClientProtocol {
    func send(_ oscObject: any OSCKitCore.OSCObject) throws {
        try _send(oscObject, tag: tcpSocketTag)
    }
}

extension OSCTCPServer.ClientConnection: _OSCTCPServerProtocol {
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

#endif
