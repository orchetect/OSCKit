//
//  OSCTCPClientProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import OSCKitCore
import Foundation

/// Internal protocol that TCP-based OSC classes adopt in order to send OSC packets.
protocol OSCTCPClientProtocol {
    /// Send an OSC packet.
    func send(_ oscObject: any OSCObject) throws
}

protocol _OSCTCPClientProtocol: OSCTCPClientProtocol {
    var tcpSocket: GCDAsyncSocket { get }
    var framingMode: OSCTCPFramingMode { get }
}

extension _OSCTCPClientProtocol {
    /// Send an OSC packet.
    ///
    /// - Parameters:
    ///   - oscObject: OSC data.
    ///   - tag: Server Connection Client ID. Applies only to TCP server to determine which connected socket to send to.
    func _send(_ oscObject: any OSCObject, tag: OSCTCPClientID) throws {
        // guard isConnected else {
        //     throw GCDAsyncUdpSocketError(
        //         .closedError,
        //         userInfo: ["Reason": "OSC TCP client socket is not connected to a remote host."]
        //     )
        // }
        
        // pack data
        let data: Data
        switch framingMode {
        case .osc1_0:
            // OSC packet framed using size-count preamble
            // 4-byte int for size
            let oscData = try oscObject.rawData()
            let length = oscData.count.toData(.platformDefault) // TODO: not sure if int type and endianness is correct
            data = length + oscData
            
        case .osc1_1:
            // OSC packet framed using SLIP (double END) protocol: http://www.rfc-editor.org/rfc/rfc1055.txt
            data = try oscObject.rawData().slipEncoded()
            
        case .none:
            // no framing, send OSC bytes as-is
            data = try oscObject.rawData()
        }
        
        // send packet
        tcpSocket.write(data, withTimeout: -1, tag: tag)
    }
}

#endif
