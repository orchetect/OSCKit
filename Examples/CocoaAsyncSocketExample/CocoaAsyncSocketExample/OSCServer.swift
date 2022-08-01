//
//  OSCServer.swift
//  CocoaAsyncSocketExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import OSCKit
import CocoaAsyncSocket

final public class OSCServer: NSObject {
    private let udpServer = GCDAsyncUdpSocket()
    public private(set) var port: UInt16
    private var handler: ((OSCMessage) -> Void)?
    
    public init(
        port: UInt16 = 8000,
        queue: DispatchQueue = .global(),
        handler: ((OSCMessage) -> Void)? = nil
    ) {
        self.port = port
        
        self.handler = handler
        super.init()
        
        udpServer.setDelegate(self)
        udpServer.setDelegateQueue(queue)
    }
    
    deinit {
        stop()
    }
    
    public func setHandler(_ handler: @escaping (OSCMessage) -> Void) {
        self.handler = handler
    }
}

// MARK: - Lifecycle

extension OSCServer {
    /// Attempts to bind the OSC server port and begin listening for data.
    /// Uses the UDP port set at class init unless `port` is overridden here.
    public func start(port: UInt16? = nil) throws {
        if let port = port {
            // update stored port with new port
            self.port = port
        }
        let localPort = port ?? self.port
        
        stop()
        
        try udpServer.bind(toPort: localPort)
        try udpServer.beginReceiving()
    }
    
    /// Stops listening for data and closes the OSC server port.
    public func stop() {
        udpServer.close()
    }
}

// MARK: - Receive

extension OSCServer: GCDAsyncUdpSocketDelegate {
    /// CocoaAsyncSocket receive delegate method implementation.
    public func udpSocket(
        _ sock: GCDAsyncUdpSocket,
        didReceive data: Data,
        fromAddress address: Data,
        withFilterContext filterContext: Any?
    ) {
        do {
            guard let oscPayload = try data.parseOSC() else { return }
            try handle(oscPayload: oscPayload)
            
        } catch let error as OSCBundle.DecodeError {
            // handle bundle errors
            switch error {
            case .malformed(let verboseError):
                print("Error:", verboseError)
            }
            
        } catch let error as OSCMessage.DecodeError {
            // handle message errors
            switch error {
            case .malformed(let verboseError):
                print("Error:", verboseError)
                
            case .unexpectedType(let oscType):
                print("Error: unexpected OSC type tag:", oscType)
                
            }
            
        } catch {
            // handle other errors
            print("Error:", error)
        }
    }
    
    /// Handle incoming OSC data recursively.
    private func handle(oscPayload: OSCPayload) throws {
        switch oscPayload {
        case .bundle(let bundle):
            // recursively handle nested bundles and messages
            try bundle.elements.forEach { try handle(oscPayload: $0) }
            
        case .message(let message):
            // handle message
            handler?(message)
        }
    }
}
