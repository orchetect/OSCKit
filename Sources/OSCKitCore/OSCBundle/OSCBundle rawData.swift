//
//  OSCBundle rawData.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore

extension OSCBundle {
    /// Initialize by parsing raw OSC bundle data bytes.
    public init(from rawData: Data) throws {
        // cache raw data
        _rawData = rawData
        
        // parse a raw OSC packet and populates the struct's properties
        
        let len = rawData.count
        var ppos = 0 // parse byte position
        
        // validation: length. all bundles must include the header (8 bytes) and timetag (8 bytes).
        if len < 16 {
            throw OSCDecodeError.malformed("Data length too short. (Length is \(len))")
        }
        
        // validation: check header
        if rawData.subdata(in: Range(ppos ... ppos + 7)) != OSCBundle.header {
            throw OSCDecodeError.malformed("Bundle header is not present or is malformed.")
        }
        
        // set up object array
        var extractedElements = [any OSCObject]()
        
        ppos += 8
        
        guard let extractedTimeTag = rawData
            .subdata(in: ppos ..< ppos + 8)
            .toUInt64(from: .bigEndian)
        else {
            throw OSCDecodeError.malformed("Could not convert timetag to UInt64.")
        }
        
        ppos += 8
        
        while ppos < len {
            // int32 size chunk
            if rawData.count - (ppos + 3) < 0 {
                throw OSCDecodeError.malformed("Data bytes ended earlier than expected.")
            }
            guard let elementSize = rawData
                .subdata(in: ppos ..< ppos + 4)
                .toInt32(from: .bigEndian)?.int
            else {
                throw OSCDecodeError.malformed("Could not convert element size to Int32.")
            }
            
            ppos += 4
            
            // test for bundle or message
            if rawData.count - (ppos + elementSize) < 0 {
                throw OSCDecodeError.malformed("Data bytes ended earlier than expected.")
            }
            
            let elementContents = rawData.subdata(in: ppos ..< ppos + elementSize)
            
            guard let oscObject = elementContents.appearsToBeOSC else {
                throw OSCDecodeError.malformed("Unrecognized bundle element encountered.")
            }
            
            switch oscObject {
            case .bundle:
                let newBundle = try OSCBundle(from: elementContents)
                extractedElements.append(newBundle)
                
            case .message:
                let newMessage = try OSCMessage(from: elementContents)
                extractedElements.append(newMessage)
            }
            
            ppos += elementSize
        }
        
        // update public properties
        timeTag = .init(extractedTimeTag)
        elements = extractedElements
    }
    
    public func rawData() throws -> Data {
        // return cached data if struct was originally initialized from raw data
        // so we don't needlessly church CPU cycles to generate the data
        if let cached = _rawData {
            return cached
        }
        
        // max UDP IPv4 packet size is 65507 bytes,
        // 10kb is reasonable buffer for typical OSC bundles
        var data = Data()
        data.reserveCapacity(10000)
        
        data.append(OSCBundle.header) // prime the header
        
        data.append(timeTag.rawValue.toData(.bigEndian)) // add timetag
        
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
