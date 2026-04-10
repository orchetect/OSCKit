//
//  File.swift
//  OSCKit
//
//  Created by Joshua Wolfson on 10/4/2026.
//

#if !os(watchOS)

import Foundation
import NIOCore

final class OSCTCPLengthHeaderFrameDecoder: ByteToMessageDecoder {
    typealias InboundOut = ByteBuffer
    
    func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        // Need at least 4 bytes for the length header
        guard buffer.readableBytes >= 4 else {
            return .needMoreData
        }
        
        // Reads the first 4 bytes without advancing the reader index
        guard let length = buffer.getInteger(at: buffer.readerIndex, as: UInt32.self) else {
            return .needMoreData
        }
        
        //expected frame size
        let totalLength = 4 + Int(length)
        //if readable bytes is greater than the expected size then continue, else it hasn't fully arrived
        guard buffer.readableBytes >= totalLength else {
            return .needMoreData
        }
        
        //advance the reader index past the frame and return as ByteBuffer
        guard let frame = buffer.readSlice(length: totalLength) else {
            return .needMoreData
        }
        let envelope = wrapInboundOut(frame)

        context.fireChannelRead(envelope)
        return .continue
    }
}

#endif
