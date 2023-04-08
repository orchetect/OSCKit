//
//  OSCServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import CocoaAsyncSocket
import OSCKitCore

/// Receives OSC packets from the network on a specific UDP listen port.
///
/// > OSC 1.0 Spec:
/// >
/// > With regards OSC Bundle Time Tag:
/// >
/// > An OSC server must have access to a representation of the correct current absolute time. OSC
/// > does not provide any mechanism for clock synchronization. If the time represented by the OSC
/// > Time Tag is before or equal to the current time, the OSC Server should invoke the methods
/// > immediately. Otherwise the OSC Time Tag represents a time in the future, and the OSC server
/// > must store the OSC Bundle until the specified time and then invoke the appropriate OSC
/// > Methods. When bundles contain other bundles, the OSC Time Tag of the enclosed bundle must be
/// > greater than or equal to the OSC Time Tag of the enclosing bundle.
public final class OSCServer: NSObject, _OSCServerProtocol {
    let udpSocket = GCDAsyncUdpSocket()
    let udpDelegate = OSCServerUDPDelegate()
    let receiveQueue: DispatchQueue
    let dispatchQueue: DispatchQueue
    var handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)?
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCTimeTagMode
    
    /// UDP port used by the OSC server to listen for inbound OSC packets.
    /// This may only be set at the time of class initialization.
    public private(set) var localPort: UInt16
    
    /// Enable local UDP port reuse. This property must be set prior to calling ``start()`` in order
    /// to take effect.
    ///
    /// By default, only one socket can be bound to a given IP address + port at a time. To enable
    /// multiple processes to simultaneously bind to the same address + port, you need to enable
    /// this functionality in the socket. All processes that wish to use the address+port
    /// simultaneously must all enable reuse port on the socket bound to that port.
    public var isPortReuseEnabled: Bool = false
    
    /// Returns a boolean indicating whether the OSC server has been started.
    public private(set) var isStarted: Bool = false
    
    /// Initialize an OSC server.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    ///
    /// - Note: Ensure ``start()`` is called once in order to begin receiving messages.
    public init(
        port: UInt16 = 8000,
        receiveQueue: DispatchQueue = .main,
        dispatchQueue: DispatchQueue = .main,
        timeTagMode: OSCTimeTagMode = .ignore,
        handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)? = nil
    ) {
        self.localPort = port
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

extension OSCServer {
    /// Bind the local UDP port and begin listening for OSC packets.
    public func start() throws {
        guard !isStarted else { return }
        
        stop()
        
        try udpSocket.enableReusePort(isPortReuseEnabled)
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
