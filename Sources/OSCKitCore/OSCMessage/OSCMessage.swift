//
//  OSCMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

/// OSC Message.
public struct OSCMessage: OSCObject {
    /// OSC message address.
    public let address: OSCAddress
    
    /// OSC values contained within the message.
    public let values: [any OSCValue]
    
    public let _rawData: Data?
}

// MARK: - Equatable

extension OSCMessage: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.address == rhs.address &&
        lhs.values == rhs.values
    }
}

// MARK: - Hashable

extension OSCMessage: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(address.stringValue)
        values.hash(into: &hasher)
    }
}

// MARK: - CustomStringConvertible

extension OSCMessage: CustomStringConvertible {
    public var description: String {
        values.isEmpty
            ? "OSCMessage(address: \"\(address)\")"
            : "OSCMessage(address: \"\(address)\", values: \(values))"
    }
    
    /// Same as `description` but values are separated with new-line characters and indented.
    public var descriptionPretty: String {
        values.isEmpty
            ? "OSCMessage(address: \"\(address)\")"
            : "OSCMessage(address: \"\(address)\") Values:\n  "
                + values.map { "\($0)" }.joined(separator: "\n  ")
                .trimmed
    }
}

// MARK: - Header

extension OSCMessage {
    /// Constant caching an OSCMessage header.
    public static let header: Data = "/".toData(using: .nonLossyASCII) ?? Data()
}

// MARK: - Codable

// TODO: fix this later. needs Array implementation.

//extension OSCMessage: Codable {
//    enum CodingKeys: String, CodingKey {
//        case address
//        case values
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let address = try container.decode(OSCAddress.self, forKey: .address)
//        let values = try container.decode([any OSCValue].self, forKey: .values)
//        self.init(address: address, values: values)
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(address, forKey: .address)
//        try container.encode(values, forKey: .values)
//    }
//}
