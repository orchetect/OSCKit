//
//  File.swift
//  OSCKit
//
//  Created by Joshua Wolfson on 8/4/2026.
//
//  Derived from OSCKit/Sources/OSCKit/UDP/Server/OSCUDPServerDelegate.swift

#if !os(watchOS)

import Foundation
import NIO

final class OSCUDPChannelHandler {
    weak var oscServer: (any _OSCHandlerProtocol)?
    
    init(oscServer: (any _OSCHandlerProtocol)? = nil) {
        self.oscServer = oscServer
    }
}

extension OSCUDPChannelHandler: ChannelInboundHandler {
    typealias InboundIn = AddressedEnvelope<ByteBuffer>
    typealias OutboundOut = AddressedEnvelope<ByteBuffer>
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var envelope: InboundIn = unwrapInboundIn(data)
        
        //get byte length of envelope
        let byteLength = envelope.data.readableBytes
        //read bytes from envelope
        guard let bytes = envelope.data.readBytes(length: byteLength) else { return /*throw error*/ }
        //convert bytes into data
        let data = Data(bytes)
        
        guard let oscServer else { return }
        
        let remoteHost = envelope.remoteAddress.ipAddress ?? ""
        let remotePort = UInt16(envelope.remoteAddress.port ?? 0)
        
        _handle(oscServer: oscServer, data: data, remoteHost: remoteHost, remotePort: remotePort)
    }
}

extension OSCUDPChannelHandler {
    /// Stub required to take `oscServer` as sending.
    private func _handle(
        oscServer: any _OSCHandlerProtocol,
        data: Data,
        remoteHost: String,
        remotePort: UInt16
    ) {
        do {
            guard let packet = try OSCPacket(from: data) else { return }
            oscServer._handle(packet: packet, remoteHost: remoteHost, remotePort: remotePort)
        } catch {
            #if DEBUG
            print("OSC parse error: \(error.localizedDescription)")
            #endif
        }
    }
}


extension OSCUDPChannelHandler: @unchecked Sendable { }

#endif
