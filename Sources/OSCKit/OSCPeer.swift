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
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public private(set) var localPort: UInt16
    
    private var _remotePort: UInt16?
    /// UDP port used by to send OSC packets.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public var remotePort: UInt16 {
        get { _remotePort ?? localPort }
        set { _remotePort = newValue }
    }
    
    private var _isIPv4BroadcastEnabled: Bool = false
    /// Enable sending IPv4 broadcast messages from the socket.
    /// This may be set at any time, either before or after calling ``start()``.
    ///
    /// By default, the socket will not allow you to send broadcast messages as a network safeguard
    /// and it is an opt-in feature.
    ///
    /// A broadcast UDP message can be sent to a correctly formatted broadcast address. A broadcast
    /// address is the highest IP address for a subnet or a network.
    ///
    /// For example, a class C network with first octet `192`, one subnet, and subnet mask of
    /// `255.255.255.0` would have a broadcast address of `192.168.0.255` and would effectively send
    /// to `192.168.0.*` (where `*` is the range `1 ... 254`).
    ///
    /// 255.255.255.255 is a special broadcast address which targets all hosts on a local network.
    ///
    /// For more information on IPv4 broadcast addresses, see
    /// [Broadcast Address (Wikipedia)](https://en.wikipedia.org/wiki/Broadcast_address) and [Subnet
    /// Calculator](https://www.subnet-calculator.com).
    ///
    /// Internet Protocol version 6 (IPv6) does not implement this method of broadcast, and
    /// therefore does not define broadcast addresses. Instead, IPv6 uses multicast addressing.
    public var isIPv4BroadcastEnabled: Bool {
        get { _isIPv4BroadcastEnabled }
        set {
            _isIPv4BroadcastEnabled = newValue
            try? udpSocket.enableBroadcast(newValue)
        }
    }
    
    /// Initialize with a remote hostname and UDP port.
    /// If `localPort` is `nil`, a random available port in the system will be chosen.
    /// If `remotePort` is `nil`, the resulting `localPort` value will be used.
    ///
    /// - Note: Ensure ``start()`` is called once in order to begin sending and receiving messages.
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
        udpSocket.setDelegate(udpDelegate, delegateQueue: receiveQueue)
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
        try udpSocket.enableBroadcast(isIPv4BroadcastEnabled)
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
    /// If `port` is non-nil, it will be used as the destination port.
    /// Otherwise, the ``remotePort`` number will be used.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public func send(
        _ oscObject: any OSCObject,
        port: UInt16? = nil
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
            port: port ?? remotePort,
            withTimeout: 1.0,
            tag: 0
        )
    }
}
