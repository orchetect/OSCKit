//
//  OSCPeer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import CocoaAsyncSocket

/// Sends and receive OSC packets over the network to and from a specific remote host and port.
/// This class allows broadcast and port reuse.
public final class OSCPeer: NSObject {
    private let udpClient = GCDAsyncUdpSocket()
    private let udpDelegate = UDPDelegate()
    
    private let oscServer: OSCServer
    
    /// Returns a boolean indicating whether the OSC peer server and client have been started.
    public private(set) var isStarted: Bool = false
    
    /// Time tag mode. Determines how OSC bundle time tags are handled.
    public var timeTagMode: OSCServer.TimeTagMode {
        get { oscServer.timeTagMode }
        set { oscServer.timeTagMode = newValue }
    }
    
    /// Remote network hostname.
    public private(set) var host: String
    
    /// UDP port used by to send and receive OSC packets.
    public private(set) var port: UInt16
    
    /// Initialize with a remote hostname and OSC port.
    public init(
        host: String,
        port: UInt16,
        receiveQueue: DispatchQueue? = nil,
        dispatchQueue: DispatchQueue = .main,
        timeTagMode: OSCServer.TimeTagMode = .ignore,
        handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)? = nil
    ) {
        self.host = host
        self.port = port
        
        oscServer = OSCServer(
            port: port,
            receiveQueue: receiveQueue,
            dispatchQueue: dispatchQueue,
            timeTagMode: timeTagMode,
            handler: handler
        )
        
        super.init()
        
        udpClient.setDelegate(udpDelegate, delegateQueue: .main)
    }
    
    deinit {
        udpClient.close()
        oscServer.stop()
    }
    
    /// Set the handler closure. This closure will be called when OSC bundles or messages are received. The handler is called on the `dispatchQueue` queue specified at time of initialization.
    public func setHandler(
        _ handler: @escaping (_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void
    ) {
        oscServer.handler = handler
    }
}

// MARK: - Lifecycle

extension OSCPeer {
    /// Bind the local OSC UDP port and begin listening for data.
    public func start() throws {
        guard !isStarted else { return }
        
        // server
        try oscServer.start()
        
        // client
        try udpClient.enableReusePort(true)
        try udpClient.enableBroadcast(true)
        try udpClient.bind(toPort: port)
        
        isStarted = true
    }
    
    public func stop() {
        // server
        oscServer.stop()
        
        // client
        udpClient.close()
        
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
        
        udpClient.send(
            data,
            toHost: host,
            port: port,
            withTimeout: 1.0,
            tag: 0
        )
    }
}

internal final class UDPDelegate: NSObject, GCDAsyncUdpSocketDelegate {
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        #if DEBUG
        print("didConnectToAddress", address.description)
        #endif
    }
    
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        #if DEBUG
        print("didNotConnect, ", error != nil ? "error: \(error!)" : "no error")
        #endif
    }
    
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        #if DEBUG
        print("didSendDataWithTag tag: \(tag)")
        #endif
    }
    
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        #if DEBUG
        print("didNotSendDataWithTag tag: \(tag),", error != nil ? "error: \(error!)" : "no error")
        #endif
    }
    
    internal func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        #if DEBUG
        print("didReceive", data, "from addr \(address)", "with filter \(filterContext as Any)")
        #endif
    }
    
    internal func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
        #if DEBUG
        print("socket closed,", error != nil ? "error: \(error!)" : "no error")
        #endif
    }
}
