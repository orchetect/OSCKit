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
protocol _OSCTCPClientProtocol: AnyObject where Self: Sendable {
    var tcpSocket: GCDAsyncSocket { get }
    var framingMode: OSCTCPFramingMode { get }
    var notificationHandler: OSCTCPNotificationHandlerBlock? { get }
}

extension _OSCTCPClientProtocol {
    /// Send an OSC packet.
    ///
    /// - Parameters:
    ///   - oscObject: OSC bundle or message.
    ///   - tag: Server Connection Client Session ID. Applies only to TCP server to determine which connected socket to
    ///     send to.
    func _send(_ oscObject: any OSCObject, tag: OSCTCPClientSessionID) throws {
        // guard isConnected else {
        //     throw GCDAsyncUdpSocketError(
        //         .closedError,
        //         userInfo: ["Reason": "OSC TCP client socket is not connected to a remote host."]
        //     )
        // }
        
        // pack data
        let data: Data = switch framingMode {
        case .osc1_0:
            // OSC packet framed using a packet-length header
            // 4-byte int for size
            try oscObject.rawData().packetLengthHeaderEncoded(endianness: .bigEndian)
            
        case .osc1_1:
            // OSC packet framed using SLIP (double END) protocol: http://www.rfc-editor.org/rfc/rfc1055.txt
            try oscObject.rawData().slipEncoded()
            
        case .none:
            // no framing, send OSC bytes as-is
            try oscObject.rawData()
        }
        
        // send packet
        tcpSocket.write(data, withTimeout: -1, tag: tag)
    }
}

#endif
