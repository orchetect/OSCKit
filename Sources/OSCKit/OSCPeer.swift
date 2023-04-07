//
//  OSCPeer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import CocoaAsyncSocket

/// Sends and receive OSC packets over the network with an individual remote host and port.
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
    
    /// UDP port used by to send and receive OSC packets.
    public private(set) var port: UInt16
    
    /// Initialize with a remote hostname and OSC port.
    /// If port is passed as `nil`, a random available port in the system will be chosen.
    public init(
        host: String,
        port: UInt16?,
        receiveQueue: DispatchQueue = .main,
        dispatchQueue: DispatchQueue = .main,
        timeTagMode: OSCTimeTagMode = .ignore,
        handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)? = nil
    ) {
        self.host = host
        self.port = port ?? 0 // 0 causes system to assign random open port
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
        try udpSocket.bind(toPort: port)
        port = udpSocket.localPort() // update local port if it changed or was assigned by system
        try udpSocket.beginReceiving()
        
        isStarted = true
    }
    
    /// Stops listening for data and closes the OSC port.
    public func stop() {
        udpSocket.close()
        
        isStarted = false
    }
    
    /// Send an OSC bundle or message ad-hoc to the remote peer.
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
            port: port,
            withTimeout: 1.0,
            tag: 0
        )
    }
}
