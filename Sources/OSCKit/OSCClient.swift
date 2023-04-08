//
//  OSCClient.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import CocoaAsyncSocket

/// Sends OSC packets over the network using the UDP network protocol.
///
/// A single client can serve the needs of an entire application. The client is capable of sending
/// packets to arbitrary recipients and is not intrinsically bound to any single destination.
public final class OSCClient: NSObject {
    private let udpClient = GCDAsyncUdpSocket()
    
    /// Initialize an OSC client to send messages using the UDP network protocol.
    public override init() {
        super.init()
    }
    
    deinit {
        udpClient.close()
    }
    
    /// Send an OSC bundle or message ad-hoc to a recipient on the network.
    ///
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    public func send(
        _ oscObject: any OSCObject,
        to host: String,
        port: UInt16 = 8000
    ) throws {
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
