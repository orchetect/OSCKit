//
//  UDPServer.swift
//  OSCKitExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import Network

@available(macOS 10.14, macCatalyst 13.0, iOS 12.0, tvOS 12.0, *)
final class UDPServer {
    
    let port: NWEndpoint.Port
    var handler: ((Data) -> Void)? = nil
    private let listener: NWListener
    private let queue: DispatchQueue
    
    init(
        host: String,
        port: NWEndpoint.Port,
        queue: DispatchQueue,
        handler: ((Data) -> Void)? = nil
    ) throws {
        self.handler = handler
        self.port = port
        self.queue = queue
        self.listener = try NWListener(using: .udp, on: port)
        
        // set up listener
        
        listener.stateUpdateHandler = { [weak self] newState in
            self?.stateDidChange(to: newState)
        }
        
        listener.newConnectionHandler = { [weak self] newConnection in
            self?.didAccept(connection: newConnection)
        }
        
        listener.start(queue: self.queue)
    }
    
    @_disfavoredOverload
    convenience init(
        host: String,
        port: UInt16,
        queue: DispatchQueue = DispatchQueue.global(qos: .userInteractive),
        handler: ((Data) -> Void)? = nil
    ) throws {
        let endpointPort = NWEndpoint.Port(rawValue: port)!
        
        try self.init(host: host,
                      port: endpointPort,
                      queue: queue,
                      handler: handler)
    }
    
    deinit {
        print("UDPServer deinit")
    }
    
    func setHandler(_ handler: @escaping (Data) -> Void) {
        self.handler = handler
    }
    
    private func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .ready:
            print("Server ready.")
        case .failed(let error):
            print("Server failure, error: \(error.localizedDescription)")
        default:
            break
        }
    }
    
    private func didAccept(connection: NWConnection) {
        connection.start(queue: queue)
        receive(on: connection)
    }
    
    private func receive(on connection: NWConnection) {
        connection.receiveMessage { [weak self] data, context, isComplete, error in
            guard let data = data else { return }
            
            // call the handler with the received data
            self?.handler?(data)
            
            // wait for next incoming UDP packet
            self?.receive(on: connection)
        }
    }
    
    // private func stop() {
    //     self.listener.cancel()
    // }
    
}
