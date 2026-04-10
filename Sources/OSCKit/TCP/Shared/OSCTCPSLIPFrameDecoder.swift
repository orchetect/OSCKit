//
//  File.swift
//  OSCKit
//
//  Created by Joshua Wolfson on 10/4/2026.
//

import Foundation
import NIOCore

final class OSCTCPSLIPFrameDecoder: ByteToMessageDecoder {
    typealias InboundOut = ByteBuffer
    
    func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        //SLIP has no upfront size declaration, must scan forward to find closing 0xC0
        guard let endIndex = buffer.withUnsafeReadableBytes({ bytes -> Int? in
            var start = 0
            //find if there is leading 0xC0
            let leadingDelimiterPresent = (bytes.first == Data.SLIPByte.end.rawValue)
            //if there is a leading 0xC0, skip to avoid misidentifying empty frame
            if !bytes.isEmpty && leadingDelimiterPresent {
                start = 1
            }
            
            //drop bytes before start
            let framedBytes = bytes[start...]
            //search for closing 0xC0, if none found then need more data
            guard let end = framedBytes.firstIndex(of: Data.SLIPByte.end.rawValue) else { return nil }
            
            return end + 1 //include the end byte
        }) else {
            return .needMoreData
        }
        //advance the reader index past the frame and return as ByteBuffer
        guard let frame = buffer.readSlice(length: endIndex) else { return .needMoreData }
        let envelope = wrapInboundOut(frame)
        
        context.fireChannelRead(envelope)
        return .continue
    }
}
