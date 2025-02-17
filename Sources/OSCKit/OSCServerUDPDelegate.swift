//
//  OSCServerUDPDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation

/// Internal UDP receiver class so as to not expose `GCDAsyncUdpSocketDelegate` methods as public.
final class OSCServerUDPDelegate: NSObject, GCDAsyncUdpSocketDelegate, @unchecked Sendable { // TODO: unchecked
    weak var oscServer: _OSCServerProtocol?
    
    init(oscServer: _OSCServerProtocol? = nil) {
        self.oscServer = oscServer
    }
    
    /// CocoaAsyncSocket receive delegate method implementation.
    func udpSocket(
        _ sock: GCDAsyncUdpSocket,
        didReceive data: Data,
        fromAddress address: Data,
        withFilterContext filterContext: Any?
    ) {
        guard let oscServer else { return }
        
        var remoteHost: NSString? = nil
        var remotePort: UInt16 = 0
        _ = GCDAsyncUdpSocket.getHost(&remoteHost, port: &remotePort, fromAddress: address)
        
        _handle(
            oscServer: oscServer,
            data: data,
            remoteHost: (remoteHost as String?) ?? "",
            remotePort: remotePort
        )
    }
    
    /// Stub required to take `oscServer` as sending.
    private func _handle(
        oscServer: _OSCServerProtocol,
        data: Data,
        remoteHost: String,
        remotePort: UInt16
    ) {
        oscServer.receiveQueue.async {
            do {
                guard let payload = try data.parseOSC() else { return }
                oscServer._handle(payload: payload, remoteHost: remoteHost, remotePort: remotePort)
            } catch {
                #if DEBUG
                print("OSC parse error: \(error.localizedDescription)")
                #endif
            }
        }
    }
}

#endif
