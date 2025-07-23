//
//  OSCTCPServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import OSCKitCore
import Foundation

/// Listens on a local port for TCP connections in order to send and receive OSC packets over the network.
public final class OSCTCPServer {
    let tcpSocket: GCDAsyncSocket
    let tcpDelegate: OSCTCPServerDelegate
    let queue: DispatchQueue
    let framingMode: OSCTCPFramingMode
    var handler: OSCHandlerBlock?
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// Local network port.
    public private(set) var localPort: UInt16
    
    /// Initialize with a remote hostname and UDP port.
    ///
    /// > Note:
    /// >
    /// > Call ``start()`` to begin listening for connections.
    /// > The connection may be closed at any time by calling ``stop()`` and then restarted again as needed.
    public init(
        localPort: UInt16,
        timeTagMode: OSCTimeTagMode = .ignore,
        framingMode: OSCTCPFramingMode = .osc1_1,
        queue: DispatchQueue? = nil,
        handler: OSCHandlerBlock? = nil
    ) {
        self.localPort = localPort
        self.timeTagMode = timeTagMode
        self.framingMode = framingMode
        let queue = queue ?? DispatchQueue(label: "com.orchetect.OSCKit.OSCTCPServer.queue")
        self.queue = queue
        self.handler = handler
        
        tcpDelegate = OSCTCPServerDelegate(framingMode: framingMode)
        tcpSocket = GCDAsyncSocket(delegate: tcpDelegate, delegateQueue: queue, socketQueue: nil)
        tcpDelegate.oscServer = self
    }
    
    deinit {
        stop()
    }
}

// extension OSCTCPServer: @unchecked Sendable { } // TODO: make Sendable

// MARK: - Lifecycle

extension OSCTCPServer {
    /// Starts listening for inbound connections.
    public func start() throws {
        // TODO: allow specifying interface?
        try tcpSocket.accept(onInterface: nil, port: localPort)
        
        // update local port in case port 0 was passed and the system assigned a new port
        localPort = tcpSocket.localPort
    }
    
    /// Close the connection, if any, and stop listening for inbound connections.
    public func stop() {
        // disconnect clients
        tcpDelegate.closeClients()
        
        // close server
        tcpSocket.disconnectAfterReadingAndWriting()
    }
}

// MARK: - Communication

extension OSCTCPServer: _OSCTCPClientProtocol {
    /// Send an OSC packet to all connected clients.
    public func send(_ oscObject: any OSCObject) throws {
        let clientIDs = Array(tcpDelegate.clients.keys)
        
        try send(oscObject, toClientIDs: clientIDs)
    }
    
    /// Send an OSC packet to one or more connected clients.
    public func send(_ oscObject: any OSCObject, toClientIDs clientIDs: [Int]) throws {
        for clientID in clientIDs {
            try _send(oscObject, toClientID: clientID)
        }
    }
    
    /// Send an OSC packet to an individual connected client.
    func _send(_ oscObject: any OSCObject, toClientID clientID: Int) throws {
        guard let connection = tcpDelegate.clients[clientID] else {
            throw GCDAsyncUdpSocketError(
                .badParamError,
                userInfo: ["Reason": "OSC TCP client socket with ID \(clientID) not found (not connected)."]
            )
        }
        
        try connection.send(oscObject)
    }
}

extension OSCTCPServer: _OSCTCPServerProtocol {
    // provides implementation for dispatching incoming OSC data
}

// MARK: - Properties

extension OSCTCPServer {
    /// Set the handler closure. This closure will be called when OSC bundles or messages are
    /// received.
    public func setHandler(
        _ handler: OSCHandlerBlock?
    ) {
        queue.async {
            self.handler = handler
        }
    }
    
    /// Returns a dictionary of currently connected clients keyed by client ID.
    ///
    /// Note that this ID is transient and is randomly-assigned upon each new connection.
    public var clients: [Int: (hostname: String, port: UInt16)] {
        tcpDelegate.clients
            .reduce(into: [:] as [Int: (hostname: String, port: UInt16)]) { base, element in
            base[element.key] = (
                hostname: element.value.tcpSocket.connectedHost ?? "",
                port: element.value.tcpSocket.connectedPort
            )
        }
    }
}

#endif
