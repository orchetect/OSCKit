//
//  OSCServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
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
public actor OSCServer: _OSCServerProtocol {
    let udpSocket: GCDAsyncUdpSocket
    let udpDelegate = OSCServerUDPDelegate()
    let receiveQueue = DispatchQueue(label: "org.orchetect.OSCKit.OSCServer.receiveQueue")
    var handler: OSCHandlerBlock?
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// UDP port used by the OSC server to listen for inbound OSC packets.
    /// This may only be set at the time of initialization.
    public private(set) var localPort: UInt16
    
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
    public init(
        port: UInt16 = 8000,
        timeTagMode: OSCTimeTagMode = .ignore,
        handler: OSCHandlerBlock? = nil
    ) {
        localPort = port
        self.timeTagMode = timeTagMode
        self.handler = handler
        
        udpSocket = GCDAsyncUdpSocket(delegate: udpDelegate, delegateQueue: receiveQueue)
        udpDelegate.oscServer = self
    }
    
    /// Set the handler closure. This closure will be called when OSC bundles or messages are
    /// received.
    public func setHandler(
        _ handler: OSCHandlerBlock?
    ) {
        self.handler = handler
    }
}

// MARK: - Lifecycle

extension OSCServer {
    /// Bind the local UDP port and begin listening for OSC packets.
    public func start() throws {
        guard !isStarted else { return }
        
        stop()
        
        try udpSocket.bind(toPort: localPort)
        try udpSocket.beginReceiving()
        
        isStarted = true
    }
    
    /// Stops listening for data and closes the OSC server port.
    public func stop() {
        udpSocket.close()
        
        isStarted = false
    }
}

#endif
