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
    weak var oscServer: _OSCTCPServerProtocol?
    let framingMode: OSCTCPFramingMode
    
    init(framingMode: OSCTCPFramingMode) {
        self.framingMode = framingMode
    }
}

// extension OSCTCPClientDelegate: @unchecked Sendable { } // TODO: make Sendable

extension OSCTCPClientDelegate: GCDAsyncSocketDelegate {
    func newSocketQueueForConnection(fromAddress address: Data, on sock: GCDAsyncSocket) -> dispatch_queue_t? {
        oscServer?.queue
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        // read initial data
        oscServer?.tcpSocket.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        defer {
            // request socket to continue reading data
            sock.readData(withTimeout: -1, tag: tag)
        }
        
        guard let oscServer else { return }
        
        // TODO: deduplicate this code in OSCTCPServerDelegate
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
}

#endif
