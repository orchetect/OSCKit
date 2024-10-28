//
//  OSCServerUDPDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation
@preconcurrency import CocoaAsyncSocket

/// Internal UDP receiver class so as to not expose `GCDAsyncUdpSocketDelegate` methods as public.
internal final class OSCServerUDPDelegate: NSObject, GCDAsyncUdpSocketDelegate, @unchecked Sendable { // TODO: unchecked
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
        _handle(oscServer: oscServer, data: data)
    }
    
    /// Stub required to take `oscServer` as sending.
    private func _handle(
        oscServer: sending _OSCServerProtocol,
        data: Data
    ) {
        Task {
            guard let payload = try? await data.parseOSC() else { return }
            try? await oscServer._handle(payload: payload)
        }
    }
}

#endif
