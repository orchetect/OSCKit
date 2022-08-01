//
//  OSCClient.swift
//  NetworkFrameworkExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import OSCKit
import Network

final public class OSCClient: NSObject {
    private let udpClient: UDPClient
    
    public init(host: String = "localhost",
                port: UInt16 = 8000) {
        udpClient = UDPClient(
            host: host,
            port: port,
            queue: .global()
        )
    }
    
    public func send(_ oscObject: OSCObject) {
        let data = oscObject.rawData
        
        udpClient.send(data: data)
    }
}
