//
//  Value MIDIMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCMessage.Value {
    public struct MIDIMessage: Equatable, Hashable, CustomStringConvertible {
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
        
        public var description: String {
            "MIDIMessage(portID:\(portID.hex.stringValue) status:\(status.hex.stringValue) data1:\(data1.hex.stringValue) data2:\(data2.hex.stringValue))"
        }
    }
}

extension OSCMessage.Value.MIDIMessage: Codable {
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
