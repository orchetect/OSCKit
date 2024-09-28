//
//  OSCServerUDPDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation
import CocoaAsyncSocket

/// Internal UDP receiver class so as to not expose `GCDAsyncUdpSocketDelegate` methods as public.
internal class OSCServerUDPDelegate: NSObject, GCDAsyncUdpSocketDelegate {
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
        guard let payload = try? data.parseOSC() else { return }
        guard let oscServer else { return }
        Task { try? await oscServer.handle(payload: payload) }
    }
}

#endif
