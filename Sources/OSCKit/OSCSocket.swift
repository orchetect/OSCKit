//
//  OSCSocket.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import CocoaAsyncSocket

/// Sends and receives OSC packets over the network by binding a single local UDP port to both send
/// OSC packets from and listen for incoming packets.
///
/// The `OSCSocket` class internally combines both an OSC server and client sharing the same local
/// UDP port number. What sets it apart from ``OSCServer`` and ``OSCClient`` is that it does not
/// require enabling port reuse to accomplish this. It also can conceptually make communicating
/// bidirectionally with a single remote host more intuitive.
///
/// This also fulfils a niche requirement for communicating with OSC devices such as the Behringer
/// X32 & M32 which respond back using the UDP port that they receive OSC messages from. For
/// example: if an OSC message was sent from port 8000 to the X32's port 10023, the X32 will respond
/// by sending OSC messages back to you on port 8000.
public final class OSCSocket: NSObject, _OSCServerProtocol {
    let udpSocket = GCDAsyncUdpSocket()
    let udpDelegate = OSCServerUDPDelegate()
    let receiveQueue: DispatchQueue
    let dispatchQueue: DispatchQueue
    var handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)?
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// Remote network hostname.
    /// If non-nil, this host will be used in calls to ``send(_:to:port:)``. The host may still be
    /// overridden using the `host` parameter in the call to ``send(_:to:port:)``..
    public var remoteHost: String?
    
    private var _localPort: UInt16?
    /// Local UDP port used to both send OSC packets from and listen for incoming packets.
    /// This may only be set at the time of class initialization.
    ///
    /// Note that if `localPort` was not specified at the time of initialization, reading this
    /// property may return a value of `0` until the first successful call to ``send(_:to:port:)`` is
    /// made.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public var localPort: UInt16 {
        udpSocket.localPort()
    }
    
    private var _remotePort: UInt16?
    /// UDP port used by to send OSC packets. This may be set at any time.
    /// This port will be used in calls to ``send(_:to:port:)``. The port may still be overridden
    /// using the `port` parameter in the call to ``send(_:to:port:)``.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public var remotePort: UInt16 {
        get { _remotePort ?? localPort }
        set { _remotePort = newValue }
    }
    
    private var _isIPv4BroadcastEnabled: Bool = false
    /// Enable sending IPv4 broadcast messages from the socket.
    /// This may be set at any time.
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
    
    /// Enable local UDP port reuse. This property must be set prior to calling ``start()`` in order
    /// to take effect.
    ///
    /// By default, only one socket can be bound to a given IP address + port at a time. To enable
    /// multiple processes to simultaneously bind to the same address + port, you need to enable
    /// this functionality in the socket. All processes that wish to use the address+port
    /// simultaneously must all enable reuse port on the socket bound to that port.
    public var isPortReuseEnabled: Bool = false
    
    /// Returns a boolean indicating whether the OSC socket has been started.
    public private(set) var isStarted: Bool = false
    
    /// Initialize with a remote hostname and UDP port.
    /// If `localPort` is `nil`, a random available port in the system will be chosen.
    /// If `remotePort` is `nil`, the resulting `localPort` value will be used.
    ///
    /// - Note: Ensure ``start()`` is called once in order to begin sending and receiving messages.
    public init(
        localPort: UInt16? = nil,
        remoteHost: String? = nil,
        remotePort: UInt16? = nil,
        receiveQueue: DispatchQueue = .main,
        dispatchQueue: DispatchQueue = .main,
        timeTagMode: OSCTimeTagMode = .ignore,
        handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)? = nil
    ) {
        self.remoteHost = remoteHost
        self._localPort = localPort
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

extension OSCSocket {
    /// Bind the local UDP port and begin listening for OSC packets.
    public func start() throws {
        guard !isStarted else { return }
        
        try udpSocket.enableReusePort(isPortReuseEnabled)
        try udpSocket.enableBroadcast(isIPv4BroadcastEnabled)
        try udpSocket.bind(toPort: _localPort ?? 0) // 0 causes system to assign random open port
        try udpSocket.beginReceiving()
        
        isStarted = true
    }
    
    /// Stops listening for data and closes the OSC port.
    public func stop() {
        udpSocket.close()
        
        isStarted = false
    }
    
    /// Send an OSC bundle or message to the remote host.
    /// ``remoteHost`` and ``remotePort`` class properties are used unless one or both are
    /// overridden in this call.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public func send(
        _ oscObject: any OSCObject,
        to host: String? = nil,
        port: UInt16? = nil
    ) throws {
        guard isStarted else {
            throw GCDAsyncUdpSocketError(
                .closedError,
                userInfo: ["Reason": "OSC socket has not been started yet."]
            )
        }
        
        guard let toHost = host ?? remoteHost else {
            throw GCDAsyncUdpSocketError(
                .closedError,
                userInfo: [
                    "Reason":
                        "Remote host is not specified in either class remoteHost property or in host parameter of call to send()."
                ]
            )
        }
        
        let data = try oscObject.rawData()
        
        udpSocket.send(
            data,
            toHost: toHost,
            port: port ?? remotePort,
            withTimeout: 1.0,
            tag: 0
        )
    }
}
