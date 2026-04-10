//
//  OSCTCPServerChildChannelHandler.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation
import NIO

final class OSCTCPServerChildChannelHandler {
    weak var server: OSCTCPServer?
    var clientID: OSCTCPClientSessionID = 0
    
    /// Stores an error captured in `errorCaught` for use in `channelInactive`.
    private var pendingError: (any Error)?
    
    init(server: OSCTCPServer? = nil) {
        self.server = server
    }
}

extension OSCTCPServerChildChannelHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    
    func channelActive(context: ChannelHandlerContext) {
        guard let server else { return }
        let port = context.channel.remoteAddress?.port?.uInt16 ?? 0
        let host = context.channel.remoteAddress?.ipAddress ?? ""
        
        clientID = server.addClient(channel: context.channel)
        
        server._generateConnectedNotification(remoteHost: host, remotePort: port, clientID: clientID)
    }
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer = unwrapInboundIn(data)
        
        let byteLength = buffer.readableBytes
        guard let bytes = buffer.readBytes(length: byteLength) else { return /* throw error */ }
        let data = Data(bytes)
                
        guard let server else { return }
        
        let port = context.channel.remoteAddress?.port?.uInt16 ?? 0
        let host = context.channel.remoteAddress?.ipAddress ?? ""
        
        server._handle(receivedData: data, remoteHost: host, remotePort: port)
    }
    
    func channelInactive(context: ChannelHandlerContext) {
        let error = pendingError
        pendingError = nil
        
        let port = context.channel.remoteAddress?.port?.uInt16 ?? 0
        let host = context.channel.remoteAddress?.ipAddress ?? ""
        
        server?.disconnectClient(clientID: clientID)
        server?._generateDisconnectedNotification(remoteHost: host, remotePort: port, clientID: clientID, error: error)
    }
    
    func errorCaught(context: ChannelHandlerContext, error: any Error) {
        pendingError = error
        context.close(promise: nil)
    }
}

extension OSCTCPServerChildChannelHandler: @unchecked Sendable { }

#endif
