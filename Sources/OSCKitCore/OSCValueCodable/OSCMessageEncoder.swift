//
//  OSCMessageEncoder.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

/// `OSCMessage` encoder.
public struct OSCMessageEncoder {
    var builderAddress: Data
    var builderTags: [ASCIICharacter] = []
    var builderValuesChunk = Data()
    
    var encodeCalledCount = 0
    
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
    ) throws {
        self.init(addressPattern: addressPattern)
        
        // TODO: doesn't account for arrays so this may not be useful/necessary
        builderTags.reserveCapacity(values.count + 1)
        
        // process any values that may have been passed to the initializer
        for value in values {
            try encode(value)
        }
    }
    
    public mutating func encode<T: OSCValueEncodable>(_ value: T) throws {
        switch T.oscEncoding {
        case let e as OSCValueAtomicEncoder<T>:
            let encoded = try e.block(value)

            builderTags += ASCIICharacter(encoded.tag)

            if let data = encoded.data {
                builderValuesChunk += data
            }

        case let e as OSCValueVariableEncoder<T>:
            let encoded = try e.block(value)

            builderTags += ASCIICharacter(encoded.tag)

            if let data = encoded.data {
                builderValuesChunk += data
            }

        case let e as OSCValueVariadicEncoder<T>:
            let encoded = try e.block(value)

            builderTags += encoded.tags.map { ASCIICharacter($0) }

            if let data = encoded.data {
                builderValuesChunk += data
            }
            
        default:
            throw OSCEncodeError.unexpectedEncoder
        }
    }
    
    /// Returns the raw encoded `OSCMessage` data.
    public func rawOSCMessageData() -> Data {
        // max UDP IPv4 packet size is 65507 bytes,
        // 1kb is reasonable buffer for typical OSC messages
        var data = Data()
        data.reserveCapacity(1000)
        
        // assemble OSC-type and values chunk
        
        var tagsRawData = Data()
        
        tagsRawData
            .reserveCapacity(builderTags.count.roundedUp(toMultiplesOf: 4))
        
        tagsRawData = builderTags
            .reduce(Data()) { $0 + $1.rawData }
        
        data += Self.fourNullBytePadded(tagsRawData)
        
        data += builderValuesChunk
        
        // return data
        return data
    }
}

extension OSCMessageEncoder {
    /// Pads `data` to 4-byte aligned null-terminated format.
    public static func fourNullBytePad(_ data: inout Data) {
        data.append(.init(
            repeating: 0x00,
            count: (4 - (data.count % 4))
        ))
    }
    
    /// Returns `data` padded to 4-byte aligned null-terminated format.
    public static func fourNullBytePadded(_ data: Data) -> Data {
        data + .init(
            repeating: 0x00,
            count: (4 - (data.count % 4))
        )
    }
}
