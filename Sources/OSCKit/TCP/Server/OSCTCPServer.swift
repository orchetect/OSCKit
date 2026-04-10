//
//  OSCTCPServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation
import NIO

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
    var channel: (any Channel)?
    private var _clients: [OSCTCPClientSessionID: OSCTCPServer.ClientConnection] = [:]
    let queue: DispatchQueue
    var receiveHandler: OSCHandlerBlock?
    var notificationHandler: NotificationHandlerBlock?
    
    /// Notification handler closure.
    public typealias NotificationHandlerBlock = @Sendable (_ notification: Notification) -> Void
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// Local network port.
    public var localPort: UInt16 {
        channel?.localAddress?.port?.uInt16 ?? 0
    }

    private var _localPort: UInt16?
    
    /// Network interface to restrict connections to.
    public let interface: String?
    
    /// Returns a boolean indicating whether the OSC server has been started.
    public var isStarted: Bool {
        channel?.isActive ?? false
    }
    
    /// TCP packet framing mode.
    public let framingMode: OSCTCPFramingMode

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
        guard !isStarted else { return }
        
        let bootstrap = ServerBootstrap(group: .singletonMultiThreadedEventLoopGroup)
            .serverChannelOption(.socketOption(.so_reuseaddr), value: 1)
            .childChannelInitializer { channel in
                channel.eventLoop.makeCompletedFuture {
                    switch self.framingMode {
                    case .osc1_0:
                        try channel.pipeline.syncOperations.addHandler(ByteToMessageHandler(OSCTCPLengthHeaderFrameDecoder()))
                    case .osc1_1:
                        try channel.pipeline.syncOperations.addHandler(ByteToMessageHandler(OSCTCPSLIPFrameDecoder()))
                    }
                    try channel.pipeline.syncOperations.addHandler(OSCTCPServerChildChannelHandler(server: self))
                }
            }
        
        let host = interface ?? "0.0.0.0"
        channel = try bootstrap.bind(host: host, port: localPort.int).wait()
    }
    
    /// Closes any open client connections and stops listening for inbound connection requests.
    public func stop() {
        // disconnect all clients
        closeClients()
        
        // close server
        channel?.close().whenComplete { _ in }
        channel = nil
    }
}

// MARK: - Communication

extension OSCTCPServer: _OSCTCPSendProtocol {
    /// Send an OSC bundle or message to all connected clients.
    public func send(_ oscPacket: OSCPacket) throws {
        let clientIDs = Array(_clients.keys)
        
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
        guard let connection = _clients[clientID] else {
            throw OSCSocketError.clientNotFound(clientID)
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
    
    func _generateDisconnectedNotification(
        remoteHost: String,
        remotePort: UInt16,
        clientID: OSCTCPClientSessionID,
        error: (any Error)?
    ) {
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
        _clients
            .reduce(into: [:] as [OSCTCPClientSessionID: (host: String, port: UInt16)]) { base, element in
                base[element.key] = (
                    host: element.value.remoteHost,
                    port: element.value.remotePort
                )
            }
    }
    
    /// Disconnect a connected client from the server.
    public func disconnectClient(clientID: OSCTCPClientSessionID) {
        closeClient(clientID: clientID)
    }
}

// MARK: - Methods

extension OSCTCPServer {
    /// Close connections for any connected clients and remove them from the list of connected clients.
    func closeClients() {
        for clientID in _clients.keys {
            closeClient(clientID: clientID)
        }
    }
    
    func addClient(channel: any Channel) -> OSCTCPClientSessionID {
        let clientID = newClientID()
        let connection = ClientConnection(server: self, channel: channel, framingMode: framingMode)
        _clients[clientID] = connection
        
        return clientID
    }
    
    /// Generate a new client ID that is not currently in use by any connected client(s).
    private func newClientID() -> OSCTCPClientSessionID {
        var clientID: Int = 0
        while clientID == 0 || _clients.keys.contains(clientID) {
            // don't allow 0 or negative numbers
            clientID = Int.random(in: 1 ... Int.max)
        }
        assert(clientID > 0)
        return clientID
    }
    
    /// Close a connection and remove it from the list of connected clients.
    func closeClient(clientID: Int) {
        _clients[clientID]?.close()
        _clients[clientID] = nil
    }
}

#endif
