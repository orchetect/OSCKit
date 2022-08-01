//
//  OSCClient.swift
//  CocoaAsyncSocketExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import OSCKit
import CocoaAsyncSocket

final public class OSCClient: NSObject {
    private let udpClient = GCDAsyncUdpSocket()
    
    deinit {
        udpClient.close()
    }
    
    public func send(_ oscObject: OSCObject,
                     to host: String,
                     port: UInt16 = 8000) {
        let data = oscObject.rawData
        
        udpClient.send(
            data,
            toHost: host,
            port: port,
            withTimeout: 5.0,
            tag: 0
        )
    }
}
