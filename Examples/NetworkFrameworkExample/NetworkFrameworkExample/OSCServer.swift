//
//  OSCServer.swift
//  NetworkFrameworkExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import OSCKit
import Network

final public class OSCServer: NSObject {
    private var udpServer: UDPServer?
    public private(set) var port: UInt16
    private var handler: ((OSCMessage) -> Void)?
    private let queue: DispatchQueue
    
    public init(
        port: UInt16 = 8000,
        queue: DispatchQueue = .global(),
        handler: ((OSCMessage) -> Void)? = nil
    ) {
        self.port = port
        self.handler = handler
        self.queue = queue
        super.init()
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
        
        udpServer = try UDPServer(
            host: "localhost",
            port: localPort,
            queue: queue
        )
        
        udpServer?.setHandler { [weak self] data in
            do {
                guard let oscPayload = try data.parseOSC() else { return }
                try self?.handle(oscPayload: oscPayload)
                
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
    }
    
    /// Stops listening for data and closes the OSC server port.
    public func stop() {
        udpServer?.close()
        udpServer = nil
    }
}

// MARK: - Receive

extension OSCServer {
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
