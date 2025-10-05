//
//  OSCMessageEncoder.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import SwiftASCII // ASCIICharacter

/// ``OSCMessage`` encoder.
///
/// Generally there is no need to directly instance or interact with this unless you are
/// implementing custom OSC value types. OSC message encoding and decoding is handled automatically
/// in OSCKit otherwise.
public struct OSCMessageEncoder {
    var builderAddress: Data
    var builderTags: [ASCIICharacter] = []
    var builderValuesChunk = Data()
    
    init(
        addressPattern: OSCAddressPattern
    ) {
        // add OSC address
        let addressData = addressPattern.rawData
        
        builderAddress = Self.fourNullBytePadded(addressData)
        
        // prime the OSC type tags
        builderTags += ","
        
        // prime the values chunk
        builderValuesChunk.reserveCapacity(1000)
    }
    
    init(
        addressPattern: OSCAddressPattern,
        values: [any OSCValueEncodable]
    ) throws(OSCEncodeError) {
        self.init(addressPattern: addressPattern)
        
        // note: doesn't account for arrays but we'll do it any way
        builderTags.reserveCapacity(values.count + 1)
        
        // process any values that may have been passed to the initializer
        for value in values {
            try encode(value)
        }
    }
    
    /// Add a value to the message encoder.
    public mutating func encode(_ value: some OSCValueEncodable) throws(OSCEncodeError) {
        try Self.encode(
            value,
            builderTags: &builderTags,
            builderValuesChunk: &builderValuesChunk
        )
    }
    
    /// Internal: typed encoder blocks.
    static func encode<T: OSCValueEncodable>(
        _ value: T,
        builderTags: inout [ASCIICharacter],
        builderValuesChunk: inout Data
    ) throws(OSCEncodeError) {
        switch T.oscEncoding {
        case let e as OSCValueStaticTagEncoder<T>:
            let encoded = try e.block(value)
            
            builderTags += ASCIICharacter(encoded.tag)
            
            if let data = encoded.data {
                builderValuesChunk += data
            }
            
        case let e as OSCValueVariableTagEncoder<T>:
            let encoded = try e.block(value)
            
            builderTags += ASCIICharacter(encoded.tag)
            
            if let data = encoded.data {
                builderValuesChunk += data
            }
            
        case let e as OSCValueVariadicTagEncoder<T>:
            let encoded = try e.block(value)
            
            builderTags += encoded.tags.map { ASCIICharacter($0) }
            
            if let data = encoded.data {
                builderValuesChunk += data
            }
            
        default:
            throw .internalInconsistency(
                "Unexpected encoder: \(type(of: T.self)). Only encoder types supplied by OSCKit can be used."
            )
        }
    }
    
    /// Returns the raw encoded `OSCMessage` data.
    public func rawOSCMessageData() -> Data {
        // max UDP IPv4 packet size is 65507 bytes,
        // 1kb is reasonable buffer for typical OSC messages
        var data = Data()
        data.reserveCapacity(1000)
        
        // assemble OSC-type and values chunk
        
        data += builderAddress
        
        let tagsRawData = builderTags.reduce(
            Data(capacity: builderTags.count.roundedUp(toMultiplesOf: 4))
        ) {
            $0 + $1.rawData
        }
        data += Self.fourNullBytePadded(tagsRawData)
        
        data += builderValuesChunk
        
        // return data
        return data
    }
}

extension OSCMessageEncoder {
    /// Pads `data` to 4-byte aligned null-terminated format.
    public static func fourNullBytePad(_ data: inout Data) {
        data.append(Data(
            repeating: 0x00,
            count: (4 - (data.count % 4))
        ))
    }
    
    /// Returns `data` padded to 4-byte aligned null-terminated format.
    public static func fourNullBytePadded(_ data: Data) -> Data {
        var copy = data
        fourNullBytePad(&copy)
        return copy
    }
}
