//
//  OSCTCPHandlerProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation

/// Internal protocol that TCP-based OSC classes adopt in order to handle incoming OSC data.
protocol _OSCTCPHandlerProtocol: _OSCHandlerProtocol {
    var tcpSocket: GCDAsyncSocket { get }
    var framingMode: OSCTCPFramingMode { get }
}

extension _OSCTCPHandlerProtocol {
    func _handle(receivedData data: Data, on sock: GCDAsyncSocket, tag: Int) {
        // This routine must accommodate more than one consecutive packet contained in the data
        // which may happen when multiple packets are sent rapidly from a client.
        
        let oscPackets: [Data]
        switch framingMode {
        case .osc1_0:
            do {
                oscPackets = try data.packetLengthHeaderDecoded(endianness: .bigEndian)
            } catch {
                #if DEBUG
                print("OSC 1.0 packet-length header decoding error:", error.localizedDescription)
                #endif
                
                return
            }
            
        case .osc1_1:
            do {
                oscPackets = try data.slipDecoded()
            } catch {
                #if DEBUG
                print("OSC 1.1 SLIP decoding error:", error.localizedDescription)
                #endif
                
                return
            }
            
        case .none:
            // TODO: data may contain more than one OSC packet - need to figure out how to either parse out multiple consecutive OSC bundles/messages from raw data, or somehow intuit packet byte offsets within the data if possible.
            oscPackets = [data]
        }
        
        guard !oscPackets.isEmpty else {
            #if DEBUG
            print("Failed to parse OSC objects from incoming TCP data.")
            #endif
            
            return
        }
        
        let remoteHost = sock.connectedHost ?? ""
        let remotePort = sock.connectedPort
        for oscPacketData in oscPackets {
            do {
                guard let oscObject = try oscPacketData.parseOSC() else {
                    #if DEBUG
                    print("Error parsing OSC object from incoming TCP data; it may not be OSC data or may be malformed.")
                    #endif
                    
                    continue
                }
                self._handle(payload: oscObject, remoteHost: remoteHost, remotePort: remotePort)
            } catch {
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
        }
    }
}

#endif
