//
//  OSCUDPServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin) && !os(watchOS)

import Foundation
import NIO

/// Receives OSC packets from the network on a specific UDP listen port.
///
/// A single global OSC server instance is often created once at app startup to receive OSC messages
/// on a specific local port. The default OSC port is 8000 but it may be set to any open port if
/// desired.
public final class OSCUDPServer {
    private var channel: (any Channel)?
    let queue: DispatchQueue
    var receiveHandler: OSCHandlerBlock?
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// UDP port used by the OSC server to listen for inbound OSC packets.
    /// This may only be set at the time of initialization.
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
    ///
    /// Due to limitations of `SO_REUSEPORT` on Apple platforms, enabling this only permits receipt of broadcast
    /// or multicast messages for any additional sockets which bind to the same address and port. Unicast
    /// messages are only received by the first socket to bind.
    public var isPortReuseEnabled: Bool = false
    
    /// Returns a boolean indicating whether the OSC server has been started.
    public var isStarted: Bool {
        channel?.isActive ?? false
    }
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
    ///   - isPortReuseEnabled: Enable local UDP port reuse by other processes to receive broadcast packets.
    ///   - timeTagMode: OSC TimeTag mode. (Default is recommended.)
    ///   - queue: Optionally supply a custom dispatch queue for receiving OSC packets and dispatching the
    ///     handler callback closure. If `nil`, a dedicated internal background queue will be used.
    ///   - receiveHandler: Handler to call when OSC bundles or messages are received.
    public init(
        port: UInt16? = 8000,
        interface: String? = nil,
        isPortReuseEnabled: Bool = false,
        timeTagMode: OSCTimeTagMode = .ignore,
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil
    ) {
        _localPort = (port == nil || port == 0) ? nil : port
        self.interface = interface
        self.isPortReuseEnabled = isPortReuseEnabled
        self.timeTagMode = timeTagMode
        let queue = queue ?? DispatchQueue(label: "com.orchetect.OSCKit.OSCUDPServer.queue")
        self.queue = queue
        self.receiveHandler = receiveHandler
    }
}

extension OSCUDPServer: @unchecked Sendable { }

// MARK: - Lifecycle

extension OSCUDPServer {
    /// Bind the local UDP port and begin listening for OSC packets.
    public func start() throws {
        guard !isStarted else { return }
        
        stop()
        
        let handler = _OSCUDPChannelHandler(oscServer: self)
        let host: String = interface ?? "0.0.0.0"
        let port: Int = _localPort?.int ?? 0
        
        let reuseAddress: ChannelOptions.Types.SocketOption.Value = isPortReuseEnabled ? 1 : 0
        channel = try DatagramBootstrap(group: .singletonMultiThreadedEventLoopGroup)
            .channelOption(.socketOption(.so_reuseaddr), value: reuseAddress)
            .channelInitializer { channel in
                channel.pipeline.addHandler(handler)
            }
            .bind(host: host, port: port)
            .wait()
    }
    
    /// Stops listening for data and closes the OSC server port.
    public func stop() {
        channel?.close().whenComplete { _ in }
        channel = nil
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
