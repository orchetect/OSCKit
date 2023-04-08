//
//  OSCMIDIValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import SwiftRadix // hex string

/// MIDI 1.0 message OSC value as defined by the OSC 1.0 spec.
///
/// The message is built as 1-3 raw MIDI 1.0 message bytes, along with a port ID.
public struct OSCMIDIValue {
    public var portID: UInt8
    public var status: UInt8
    public var data1: UInt8
    public var data2: UInt8
    
    /// MIDI 1.0 message OSC value as defined by the OSC 1.0 spec.
    ///
    /// The message is built as 1-3 raw MIDI 1.0 message bytes, along with a port ID.
    ///
    /// - Parameters:
    ///   - portID: An index number to identify a MIDI port. This is not part of the raw MIDI
    ///     message bytes but is rather up to manufacturer or developer to decide how to use this
    ///     OSC parameter. An ID of 0 can be used if not applicable.
    ///   - status: MIDI 1.0 status byte.
    ///   - data1: MIDI status message data byte 1 (optional).
    ///   - data2: MIDI status message data byte 2 (optional).
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

// MARK: - `any OSCValue` Constructors

extension OSCValue where Self == OSCMIDIValue {
    /// MIDI 1.0 message OSC value as defined by the OSC 1.0 spec.
    ///
    /// The message is built as 1-3 raw MIDI 1.0 message bytes, along with a port ID.
    ///
    /// - Parameters:
    ///   - portID: An index number to identify a MIDI port. This is not part of the raw MIDI
    ///     message bytes but is rather up to manufacturer or developer to decide how to use this
    ///     OSC parameter. An ID of 0 can be used if not applicable.
    ///   - status: MIDI 1.0 status byte.
    ///   - data1: MIDI status message data byte 1 (optional).
    ///   - data2: MIDI status message data byte 2 (optional).
    public static func midi(
        portID: UInt8,
        status: UInt8,
        data1: UInt8 = 0x00,
        data2: UInt8 = 0x00
    ) -> Self {
        OSCMIDIValue(
            portID: portID,
            status: status,
            data1: data1,
            data2: data2
        )
    }
}

// MARK: - Equatable, Hashable

extension OSCMIDIValue: Equatable, Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - CustomStringConvertible

extension OSCMIDIValue: CustomStringConvertible {
    public var description: String {
        let portIDHex = portID.hex.stringValue(padTo: 2, prefix: true)
        let statusHex = status.hex.stringValue(padTo: 2, prefix: true)
        let data1Hex = data1.hex.stringValue(padTo: 2, prefix: true)
        let data2Hex = data2.hex.stringValue(padTo: 2, prefix: true)
        return "MIDI(portID: \(portIDHex), status: \(statusHex), data1: \(data1Hex), data2: \(data2Hex))"
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
        guard bytes.count == 4 else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Found unexpected number of values when decoding MIDI bytes."
                )
            )
        }
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
