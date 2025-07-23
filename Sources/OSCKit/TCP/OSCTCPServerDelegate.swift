//
//  OSCTCPServerDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation

/// Internal TCP receiver class so as to not expose `GCDAsyncSocketDelegate` methods as public.
final class OSCTCPServerDelegate: NSObject {
    weak var oscServer: _OSCServerProtocol?
    let framingMode: OSCTCPFramingMode
    
    var clients: [Int: OSCTCPServerConnection] = [:]
    
    init(framingMode: OSCTCPFramingMode) {
        self.framingMode = framingMode
    }
    
    deinit {
        closeClients()
    }
}

// extension OSCTCPClientDelegate: @unchecked Sendable { } // TODO: make Sendable

extension OSCTCPServerDelegate: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        defer {
            // request socket to continue reading data
            sock.readData(withTimeout: -1, tag: tag)
        }
        
        guard let oscServer else { return }
        
        // TODO: deduplicate this code in OSCTCPClientDelegate
        let oscPackets: [Data]
        switch framingMode {
        case .osc1_0:
            fatalError() // TODO: finish this (must accommodate more than one packet in the data)
            break
        case .osc1_1:
            do { oscPackets = try data.slipDecoded() }
            catch {
                print(error.localizedDescription)
                oscPackets = []
            }
        case .none:
            oscPackets = [data] // TODO: this may contain more than one OSC packet - how to parse??
        }
        
        guard !oscPackets.isEmpty else {
            print("Failed to parse incoming TCP data as OSC")
            return
        }
        
        let remoteHost = sock.connectedHost ?? ""
        let remotePort = sock.connectedPort
        for oscPacketData in oscPackets {
            do {
                guard let oscObject = try oscPacketData.parseOSC() else {
                    continue
                }
                oscServer._handle(payload: oscObject, remoteHost: remoteHost, remotePort: remotePort)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func newSocketQueueForConnection(fromAddress address: Data, on sock: GCDAsyncSocket) -> dispatch_queue_t? {
        oscServer?.queue
    }
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        let sockID = newSockID()
        let newConnection = OSCTCPServerConnection(
            tcpSocket: newSocket,
            tcpSocketTag: sockID,
            framingMode: framingMode,
            delegate: self
        )
        clients[sockID] = newConnection
        newSocket.delegate = self
        
        // read initial data
        newSocket.readData(withTimeout: -1, tag: sockID)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: (any Error)?) {
        let disconnectedClients = clients
            .filter { $0.value.tcpSocket == sock }
        
        for (sockID, socket) in disconnectedClients {
            socket.delegate = nil
            clients[sockID] = nil
        }
    }
}

// MARK: - Methods

extension OSCTCPServerDelegate {
    func closeClients() {
        clients.forEach { $0.value.close()}
        clients.removeAll()
    }
}

// MARK: - Utilities

extension OSCTCPServerDelegate {
    func newSockID() -> Int {
        var sockID: Int = 0
        while sockID == 0 || clients.keys.contains(sockID) {
            // don't allow 0 or negative numbers
            sockID = Int.random(in: 1 ... Int.max)
        }
        return sockID
    }
}

#endif
