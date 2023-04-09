//
//  OSCClient.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import CocoaAsyncSocket

/// Sends OSC packets over the network using the UDP network protocol.
///
/// A single global OSC client instance created once at app startup is often all that is needed. It
/// can be used to send OSC messages to one or more many receivers on the network.
public final class OSCClient: NSObject {
    private let udpSocket = GCDAsyncUdpSocket()
    private let udpDelegate = OSCClientUDPDelegate()
    
    private var _localPort: UInt16?
    /// Local UDP port used by the client to send OSC packets from. (This is not the remote port
    /// which is specified each time a call to ``send(_:to:port:)`` is made.)
    /// This may only be set at the time of class initialization.
    ///
    /// Note that if `localPort` was not specified at the time of initialization, reading this
    /// property may return a value of `0` until the first successful call to ``send(_:to:port:)``
    /// is made.
    public var localPort: UInt16 {
        udpSocket.localPort()
    }
    
    /// Enable local UDP port reuse. This property must be set prior to calling ``start()`` in order
    /// to take effect.
    ///
    /// By default, only one socket can be bound to a given IP address + port at a time. To enable
    /// multiple processes to simultaneously bind to the same address + port, you need to enable
    /// this functionality in the socket. All processes that wish to use the address+port
    /// simultaneously must all enable reuse port on the socket bound to that port.
    public var isPortReuseEnabled: Bool = false
    
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
    
    /// Returns a boolean indicating whether the OSC client has been started.
    public private(set) var isStarted: Bool = false
    
    /// Initialize an OSC client to send messages using the UDP network protocol.
    /// A random available port in the system will be chosen.
    /// Using this initializer does not require calling ``start()`` unless additional properties are
    /// modified such as ``isPortReuseEnabled`` or ``isIPv4BroadcastEnabled``.
    override public init() {
        super.init()
        
        // delegate needed for local port binding and enable broadcast
        udpSocket.setDelegate(udpDelegate, delegateQueue: .global())
    }
    
    /// Initialize an OSC client to send messages using the UDP network protocol.
    /// It is not recommended to bind to a local port unless there is a particular need to have
    /// control over which local port OSC messages originate from.
    /// To allow the system to assign a random available local port, use the ``init()`` initializer
    /// instead.
    public convenience init(
        localPort: UInt16
    ) {
        self.init()
        
        _localPort = localPort
    }
    
    deinit {
        stop()
    }
}

// MARK: - Lifecycle

extension OSCClient {
    /// Bind the local UDP port.
    /// This call is only necessary if a local port was specified at the time of class
    /// initialization or class properties were modified after initialization.
    public func start() throws {
        guard !isStarted else { return }
        
        stop()
        
        try udpSocket.enableReusePort(isPortReuseEnabled)
        try udpSocket.enableBroadcast(isIPv4BroadcastEnabled)
        try udpSocket.bind(toPort: _localPort ?? 0) // 0 causes system to assign random open port
        
        isStarted = true
    }
    
    /// Closes the OSC port.
    public func stop() {
        udpSocket.close()
        
        isStarted = false
    }
    
    /// Send an OSC bundle or message ad-hoc to a recipient on the network.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public func send(
        _ oscObject: any OSCObject,
        to host: String,
        port: UInt16 = 8000
    ) throws {
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

private final class OSCClientUDPDelegate: NSObject, GCDAsyncUdpSocketDelegate {
    // we don't care about handling any delegate methods here so none are overridden
}
