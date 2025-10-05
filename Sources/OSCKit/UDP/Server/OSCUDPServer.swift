//
//  OSCUDPServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation
import OSCKitCore

/// Receives OSC packets from the network on a specific UDP listen port.
///
/// A single global OSC server instance is often created once at app startup to receive OSC messages
/// on a specific local port. The default OSC port is 8000 but it may be set to any open port if
/// desired.
public final class OSCUDPServer {
    let udpSocket: GCDAsyncUdpSocket
    let udpDelegate = OSCUDPServerDelegate()
    let queue: DispatchQueue
    var receiveHandler: OSCHandlerBlock?
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// UDP port used by the OSC server to listen for inbound OSC packets.
    /// This may only be set at the time of initialization.
    public var localPort: UInt16 {
        udpSocket.localPort()
    }
    private var _localPort: UInt16?
    
    /// Network interface to restrict connections to.
    public private(set) var interface: String?
    
    /// Returns a boolean indicating whether the OSC server has been started.
    public private(set) var isStarted: Bool = false
    
    /// Initialize an OSC server.
    /// 
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    /// 
    /// > Note:
    /// >
    /// > Ensure ``start()`` is called once after initialization in order to begin receiving messages.
    ///
    /// - Parameters:
    ///   - port: Local port to listen on for inbound OSC packets.
    ///     If `nil` or `0`, a random available port in the system will be chosen.
    ///   - interface: Optionally specify a network interface for which to constrain communication.
    ///   - timeTagMode: OSC TimeTag mode. (Default is recommended.)
    ///   - queue: Optionally supply a custom dispatch queue for receiving OSC packets and dispatching the
    ///     handler callback closure. If `nil`, a dedicated internal background queue will be used.
    ///   - receiveHandler: Handler to call when OSC bundles or messages are received.
    public init(
        port: UInt16? = 8000,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil
    ) {
        _localPort = (port == nil || port == 0) ? nil : port
        self.interface = interface
        self.timeTagMode = timeTagMode
        let queue = queue ?? DispatchQueue(label: "com.orchetect.OSCKit.OSCUDPServer.queue")
        self.queue = queue
        self.receiveHandler = receiveHandler
        
        udpSocket = GCDAsyncUdpSocket(delegate: udpDelegate, delegateQueue: queue, socketQueue: nil)
        udpDelegate.oscServer = self
    }
}

extension OSCUDPServer: @unchecked Sendable { }

// MARK: - Lifecycle

extension OSCUDPServer {
    /// Bind the local UDP port and begin listening for OSC packets.
    public func start() throws {
        guard !isStarted else { return }
        
        stop()
        
        try udpSocket.bind(
            toPort: _localPort ?? 0, // 0 causes system to assign random open port
            interface: interface
        )
        try udpSocket.beginReceiving()
        
        isStarted = true
    }
    
    /// Stops listening for data and closes the OSC server port.
    public func stop() {
        udpSocket.close()
        
        isStarted = false
    }
}

// MARK: - Communication

extension OSCUDPServer: _OSCHandlerProtocol {
    // provides implementation for dispatching incoming OSC data
}

// MARK: - Properties

extension OSCUDPServer {
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
