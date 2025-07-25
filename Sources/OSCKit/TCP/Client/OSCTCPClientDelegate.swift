//
//  OSCTCPClientDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation

/// Internal TCP receiver class so as to not expose `GCDAsyncSocketDelegate` methods as public.
final class OSCTCPClientDelegate: NSObject {
    weak var oscServer: (any _OSCTCPHandlerProtocol & _OSCTCPGeneratesClientNotificationsProtocol)?
    
    // init() { } // already implemented by NSObject
}

extension OSCTCPClientDelegate: @unchecked Sendable { } // TODO: unchecked

extension OSCTCPClientDelegate: GCDAsyncSocketDelegate {
    func newSocketQueueForConnection(fromAddress address: Data, on sock: GCDAsyncSocket) -> dispatch_queue_t? {
        oscServer?.queue
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        // read initial data
        oscServer?.tcpSocket.readData(withTimeout: -1, tag: 0)
        
        // send notification
        oscServer?._generateConnectedNotification()
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        defer {
            // request socket to continue reading data
            sock.readData(withTimeout: -1, tag: tag)
        }
        
        oscServer?._handle(receivedData: data, on: sock, tag: tag)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: (any Error)?) {
        // errors should only ever be of type `GCDAsyncSocketError`
        var error = err as? GCDAsyncSocketError
        // CocoaAsyncSocket populates `err` with GCDAsyncSocketError.closedError
        // whenever the remote peer closes its connection intentionally,
        // so we'll interpret that as a non-error condition
        if error?.code == GCDAsyncSocketError.closedError {
            error = nil
        }
        
        // send notification
        oscServer?._generateDisconnectedNotification(
            error: error
        )
    }
}

#endif
