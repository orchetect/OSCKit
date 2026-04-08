//
//  OSCUDPClient.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin) && !os(watchOS)

import Foundation
import NIO

/// Sends OSC packets over the network using the UDP network protocol.
///
/// A single global OSC client instance created once at app startup is often all that is needed. It
/// can be used to send OSC messages to one or more receivers on the network.
public final class OSCUDPClient {
    private var channel: (any Channel)?
    
    /// Local UDP port used by the client from which to send OSC packets. (This is not the remote port
    /// which is specified each time a call to ``send(_:to:port:)-(OSCPacket,_,_)`` is made.)
    /// This may only be set at the time of initialization.
    ///
    /// > Note:
    /// >
    /// > If `localPort` was not specified at the time of initialization, reading this
    /// > property may return a value of `0` until the first successful call to ``send(_:to:port:)-(OSCPacket,_,_)``
    /// > is made.
    public var localPort: UInt16 {
        if let port = channel?.localAddress?.port {
            return UInt16(port)
        }
        return _localPort ?? 0
    }

    private var _localPort: UInt16?
    
    /// Network interface to restrict connections to.
    public private(set) var interface: String?
    
    /// Enable local UDP port reuse by other processes.
    /// This property must be set prior to calling ``start()`` in order to take effect.
    ///
    /// By default, only one socket can be bound to a given IP address & port combination at a time. To enable
    /// multiple processes to simultaneously bind to the same address & port, you need to enable
    /// this functionality in the socket. All processes that wish to use the address & port
    /// simultaneously must all enable reuse port on the socket bound to that port.
    public var isPortReuseEnabled: Bool = false
    
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
            let broadcast: ChannelOptions.Types.SocketOption.Value = newValue ? 1 : 0

            channel?.setOption(ChannelOptions.socketOption(.so_broadcast), value: broadcast).whenComplete { error in }
        }
    }

    private var _isIPv4BroadcastEnabled: Bool = false
    
    /// Returns a boolean indicating whether the OSC client has been started.
    public var isStarted: Bool {
        channel?.isActive ?? false
    }
    
    /// Initialize an OSC client to send messages using the UDP network protocol.
    ///
    /// A random available port in the system will be chosen.
    ///
    /// Using this initializer does not require calling ``start()``.
    public init() { }
    
    /// Initialize an OSC client to send messages using the UDP network protocol using a specific local port.
    ///
    /// > Note:
    /// >
    /// > Ensure ``start()`` is called once after initialization in order to begin sending messages.
    ///
    /// > Note:
    /// >
    /// > It is not typically necessary to bind to a static local port unless there is a particular need to have
    /// > control over which local port OSC messages originate from. In most cases, a randomly assigned port is
    /// > sufficient and prevents local port usage collisions.
    /// >
    /// > This may, however, be necessary in some cases where certain hardware devices expect to receive OSC from a
    /// > prescribed remote sender port number. In this case it is often more advantageous to use the combined
    /// > client/server ``OSCUDPSocket`` object instead, which is designed to make working with these kind round-trip
    /// > requirements more streamlined.
    /// >
    /// > To allow the system to assign a random available local port, use the ``init()`` initializer
    /// > instead.
    ///
    /// - Parameters:
    ///   - localPort: Local UDP port used by the client from which to send OSC packets.
    ///     If `nil` or `0`, a random available port in the system will be chosen.
    ///   - interface: Optionally specify a network interface for which to constrain communication.
    ///   - isPortReuseEnabled: Enable local UDP port reuse by other processes.
    ///   - isIPv4BroadcastEnabled: Enable sending IPv4 broadcast messages from the socket.
    public convenience init(
        localPort: UInt16?,
        interface: String? = nil,
        isPortReuseEnabled: Bool = false,
        isIPv4BroadcastEnabled: Bool = false
    ) {
        self.init()
        
        _localPort = (localPort == nil || localPort == 0) ? nil : localPort
        self.interface = interface
        self.isPortReuseEnabled = isPortReuseEnabled
        self.isIPv4BroadcastEnabled = isIPv4BroadcastEnabled
    }
    
    deinit {
        stop()
    }
}

extension OSCUDPClient: @unchecked Sendable { }

// MARK: - Lifecycle

extension OSCUDPClient {
    /// Bind the local UDP port.
    /// This call is only necessary if a local port was specified at the time of class
    /// initialization or if class properties were modified after initialization.
    public func start() throws {
        guard !isStarted else { return }
        
        stop()
        
        let reuseAddress: ChannelOptions.Types.SocketOption.Value = isPortReuseEnabled ? 1 : 0
        let broadcast: ChannelOptions.Types.SocketOption.Value = _isIPv4BroadcastEnabled ? 1 : 0
        let host: String = interface ?? "0.0.0.0"
        let port: Int = _localPort?.int ?? 0
        
        //Channel Setup
        channel = try DatagramBootstrap(group: .singletonMultiThreadedEventLoopGroup)
        //configure port reuse
            .channelOption(.socketOption(.so_reuseaddr), value: reuseAddress)
        //configure ipv4 broadcast
            .channelOption(.socketOption(.so_broadcast), value: broadcast)
        //initialize the channel
            .channelInitializer { channel in
                channel.eventLoop.makeSucceededVoidFuture()
            }
        //bin to host and port
            .bind(host: host, port: port)
        //wait for resolution of the `EventLoopFuture`
            .wait()
    }
    
    /// Closes the OSC port.
    public func stop() {
        //close channel -> opportunity for completion handler
        channel?.close().whenComplete { _ in }
        channel = nil
    }
}

// MARK: - Communication

extension OSCUDPClient {
    /// Send an OSC bundle or message ad-hoc to a recipient on the network.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public func send(
        _ oscPacket: OSCPacket,
        to host: String,
        port: UInt16 = 8000
    ) throws {
        let data = try oscPacket.rawData()
        
        guard let channel else { return /*TODO: throw clientNotStarted error*/}
        
        //resolve host and port to `SocketAddress`
        let remoteAddress = try SocketAddress.makeAddressResolvingHost(host, port: port.int)
        //create buffer from data
        let buffer: ByteBuffer = channel.allocator.buffer(bytes: data)

        let envelope = AddressedEnvelope(remoteAddress: remoteAddress, data: buffer)
        channel.writeAndFlush(envelope, promise: nil)
    }
    
    /// Send an OSC bundle ad-hoc to a recipient on the network.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public func send(
        _ oscBundle: OSCBundle,
        to host: String,
        port: UInt16 = 8000
    ) throws {
        try send(.bundle(oscBundle), to: host, port: port)
    }
    
    /// Send an OSC message ad-hoc to a recipient on the network.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public func send(
        _ oscMessage: OSCMessage,
        to host: String,
        port: UInt16 = 8000
    ) throws {
        try send(.message(oscMessage), to: host, port: port)
    }
}

#endif
