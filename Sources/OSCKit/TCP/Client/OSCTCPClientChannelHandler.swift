//
//  OSCTCPClientChannelHandler.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
import NIO

/// Internal TCP receiver class so as to not expose  methods as public.
final class OSCTCPClientChannelHandler {
    weak var oscServer: (any _OSCTCPHandlerProtocol & _OSCTCPGeneratesClientNotificationsProtocol)?
    
    init(oscServer: (any _OSCTCPHandlerProtocol & _OSCTCPGeneratesClientNotificationsProtocol)? = nil) {
        self.oscServer = oscServer
    }
}

extension OSCTCPClientChannelHandler: @unchecked Sendable { } // TODO: unchecked

extension OSCTCPClientChannelHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer

    func channelActive(context: ChannelHandlerContext) {
        // send notification
        oscServer?._generateConnectedNotification()
    }
    
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var envelope = unwrapInboundIn(data)
        
        // get byte length of envelope
        let byteLength = envelope.readableBytes
        // read bytes from envelope
        guard let bytes = envelope.readBytes(length: byteLength) else { return /* throw error */ }
        // convert bytes into data
        let data = Data(bytes)
                
        guard let oscServer else { return }
        
        let remoteAddress = context.remoteAddress
        let remoteHost = remoteAddress?.ipAddress ?? ""
        let remotePort = remoteAddress?.port?.uInt16 ?? 0
        
        oscServer._handle(receivedData: data, remoteHost: remoteHost, remotePort: remotePort)
    }
    
    func errorCaught(context: ChannelHandlerContext, error: any Error) {
        // send notification
        oscServer?._generateDisconnectedNotification(error: error)
        // close connection
        context.close(promise: nil)
    }
}
