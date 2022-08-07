//
//  OSCServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import CocoaAsyncSocket

/// OSC Server.
/// Receive OSC packets using CocoaAsyncSocket as the backing network I/O layer.
///
/// - remark: OSC 1.0 Spec:
///
/// With regards OSC Bundle Time Tag: "An OSC server must have access to a representation of the correct current absolute time. OSC does not provide any mechanism for clock synchronization. If the time represented by the OSC Time Tag is before or equal to the current time, the OSC Server should invoke the methods immediately. Otherwise the OSC Time Tag represents a time in the future, and the OSC server must store the OSC Bundle until the specified time and then invoke the appropriate OSC Methods. When bundles contain other bundles, the OSC Time Tag of the enclosed bundle must be greater than or equal to the OSC Time Tag of the enclosing bundle."
public class OSCServer: NSObject {
    let udpServer = GCDAsyncUdpSocket()
    let udpDelegate = OSCServerDelegate()
    
    let queue: DispatchQueue
    
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
        
        try udpServer.enableReusePort(true)
        try udpServer.bind(toPort: port)
        try udpServer.beginReceiving()
    }
    
    /// Stops listening for data and closes the OSC server port.
    public func stop() {
        udpServer.close()
    }
}

// MARK: - Internal

class OSCServerDelegate: NSObject, GCDAsyncUdpSocketDelegate {
    var handler: ((OSCMessage) -> Void)?
    
    // MARK: - UDP Packet Receive
    
    /// CocoaAsyncSocket receive delegate method implementation.
    func udpSocket(
        _ sock: GCDAsyncUdpSocket,
        didReceive data: Data,
        fromAddress address: Data,
        withFilterContext filterContext: Any?
    ) {
        guard let payload = try? data.parseOSC() else { return }
        try? handle(payload: payload)
    }
    
    // MARK: - Handle and Dispatch
    
    /// Handle incoming OSC data recursively.
    func handle(payload: OSCPayload,
                timeTag: OSCTimeTag = .immediate()) throws {
        switch payload {
        case let .bundle(bundle):
            try bundle.elements.forEach {
                try handle(payload: $0, timeTag: bundle.timeTag)
            }
            
        case let .message(message):
            schedule(message, at: timeTag)
        }
    }
    
    func schedule(_ message: OSCMessage,
                  at timeTag: OSCTimeTag = .immediate()) {
        // TimeTag of 1 has special meaning in OSC to dispatch "now".
        if timeTag.isImmediate {
            dispatch(message)
            return
        }
        
        // If Time Tag is <= now, dispatch immediately.
        // Otherwise, schedule message for future dispatch.
        guard timeTag.isFuture else {
            dispatch(message)
            return
        }
        
        let secondsFromNow = timeTag.timeIntervalSinceNow()
        dispatch(message, at: secondsFromNow)
    }
    
    func dispatch(_ message: OSCMessage) {
        DispatchQueue.main.async {
            self.handler?(message)
        }
    }
    
    func dispatch(_ message: OSCMessage,
                  at secondsFromNow: TimeInterval) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + secondsFromNow
        ) { [weak self] in
            self?.handler?(message)
        }
    }
}
