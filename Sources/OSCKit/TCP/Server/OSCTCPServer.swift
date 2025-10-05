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
    var receiveHandler: OSCHandlerBlock?
    var notificationHandler: NotificationHandlerBlock?
    
    /// Notification handler closure.
    public typealias NotificationHandlerBlock = @Sendable (_ notification: Notification) -> Void
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// Local network port.
    public var localPort: UInt16 {
        tcpSocket.localPort
    }
    private var _localPort: UInt16?
    
    /// Network interface to restrict connections to.
    public let interface: String?
    
    /// Initialize with a remote hostname and UDP port.
    /// 
    /// > Note:
    /// >
    /// > Call ``start()`` to begin listening for connections.
    /// > The connections may be closed at any time by calling ``stop()`` and then restarted again as needed.
    ///
    /// - Parameters:
    ///   - port: Local network port to listen for inbound connections.
    ///     If `nil` or `0`, a random available port in the system will be chosen.
    ///   - interface: Optionally specify a network interface for which to constrain connections.
    ///   - timeTagMode: OSC TimeTag mode. Default is recommended.
    ///   - framingMode: TCP framing mode. Both server and client must use the same framing mode. (Default is recommended.)
    ///   - queue: Optionally supply a custom dispatch queue for receiving OSC packets and dispatching the
    ///     handler callback closure. If `nil`, a dedicated internal background queue will be used.
    ///   - receiveHandler: Handler to call when OSC bundles or messages are received.
    public init(
        port: UInt16?,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        framingMode: OSCTCPFramingMode = .osc1_1,
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil
    ) {
        _localPort = (port == nil || port == 0) ? nil : port
        self.interface = interface
        self.timeTagMode = timeTagMode
        self.framingMode = framingMode
        let queue = queue ?? DispatchQueue(label: "com.orchetect.OSCKit.OSCTCPServer.queue")
        self.queue = queue
        self.receiveHandler = receiveHandler
        
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
        try tcpSocket.accept(
            onInterface: interface,
            port: _localPort ?? 0 // 0 causes system to assign random open port
        )
    }
    
    /// Closes any open client connections and stops listening for inbound connection requests.
    public func stop() {
        // disconnect all clients
        tcpDelegate.closeClients()
        
        // close server
        tcpSocket.disconnectAfterWriting()
    }
}

// MARK: - Communication

extension OSCTCPServer: _OSCTCPSendProtocol {
    /// Send an OSC bundle or message to all connected clients.
    public func send(_ oscPacket: OSCPacket) throws {
        let clientIDs = Array(tcpDelegate.clients.keys)
        
        try send(oscPacket, toClientIDs: clientIDs)
    }
    
    /// Send an OSC bundle to all connected clients.
    public func send(_ oscBundle: OSCBundle) throws {
        try send(.bundle(oscBundle))
    }
    
    /// Send an OSC message to all connected clients.
    public func send(_ oscMessage: OSCMessage) throws {
        try send(.message(oscMessage))
    }
    
    /// Send an OSC bundle or message to one or more connected clients.
    public func send(_ oscPacket: OSCPacket, toClientIDs clientIDs: [Int]) throws {
        for clientID in clientIDs {
            try _send(oscPacket, toClientID: clientID)
        }
    }
    
    /// Send an OSC bundle to one or more connected clients.
    public func send(_ oscBundle: OSCBundle, toClientIDs clientIDs: [Int]) throws {
        try send(.bundle(oscBundle), toClientIDs: clientIDs)
    }
    
    /// Send an OSC message to one or more connected clients.
    public func send(_ oscMessage: OSCMessage, toClientIDs clientIDs: [Int]) throws {
        try send(.message(oscMessage), toClientIDs: clientIDs)
    }
    
    /// Send an OSC bundle or message to an individual connected client.
    func _send(_ oscPacket: OSCPacket, toClientID clientID: Int) throws {
        guard let connection = tcpDelegate.clients[clientID] else {
            throw GCDAsyncUdpSocketError(
                .badParamError,
                userInfo: ["Reason": "OSC TCP client socket with ID \(clientID) not found (not connected)."]
            )
        }
        
        try connection.send(oscPacket)
    }
    
    /// Send an OSC bundle to an individual connected client.
    func _send(_ oscBundle: OSCBundle, toClientID clientID: Int) throws {
        try _send(.bundle(oscBundle), toClientID: clientID)
    }
    
    /// Send an OSC message to an individual connected client.
    func _send(_ oscMessage: OSCMessage, toClientID clientID: Int) throws {
        try _send(.message(oscMessage), toClientID: clientID)
    }
}

extension OSCTCPServer: _OSCTCPHandlerProtocol {
    // provides implementation for dispatching incoming OSC data
}

extension OSCTCPServer: _OSCTCPGeneratesServerNotificationsProtocol {
    func _generateConnectedNotification(remoteHost: String, remotePort: UInt16, clientID: OSCTCPClientSessionID) {
        let notif: Notification = .connected(remoteHost: remoteHost, remotePort: remotePort, clientID: clientID)
        notificationHandler?(notif)
    }
    
    func _generateDisconnectedNotification(remoteHost: String, remotePort: UInt16, clientID: OSCTCPClientSessionID, error: GCDAsyncSocketError?) {
        let notif: Notification = .disconnected(remoteHost: remoteHost, remotePort: remotePort, clientID: clientID, error: error)
        notificationHandler?(notif)
    }
}

// MARK: - Properties

extension OSCTCPServer {
    /// Set the receive handler closure.
    /// This closure will be called when OSC bundles or messages are received.
    public func setReceiveHandler(
        _ handler: OSCHandlerBlock?
    ) {
        queue.async {
            self.receiveHandler = handler
        }
    }
    
    /// Set the notification handler closure.
    /// This closure will be called when a notification is generated, such as connection and disconnection events.
    public func setNotificationHandler(
        _ handler: NotificationHandlerBlock?
    ) {
        queue.async {
            self.notificationHandler = handler
        }
    }
    
    /// Returns a dictionary of currently connected clients keyed by client session ID.
    ///
    /// > Note:
    /// >
    /// > A client ID is transient and only valid for the lifecycle of the connection. Client IDs are randomly-assigned
    /// > upon each newly-made connection. For this reason, these IDs should not be stored persistently, but instead
    /// > queried from the OSC TCP server when a client connects or analyzing currently-connected clients.
    public var clients: [OSCTCPClientSessionID: (host: String, port: UInt16)] {
        tcpDelegate.clients
            .reduce(into: [:] as [OSCTCPClientSessionID: (host: String, port: UInt16)]) { base, element in
                base[element.key] = (
                    host: element.value.remoteHost,
                    port: element.value.remotePort
                )
            }
    }
    
    /// Disconnect a connected client from the server.
    public func disconnectClient(clientID: OSCTCPClientSessionID) {
        tcpDelegate.closeClient(clientID: clientID)
    }
}

#endif
