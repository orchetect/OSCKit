//
//  OSCBundle rawData.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCBundle {
    /// Initialize by parsing raw OSC bundle data bytes.
    public init(from rawData: Data) throws {
        // cache raw data
        _rawData = rawData
        
        // parse a raw OSC packet and populates the struct's properties
        
        let length = rawData.count
        var offset = rawData.startIndex // parse byte position
        
        // validation: length. all bundles must include the header (8 bytes) and timetag (8 bytes).
        if length < 16 {
            throw OSCDecodeError.malformed("Data length too short. (Length is \(length))")
        }
        
        // validation: check header
        if rawData[offset ..< offset + 8]
            != OSCBundle.header
        {
            throw OSCDecodeError.malformed("Bundle header is not present or is malformed.")
        }
        
        // set up packet array
        var extractedElements: [OSCPacket] = []
        
        offset += 8
        
        guard let extractedTimeTag = rawData[offset ..< offset + 8]
            .toUInt64(from: .bigEndian)
        else {
            throw OSCDecodeError.malformed("Could not convert timetag to UInt64.")
        }
        
        offset += 8
        
        while offset < rawData.endIndex {
            // int32 size chunk
            guard offset + 4 <= rawData.endIndex else {
                throw OSCDecodeError.malformed("Data bytes ended earlier than expected.")
            }
            guard let elementSize = rawData[offset ..< offset + 4]
                .toInt32(from: .bigEndian)?.int
            else {
                throw OSCDecodeError.malformed("Could not convert element size to Int32.")
            }
            
            offset += 4
            
            // test for bundle or message
            guard (offset + elementSize) <= rawData.endIndex else {
                throw OSCDecodeError.malformed("Data bytes ended earlier than expected.")
            }
            
            let elementContents = rawData[offset ..< offset + elementSize]
            
            guard let oscPacketType = elementContents.oscPacketType else {
                throw OSCDecodeError.malformed("Unrecognized bundle element encountered.")
            }
            
            switch oscPacketType {
            case .bundle:
                let newBundle = try OSCBundle(from: elementContents)
                extractedElements.append(.bundle(newBundle))
                
            case .message:
                let newMessage = try OSCMessage(from: elementContents)
                extractedElements.append(.message(newMessage))
            }
            
            offset += elementSize
        }
        
        // update public properties
        timeTag = .init(extractedTimeTag)
        elements = extractedElements
    }
    
    /// Returns raw OSC packet data constructed from the bundle content.
    public func rawData() throws -> Data {
        // return cached data if struct was originally initialized from raw data
        // so we don't needlessly church CPU cycles to generate the data
        if let cached = _rawData {
            return cached
        }
        
        // max UDP IPv4 packet size is 65507 bytes,
        // 10kb is reasonable buffer for typical OSC bundles
        var data = Data(capacity: 10000)
        
        // prime the header
        data.append(OSCBundle.header)
        
        // add timetag
        data.append(timeTag.rawValue.toData(.bigEndian))
        
        for element in elements {
            let raw = try element.rawData()
            
            // element length
            data.append(raw.count.int32.toData(.bigEndian))
            
            // element data
            data.append(raw)
        }
        
        return data
    }
}
