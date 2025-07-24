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
///
/// Use this class when you are taking the role of the host and one or more remote clients will want to connect via
/// bidirectional TCP connection.
///
/// A TCP connection is also generally more reliable than using the UDP protocol.
///
/// Since TCP is inherently a bidirectional network connection, both ``OSCTCPClient`` and ``OSCTCPServer`` can send and
/// receive once a connection is made. Messages sent by the server are only received by the client, and vice-versa.
///
/// What differentiates this server class from the client class is that the server is designed to listen for inbound
/// connections. (Whereas, the client class is designed to connect to a remote TCP server.)
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
    
    /// Network interface to restrict connections to.
    public let interface: String?
    
    /// Initialize with a remote hostname and UDP port.
    /// 
    /// > Note:
    /// >
    /// > Call ``start()`` to begin listening for connections.
    /// > The connection may be closed at any time by calling ``stop()`` and then restarted again as needed.
    ///
    /// - Parameters:
    ///   - port: Local network port to listen for inbound connections.
    ///   - interface: Optionally specify a network interface to restrict connections to.
    ///   - timeTagMode: OSC TimeTag mode. Default is recommended.
    ///   - framingMode: TCP framing mode. Both server and client must use the same framing mode. (Default is recommended.)
    ///   - queue: Optionally supply a custom dispatch queue for receiving OSC packets and dispatching the
    ///     handler callback closure. If `nil`, a dedicated internal background queue will be used.
    ///   - handler: Handler to call when OSC bundles or messages are received.
    public init(
        port: UInt16,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        framingMode: OSCTCPFramingMode = .osc1_1,
        queue: DispatchQueue? = nil,
        handler: OSCHandlerBlock? = nil
    ) {
        self.localPort = port
        self.interface = interface
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

extension OSCTCPServer: @unchecked Sendable { } // TODO: unchecked

// MARK: - Lifecycle

extension OSCTCPServer {
    /// Starts listening for inbound connections.
    public func start() throws {
        try tcpSocket.accept(onInterface: interface, port: localPort)
        
        // update local port in case port 0 was passed and the system assigned a new port
        localPort = tcpSocket.localPort
    }
    
    /// Close the connection, if any, and stop listening for inbound connections.
    public func stop() {
        // disconnect clients
        tcpDelegate.closeClients()
        
        // close server
        tcpSocket.disconnectAfterWriting()
    }
}

// MARK: - Communication

extension OSCTCPServer: _OSCTCPClientProtocol {
    /// Send an OSC bundle or message to all connected clients.
    public func send(_ oscObject: any OSCObject) throws {
        let clientIDs = Array(tcpDelegate.clients.keys)
        
        try send(oscObject, toClientIDs: clientIDs)
    }
    
    /// Send an OSC bundle or message to one or more connected clients.
    public func send(_ oscObject: any OSCObject, toClientIDs clientIDs: [Int]) throws {
        for clientID in clientIDs {
            try _send(oscObject, toClientID: clientID)
        }
    }
    
    /// Send an OSC bundle or message to an individual connected client.
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
    /// Set the receive handler closure.
    /// This closure will be called when OSC bundles or messages are received.
    public func setHandler(
        _ handler: OSCHandlerBlock?
    ) {
        queue.async {
            self.handler = handler
        }
    }
    
    /// Returns a dictionary of currently connected clients keyed by client session ID.
    ///
    /// > Note:
    /// >
    /// > A client ID is transient and only valid for the lifecycle of the connection. Client IDs are randomly-assigned
    /// > upon each newly-made connection. For this reason, these IDs should not be stored, but instead queried from the
    /// > OSC TCP server at the time of requiring to use an ID.
    public var clients: [OSCTCPClientSessionID: (host: String, port: UInt16)] {
        tcpDelegate.clients
            .reduce(into: [:] as [OSCTCPClientSessionID: (host: String, port: UInt16)]) { base, element in
                base[element.key] = (
                    host: element.value.tcpSocket.connectedHost ?? "",
                    port: element.value.tcpSocket.connectedPort
                )
            }
    }
}

#endif
