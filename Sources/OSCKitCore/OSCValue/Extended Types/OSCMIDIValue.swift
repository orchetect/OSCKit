//
//  OSCMIDIValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

/// MIDI message OSC value as defined by the OSC 1.0 spec.
public struct OSCMIDIValue {
    public var portID: UInt8
    public var status: UInt8
    public var data1: UInt8
    public var data2: UInt8
        
    @inlinable
    public init(
        portID: UInt8,
        status: UInt8,
        data1: UInt8 = 0x00,
        data2: UInt8 = 0x00
    ) {
        self.portID = portID
        self.status = status
        self.data1 = data1
        self.data2 = data2
    }
}

// MARK: - Equatable, Hashable

extension OSCMIDIValue: Equatable, Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - CustomStringConvertible

extension OSCMIDIValue: CustomStringConvertible {
    public var description: String {
        "OSCMIDIValue(portID:\(portID.hex.stringValue) status:\(status.hex.stringValue) data1:\(data1.hex.stringValue) data2:\(data2.hex.stringValue))"
    }
}

// MARK: - Codable

extension OSCMIDIValue: Codable {
    enum CodingKeys: String, CodingKey {
        case bytes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let bytes = try container.decode([UInt8].self, forKey: .bytes)
        guard bytes.count == 4 else { throw DecodingError.dataCorrupted(
            .init(
                codingPath: decoder.codingPath,
                debugDescription: "Found unexpected number of values when decoding MIDI bytes."
            )
        ) }
        portID = bytes[0]
        status = bytes[1]
        data1 = bytes[2]
        data2 = bytes[3]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let bytes = [portID, status, data1, data2]
        try container.encode(bytes, forKey: .bytes)
    }
}

// MARK: - OSC Encoding

extension OSCMIDIValue: OSCValue {
    public static let oscValueToken: OSCValueToken = .midi
}

extension OSCMIDIValue: OSCValueCodable {
    static let oscTag: Character = "m"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension OSCMIDIValue: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        (
            tag: oscTag,
            data: [value.portID, value.status, value.data1, value.data2].data
        )
    }
}

extension OSCMIDIValue: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        let bytes = try decoder.read(byteLength: 4)
        
        return OSCMIDIValue(
            portID: bytes[0],
            status: bytes[1],
            data1: bytes[2],
            data2: bytes[3]
        )
    }
}
