//
//  OSCMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

/// OSC Message.
public struct OSCMessage: OSCObject {
    /// OSC message address.
    public let address: OSCAddress
    
    /// OSC values contained within the message.
    public let values: [Value]
    
    public let rawData: Data
}

// MARK: - Equatable, Hashable

extension OSCMessage: Equatable, Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - CustomStringConvertible

extension OSCMessage: CustomStringConvertible {
    public var description: String {
        values.count < 1
            ? "OSCMessage(address: \"\(address)\")"
            :
            "OSCMessage(address: \"\(address)\", values: [\(values.mapDebugString(withLabel: true))])"
    }
    
    /// Same as `description` but values are separated with new-line characters and indented.
    public var descriptionPretty: String {
        values.count < 1
            ? "OSCMessage(address: \"\(address)\")"
            :
            "OSCMessage(address: \"\(address)\") Values:\n  \(values.mapDebugString(withLabel: true, separator: "\n  "))"
            .trimmed
    }
}

// MARK: - Header

extension OSCMessage {
    /// Constant caching an OSCMessage header.
    public static let header: Data = "/".toData(using: .nonLossyASCII)!
}

extension OSCMessage: Codable {
    enum CodingKeys: String, CodingKey {
        case address
        case values
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let address = try container.decode(OSCAddress.self, forKey: .address)
        let values = try container.decode([Value].self, forKey: .values)
        self.init(address: address, values: values)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(values, forKey: .values)
    }
}
