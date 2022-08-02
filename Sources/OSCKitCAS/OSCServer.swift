//
//  OSCServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import CocoaAsyncSocket

/// OSC Server.
/// Receive OSC packets using CocoaAsyncSocket as the backing network I/O layer.
public class OSCServer: NSObject {
    private let udpServer = GCDAsyncUdpSocket()
    private let udpDelegate = OSCServerDelegate()
    
    private let queue: DispatchQueue
    
    public private(set) var port: UInt16
    
    public init(
        port: UInt16 = 8000,
        queue: DispatchQueue? = nil,
        handler: ((OSCMessage) -> Void)? = nil
    ) {
        self.port = port
        self.queue = queue ?? DispatchQueue(
            label: "OSCServer",
            qos: .userInitiated
        )
        self.udpDelegate.handler = handler
        
        super.init()
        
        udpServer.setDelegateQueue(self.queue)
        udpServer.setDelegate(udpDelegate)
    }
    
    deinit {
        stop()
    }
    
    public func setHandler(_ handler: @escaping (OSCMessage) -> Void) {
        self.udpDelegate.handler = handler
    }
}

// MARK: - Lifecycle

extension OSCServer {
    /// Bind the OSC server's local UDP port and begin listening for data.
    public func start() throws {
        stop()
        
        try udpServer.bind(toPort: port)
        try udpServer.enableReusePort(true)
        try udpServer.beginReceiving()
    }
    
    /// Stops listening for data and closes the OSC server port.
    public func stop() {
        udpServer.close()
    }
}

// MARK: - Internal

private class OSCServerDelegate: NSObject, GCDAsyncUdpSocketDelegate {
    var handler: ((OSCMessage) -> Void)?
    
    /// CocoaAsyncSocket receive delegate method implementation.
    func udpSocket(
        _ sock: GCDAsyncUdpSocket,
        didReceive data: Data,
        fromAddress address: Data,
        withFilterContext filterContext: Any?
    ) {
        guard let oscPayload = try? data.parseOSC() else { return }
        try? handle(oscPayload: oscPayload)
    }
    
    /// Handle incoming OSC data recursively.
    func handle(oscPayload: OSCPayload) throws {
        switch oscPayload {
        case let .bundle(bundle):
            // recursively handle nested bundles and messages
            try bundle.elements.forEach {
                try handle(oscPayload: $0)
            }
            
        case let .message(message):
            // handle message
            handler?(message)
        }
    }
}
