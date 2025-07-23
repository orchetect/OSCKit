//
//  OSCTCPServerConnection.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation
import OSCKitCore

final class OSCTCPServerConnection {
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
        
        tcpDelegate = OSCTCPClientDelegate(framingMode: framingMode)
        tcpDelegate.oscServer = self
    }
    
    deinit {
        close()
    }
}

// MARK: - Lifecycle

extension OSCTCPServerConnection {
    func close() {
        tcpSocket.delegate = nil
        tcpSocket.disconnectAfterReadingAndWriting()
    }
}

// MARK: - Communication

extension OSCTCPServerConnection: _OSCTCPClientProtocol {
    func send(_ oscObject: any OSCKitCore.OSCObject) throws {
        try _send(oscObject, tag: tcpSocketTag)
    }
}

extension OSCTCPServerConnection: _OSCTCPServerProtocol {
    var queue: DispatchQueue {
        tcpSocket.delegateQueue ?? .global()
    }
    
    var timeTagMode: OSCTimeTagMode {
        get {
            delegate?.oscServer?.timeTagMode ?? .ignore
        }
        set {
            delegate?.oscServer?.timeTagMode = newValue
        }
    }
    
    var handler: OSCHandlerBlock? {
        get {
            delegate?.oscServer?.handler
        }
        set {
            delegate?.oscServer?.handler = newValue
        }
    }
}

#endif
