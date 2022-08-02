//
//  OSCBundle init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCBundle {
    @inlinable
    public init(
        elements: [OSCPayload],
        timeTag: Int64 = 1
    ) {
        self.timeTag = timeTag
        self.elements = elements
        self.rawData = Self.generateRawData(
            from: elements,
            timeTag: timeTag
        )
    }
    
    /// Initialize by parsing raw OSC bundle data bytes.
    public init(from rawData: Data) throws {
        // cache raw data
        
        self.rawData = rawData
        
        // parse a raw OSC packet and populates the struct's properties
        
        let len = rawData.count
        var ppos = 0 // parse byte position
        
        // validation: length. all bundles must include the header (8 bytes) and timetag (8 bytes).
        if len < 16 {
            throw DecodeError.malformed("Data length too short. (Length is \(len))")
        }
        
        // validation: check header
        if rawData.subdata(in: Range(ppos ... ppos + 7)) != OSCBundle.header {
            throw DecodeError.malformed("Bundle header is not present or is malformed.")
        }
        
        // set up object array
        var extractedElements = [OSCPayload]()
        
        ppos += 8
        
        guard let extractedTimeTag = rawData
            .subdata(in: ppos ..< ppos + 8)
            .toInt64(from: .bigEndian)
        else {
            throw DecodeError.malformed("Could not convert timetag to Int64.")
        }
        
        ppos += 8
        
        while ppos < len {
            // int32 size chunk
            if rawData.count - (ppos + 3) < 0 {
                throw DecodeError.malformed("Data bytes ended earlier than expected.")
            }
            guard let elementSize = rawData
                .subdata(in: ppos ..< ppos + 4)
                .toInt32(from: .bigEndian)?.int
            else {
                throw DecodeError.malformed("Could not convert element size to Int32.")
            }
            
            ppos += 4
            
            // test for bundle or message
            if rawData.count - (ppos + elementSize) < 0 {
                throw DecodeError.malformed("Data bytes ended earlier than expected.")
            }
            
            let elementContents = rawData.subdata(in: ppos ..< ppos + elementSize)
            
            guard let oscObject = elementContents.appearsToBeOSC else {
                throw DecodeError.malformed("Unrecognized bundle element encountered.")
            }
            
            switch oscObject {
            case .bundle:
                let newBundle = try OSCBundle(from: elementContents)
                extractedElements.append(.bundle(newBundle))
                
            case .message:
                let newMessage = try OSCMessage(from: elementContents)
                extractedElements.append(.message(newMessage))
            }
            
            ppos += elementSize
        }
        
        // update public properties
        timeTag = extractedTimeTag
        elements = extractedElements
    }
}
