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
///
/// Use this class when a bidirectional TCP connection is desired to be made to a remote host.
///
/// A TCP connection is also generally more reliable than using the UDP protocol.
///
/// Since TCP is inherently a bidirectional network connection, both ``OSCTCPClient`` and ``OSCTCPServer`` can send and
/// receive once a connection is made. Messages sent by the server are only received by the client, and vice-versa.
///
/// What differentiates this client class from the server class is that the client class is designed to connect to a
/// remote TCP server. (Whereas, the server is designed to listen for inbound connections.)
public final class OSCTCPClient {
    let tcpSocket: GCDAsyncSocket
    let tcpDelegate: OSCTCPClientDelegate
    let queue: DispatchQueue
    let framingMode: OSCTCPFramingMode
    var receiveHandler: OSCHandlerBlock?
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// Remote network hostname.
    public let remoteHost: String
    
    /// Remote network port.
    public let remotePort: UInt16
    
    /// Network interface to restrict connections to.
    public let interface: String?
    
    /// Returns a boolean indicating whether the OSC socket is connected to the remote host.
    public var isConnected: Bool { tcpSocket.isConnected }
    
    /// Initialize with a remote hostname and UDP port.
    /// 
    /// > Note:
    /// >
    /// > Call ``connect()`` to connect to the remote host in order to begin sending messages.
    /// > The connection may be closed at any time by calling ``close()`` and then reconnected again as needed.
    ///
    /// - Parameters:
    ///   - remoteHost: Remote hostname or IP address.
    ///   - remotePort: Remote port number.
    ///   - interface: Optionally specify a network interface to restrict connections to.
    ///   - timeTagMode: OSC TimeTag mode. (Default is recommended.)
    ///   - framingMode: TCP framing mode. Both server and client must use the same framing mode. (Default is recommended.)
    ///   - queue: Optionally supply a custom dispatch queue for receiving OSC packets and dispatching the
    ///     handler callback closure. If `nil`, a dedicated internal background queue will be used.
    ///   - receiveHandler: Handler to call when OSC bundles or messages are received.
    public init(
        remoteHost: String,
        remotePort: UInt16,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        framingMode: OSCTCPFramingMode = .osc1_1,
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil
    ) {
        self.remoteHost = remoteHost
        self.remotePort = remotePort
        self.interface = interface
        self.timeTagMode = timeTagMode
        self.framingMode = framingMode
        let queue = queue ?? DispatchQueue(label: "com.orchetect.OSCKit.OSCTCPClient.queue")
        self.queue = queue
        self.receiveHandler = receiveHandler
        
        tcpDelegate = OSCTCPClientDelegate()
        tcpSocket = GCDAsyncSocket(delegate: tcpDelegate, delegateQueue: queue, socketQueue: nil)
        tcpDelegate.oscServer = self
    }
    
    deinit {
        close()
    }
}

extension OSCTCPClient: @unchecked Sendable { } // TODO: unchecked

// MARK: - Lifecycle

extension OSCTCPClient {
    /// Connects to the remote host.
    ///
    /// - Parameter timeout: Optionally supply a timeout period in seconds. Passing `nil` will not employ a timeout.
    public func connect(timeout: TimeInterval? = nil) throws {
        try tcpSocket.connect(
            toHost: remoteHost,
            onPort: remotePort,
            viaInterface: interface,
            withTimeout: timeout ?? -1 // default to no timeout if nil
        )
    }
    
    /// Close the connection, if any.
    public func close() {
        tcpSocket.disconnectAfterWriting()
    }
}

// MARK: - Communication

extension OSCTCPClient: _OSCTCPClientProtocol {
    /// Send an OSC bundle or message to the host.
    public func send(_ oscObject: any OSCObject) throws {
        try _send(oscObject, tag: 0)
    }
}

extension OSCTCPClient: _OSCTCPServerProtocol {
    // provides implementation for dispatching incoming OSC data
}

// MARK: - Properties

extension OSCTCPClient {
    /// Set the receive handler closure.
    /// This closure will be called when OSC bundles or messages are received.
    public func setReceiveHandler(
        _ handler: OSCHandlerBlock?
    ) {
        queue.async {
            self.receiveHandler = handler
        }
    }
}

#endif
