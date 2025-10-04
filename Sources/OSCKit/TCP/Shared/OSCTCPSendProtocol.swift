//
//  OSCTCPSendProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import OSCKitCore
import Foundation

/// Internal protocol that TCP-based OSC classes adopt in order to send OSC packets.
protocol _OSCTCPSendProtocol: AnyObject where Self: Sendable {
    var tcpSocket: GCDAsyncSocket { get }
    var framingMode: OSCTCPFramingMode { get }
}

extension _OSCTCPSendProtocol {
    /// Send an OSC packet.
    ///
    /// - Parameters:
    ///   - oscPacket: OSC bundle or message.
    ///   - tag: Server Connection Client Session ID. Applies only to TCP server to determine which connected socket to
    ///     send to.
    func _send(_ oscPacket: OSCPacket, tag: OSCTCPClientSessionID) throws {
        try _send(oscPacket.rawData(), tag: tag)
    }
    
    /// Send an OSC bundle.
    ///
    /// - Parameters:
    ///   - oscBundle: OSC bundle.
    ///   - tag: Server Connection Client Session ID. Applies only to TCP server to determine which connected socket to
    ///     send to.
    func _send(_ oscBundle: OSCBundle, tag: OSCTCPClientSessionID) throws {
        try _send(oscBundle.rawData(), tag: tag)
    }
    
    /// Send an OSC message.
    ///
    /// - Parameters:
    ///   - oscMessage: OSC message.
    ///   - tag: Server Connection Client Session ID. Applies only to TCP server to determine which connected socket to
    ///     send to.
    func _send(_ oscMessage: OSCMessage, tag: OSCTCPClientSessionID) throws {
        try _send(oscMessage.rawData(), tag: tag)
    }
    
    /// Send an OSC packet.
    ///
    /// - Parameters:
    ///   - oscData: Raw bytes of an OSC bundle or message.
    ///   - tag: Server Connection Client Session ID. Applies only to TCP server to determine which connected socket to
    ///     send to.
    private func _send(_ oscData: Data, tag: OSCTCPClientSessionID) {
        // guard isConnected else {
        //     throw GCDAsyncUdpSocketError(
        //         .closedError,
        //         userInfo: ["Reason": "OSC TCP client socket is not connected to a remote host."]
        //     )
        // }
        
        // frame data
        let data: Data = switch framingMode {
        case .osc1_0:
            // OSC packet framed using a packet-length header
            // 4-byte int for size
            oscData.packetLengthHeaderEncoded(endianness: .bigEndian)
            
        case .osc1_1:
            // OSC packet framed using SLIP (double END) protocol: http://www.rfc-editor.org/rfc/rfc1055.txt
            oscData.slipEncoded()
            
        case .none:
            // no framing, send OSC bytes as-is
            oscData
        }
        
        // send packet
        tcpSocket.write(data, withTimeout: -1, tag: tag)
    }
}

#endif
