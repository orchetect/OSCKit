//
//  OSCMessageEncoder.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

public struct OSCMessageEncoder {
    var builderAddress: Data
    var builderTags: [ASCIICharacter] = []
    var builderValuesChunk = Data()
    
    var encodeCalledCount = 0
    
    init(
        address: OSCAddress
    ) {
        // add OSC address
        let addressData = address.address.rawData
        builderAddress = Self.fourNullBytePadded(addressData)
        
        // prime the OSC type tags
        builderTags += ","
        
        // prime the values chunk
        builderValuesChunk.reserveCapacity(1000)
    }
    
    init(
        address: OSCAddress,
        values: [any OSCValueEncodable]
    ) throws {
        self.init(address: address)
        
        // TODO: doesn't account for arrays so this may not be useful/necessary
        builderTags.reserveCapacity(values.count + 1)
        
        // process any values that may have been passed to the initializer
        for value in values {
            try encode(value)
        }
    }
    
    public mutating func encode(_ value: any OSCValueEncodable) throws {
        
//        switch T.oscEncoding {
//        case let .atomic(block):
//            let encoded = try block(value)
//
//            builderTags += ASCIICharacter(encoded.tag)
//
//            if let data = encoded.data {
//                builderValuesChunk += data
//            }
//
//        case let .variable(block):
//            let encoded = try block(value)
//
//            builderTags += ASCIICharacter(encoded.tag)
//
//            if let data = encoded.data {
//                builderValuesChunk += data
//            }
//
//        case let .variadic(block):
//            let encoded = try block(value)
//
//            builderTags += encoded.tags.map { ASCIICharacter($0) }
//
//            if let data = encoded.data {
//                builderValuesChunk += data
//            }
//        }
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
