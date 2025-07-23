//
//  OSCTCPClient.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import OSCKitCore
import Foundation

/// Connects to a remote host via TCP connection in order to send and receive OSC packets over the network.
public final class OSCTCPClient {
    let tcpSocket: GCDAsyncSocket
    let tcpDelegate: OSCTCPClientDelegate
    let queue: DispatchQueue
    let framingMode: OSCTCPFramingMode
    var handler: OSCHandlerBlock?
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// Remote network hostname.
    public let remoteHost: String
    
    /// Remote network port.
    public let remotePort: UInt16
    
    /// Returns a boolean indicating whether the OSC socket is connected to the remote host.
    public var isConnected: Bool { tcpSocket.isConnected }
    
    /// Initialize with a remote hostname and UDP port.
    ///
    /// > Note:
    /// >
    /// > Call ``connect()`` to connect to the remote host in order to begin sending messages.
    /// > The connection may be closed at any time by calling ``close()`` and then reconnected again as needed.
    public init(
        remoteHost: String,
        remotePort: UInt16,
        timeTagMode: OSCTimeTagMode = .ignore,
        framingMode: OSCTCPFramingMode = .osc1_1,
        queue: DispatchQueue? = nil,
        handler: OSCHandlerBlock? = nil
    ) {
        self.remoteHost = remoteHost
        self.remotePort = remotePort
        self.timeTagMode = timeTagMode
        self.framingMode = framingMode
        let queue = queue ?? DispatchQueue(label: "com.orchetect.OSCKit.OSCTCPClient.queue")
        self.queue = queue
        self.handler = handler
        
        tcpDelegate = OSCTCPClientDelegate()
        tcpSocket = GCDAsyncSocket(delegate: tcpDelegate, delegateQueue: queue, socketQueue: nil)
        tcpDelegate.oscServer = self
    }
    
    deinit {
        close()
    }
}

// extension OSCTCPClient: @unchecked Sendable { } // TODO: make Sendable

// MARK: - Lifecycle

extension OSCTCPClient {
    /// Connects to the remote host.
    public func connect() throws {
        // TODO: allow specifying interface?
        try tcpSocket.connect(toHost: remoteHost, onPort: remotePort, withTimeout: 10.0)
    }
    
    /// Close the connection, if any.
    public func close() {
        tcpSocket.disconnectAfterReadingAndWriting()
    }
}

// MARK: - Communication

extension OSCTCPClient: _OSCTCPClientProtocol {
    public func send(_ oscObject: any OSCObject) throws {
        try _send(oscObject, tag: 0)
    }
}

extension OSCTCPClient: _OSCTCPServerProtocol {
    // provides implementation for dispatching incoming OSC data
}

// MARK: - Properties

extension OSCTCPClient {
    /// Set the handler closure. This closure will be called when OSC bundles or messages are
    /// received.
    public func setHandler(
        _ handler: OSCHandlerBlock?
    ) {
        queue.async {
            self.handler = handler
        }
    }
}

#endif
