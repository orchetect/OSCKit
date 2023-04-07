//
//  OSCPeer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import CocoaAsyncSocket

/// Sends and receive OSC packets over the network with an individual remote host.
public final class OSCPeer: NSObject, _OSCServerProtocol {
    let udpSocket = GCDAsyncUdpSocket()
    let udpDelegate = OSCServerDelegate()
    let receiveQueue: DispatchQueue
    let dispatchQueue: DispatchQueue
    var handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)?
    
    /// Returns a boolean indicating whether the OSC peer server and client have been started.
    public private(set) var isStarted: Bool = false
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// Remote network hostname.
    public private(set) var host: String
    
    /// UDP port used by to receive OSC packets.
    public private(set) var localPort: UInt16
    
    private var _remotePort: UInt16?
    /// UDP port used by to send OSC packets.
    public var remotePort: UInt16 {
        get { _remotePort ?? localPort }
        set { _remotePort = newValue }
    }
    
    /// Initialize with a remote hostname and OSC port.
    /// If `localPort` is `nil`, a random available port in the system will be chosen.
    /// If `remotePort` is `nil`, the same port number as `localPort` will be used.
    public init(
        host: String,
        localPort: UInt16? = nil,
        remotePort: UInt16? = nil,
        receiveQueue: DispatchQueue = .main,
        dispatchQueue: DispatchQueue = .main,
        timeTagMode: OSCTimeTagMode = .ignore,
        handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)? = nil
    ) {
        self.host = host
        self.localPort = localPort ?? 0 // 0 causes system to assign random open port
        self._remotePort = remotePort
        self.timeTagMode = timeTagMode
        
        self.receiveQueue = receiveQueue
        self.dispatchQueue = dispatchQueue
        self.handler = handler
        
        super.init()
        
        udpDelegate.oscServer = self
        udpSocket.setDelegate(udpDelegate, delegateQueue: .main)
    }
    
    deinit {
        stop()
    }
    
    /// Set the handler closure. This closure will be called when OSC bundles or messages are
    /// received. The handler is called on the `dispatchQueue` queue specified at time of
    /// initialization.
    public func setHandler(
        _ handler: @escaping (_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void
    ) {
        self.handler = handler
    }
}

// MARK: - Lifecycle

extension OSCPeer {
    /// Bind the local OSC UDP port and begin listening for data.
    public func start() throws {
        guard !isStarted else { return }
        
        try udpSocket.enableReusePort(true)
        try udpSocket.enableBroadcast(true)
        try udpSocket.bind(toPort: localPort)
        
        // update local port if it changed or was assigned by system
        localPort = udpSocket.localPort()
        
        try udpSocket.beginReceiving()
        
        isStarted = true
    }
    
    /// Stops listening for data and closes the OSC port.
    public func stop() {
        udpSocket.close()
        
        isStarted = false
    }
    
    /// Send an OSC bundle or message to the remote peer.
    /// If ``remotePort`` is non-nil, it will be used as the destination port.
    /// Otherwise, the ``localPort`` number will be used.
    public func send(
        _ oscObject: any OSCObject
    ) throws {
        guard isStarted else {
            throw GCDAsyncUdpSocketError(
                .closedError,
                userInfo: ["Reason": "OSC Peer has not been started yet."]
            )
        }
        
        let data = try oscObject.rawData()
        
        udpSocket.send(
            data,
            toHost: host,
            port: remotePort,
            withTimeout: 1.0,
            tag: 0
        )
    }
}
