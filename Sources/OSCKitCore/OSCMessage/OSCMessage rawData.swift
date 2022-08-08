//
//  OSCMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

// MARK: - OSCMessage

/// OSC Message.
extension OSCMessage {
    /// Initialize by parsing raw OSC message data bytes.
    public init(from rawData: Data) throws {
        // cache raw data
        self._rawData = rawData
        
        // parse a raw OSC packet and populates the struct's properties
        
        // validation: length
        if rawData.count % 4 != 0 { // isn't a multiple of 4 bytes (as per OSC spec)
            throw OSCDecodeError.malformed("Length not a multiple of 4 bytes.")
        }
        
        // validation: check header
        guard rawData.appearsToBeOSCMessage else {
            throw OSCDecodeError.malformed("Does not start with an address.")
        }
        
        var decoder = OSCValueDecoder(data: rawData)
        
        // OSC address
        
        guard let extractedAddress = try? decoder.read4ByteAlignedNullTerminatedASCIIString()
            .asciiString
        else {
            throw OSCDecodeError.malformed("Address string could not be parsed.")
        }
        
        // OSC-type chunk
        
        guard let extractedOSCtypes = try? decoder.read4ByteAlignedNullTerminatedASCIIString()
        else {
            throw OSCDecodeError.malformed("Couldn't extract OSC-type chunk.")
        }
        
        // set up value array
        var extractedValues: [any OSCValue] = []
        
        for char in extractedOSCtypes {
            let t = decoder.context?.tagIdentities
            switch char {
                #warning("> Finish this")
                
            case ",", "\0":
                break // ignore
                
            default:
                throw OSCDecodeError.unexpectedType(tag: char)
            }
        }
        
        // update public properties
        address = .init(address: extractedAddress)
        values = extractedValues
    }
    
    public func rawData() throws -> Data {
        // return cached data if struct was originally initialized from raw data
        // so we don't needlessly church CPU cycles to generate the data
        if let cached = _rawData {
            return cached
        }
        
        let encoder = try OSCMessageEncoder(address: address, values: values)
        
        return encoder.rawOSCMessageData()
    }
}
