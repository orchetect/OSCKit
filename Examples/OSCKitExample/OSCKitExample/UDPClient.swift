//
//  UDPClient.swift
//  OSCKitExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import Network

@available(macOS 10.14, macCatalyst 13.0, iOS 12.0, tvOS 12.0, *)
final class UDPClient {
    
    let host: NWEndpoint.Host
    let port: NWEndpoint.Port
    private var connection: NWConnection
    private let queue: DispatchQueue
    
    init(
        host: NWEndpoint.Host,
        port: NWEndpoint.Port,
        queue: DispatchQueue
    ) {
        self.host = host
        self.port = port
        self.queue = queue
        
        connection = NWConnection(to: .hostPort(host: self.host, port: self.port),
                                  using: .udp)
        
        connection.stateUpdateHandler = { [weak self] newState in
            self?.stateDidChange(to: newState)
        }
        
        connection.start(queue: self.queue)
    }
    
    @_disfavoredOverload
    convenience init(
        host: String,
        port: UInt16,
        queue: DispatchQueue
    ) {
        let endpointHost = NWEndpoint.Host(host)
        let endpointPort = NWEndpoint.Port(rawValue: port)!
        
        self.init(host: endpointHost,
                  port: endpointPort,
                  queue: queue)
    }
    
    deinit {
        print("UDPClient deinit")
    }
    
    private func stateDidChange(to newState: NWConnection.State) {
        switch newState {
        case .ready:
            print("Client ready.")
        case .failed(let error):
            print("Client failure, error: \(error.localizedDescription)")
        default:
            break
        }
    }
    
    public func send(data: Data) {
        connection.send(
            content: data,
            completion: .contentProcessed { error in
                if let error = error {
                    print("UDPClient send error: \(error.localizedDescription)")
                }
            }
        )
    }
    
    public func send(data: [Data]) {
        connection.batch {
            for packet in data {
                send(data: packet)
            }
        }
    }
    
}
