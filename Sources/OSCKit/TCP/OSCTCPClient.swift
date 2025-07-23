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
    ///   - handler: Handler to call when OSC bundles or messages are received.
    public init(
        remoteHost: String,
        remotePort: UInt16,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        framingMode: OSCTCPFramingMode = .osc1_1,
        queue: DispatchQueue? = nil,
        handler: OSCHandlerBlock? = nil
    ) {
        self.remoteHost = remoteHost
        self.remotePort = remotePort
        self.interface = interface
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
        try tcpSocket.connect(toHost: remoteHost, onPort: remotePort, viaInterface: interface, withTimeout: 10.0)
    }
    
    /// Close the connection, if any.
    public func close() {
        tcpSocket.disconnectAfterWriting()
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
