//
//  OSCTCPServerProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation

/// Internal protocol that TCP-based OSC classes adopt in order to handle incoming OSC data.
protocol _OSCTCPServerProtocol: _OSCServerProtocol {
    var tcpSocket: GCDAsyncSocket { get }
    var framingMode: OSCTCPFramingMode { get }
}

extension _OSCTCPServerProtocol {
    func _handle(receivedData data: Data, on sock: GCDAsyncSocket, tag: Int) {
        let oscPackets: [Data]
        switch framingMode {
        case .osc1_0:
            fatalError() // TODO: finish this (must accommodate more than one packet in the data)
        case .osc1_1:
            do {
                oscPackets = try data.slipDecoded()
            } catch {
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
                self._handle(payload: oscObject, remoteHost: remoteHost, remotePort: remotePort)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#endif
