//
//  OSCPacket.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC packet containing a bundle or message.
public enum OSCPacket {
    /// OSC bundle.
    case bundle(_ bundle: OSCBundle)
    
    /// OSC message.
    case message(_ message: OSCMessage)
}

// MARK: - Equatable

extension OSCPacket: Equatable { }

// MARK: - Hashable

extension OSCPacket: Hashable { }

// MARK: - Sendable

extension OSCPacket: Sendable { }

// MARK: - CustomStringConvertible

extension OSCPacket: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .bundle(bundle): bundle.description
        case let .message(message): message.description
        }
    }
    
    /// Same as `description` but values are separated with new-line characters and indented.
    public var descriptionPretty: String {
        switch self {
        case let .bundle(bundle): bundle.descriptionPretty
        case let .message(message): message.descriptionPretty
        }
    }
}

// MARK: - Raw Data

extension OSCPacket {
    /// Initialize by parsing raw OSC packet data bytes.
    ///
    /// - Throws: An error is thrown if data appears to be an OSC bundle or message but is
    ///   malformed. Errors thrown will typically be a case of ``OSCDecodeError`` but other
    ///   errors may be thrown.
    ///
    /// - Returns: If the packet data is a valid OSC message or bundle, the data will be decoded
    ///   and a new instance will be created. If the packet data is not an OSC packet, `nil` will
    ///   be returned.
    public init?(from rawData: Data) throws {
        if rawData.appearsToBeOSCBundle {
            let bundle = try OSCBundle(from: rawData)
            self = .bundle(bundle)
        } else if rawData.appearsToBeOSCMessage {
            let message = try OSCMessage(from: rawData)
            self = .message(message)
        } else {
            return nil
        }
    }
    
    /// Returns raw OSC packet data constructed from the struct's properties.
    public func rawData() throws -> Data {
        switch self {
        case let .bundle(bundle): try bundle.rawData()
        case let .message(message): try message.rawData()
        }
    }
}

// MARK: - Properties

extension OSCPacket {
    /// Returns an enum case describing the OSC packet type.
    public var packetType: OSCPacketType {
        switch self {
        case .message: .message
        case .bundle: .bundle
        }
    }
    
    /// A convenience to access all messages within the packet.
    ///
    /// If the packet is an OSC message, an array of one message will be returned.
    ///
    /// If the packet is an OSC bundle, all messages contained within it will be returned, preserving order.
    public var messages: [OSCMessage] {
        switch self {
        case let .bundle(bundle):
            bundle.elements.reduce(into: []) { base, element in
                base.append(contentsOf: element.messages)
            }
        case let .message(message):
            [message]
        }
    }
}

// MARK: - Static Constructors

// NOTE: Overloads that take variadic values were tested,
// however for code consistency and proper indentation, it is
// undesirable to have variadic parameters.

extension OSCPacket {
    /// Construct a new OSC bundle.
    public static func bundle(
        timeTag: OSCTimeTag? = nil,
        _ elements: [OSCPacket] = []
    ) -> Self {
        let bundle = OSCBundle(
            timeTag: timeTag,
            elements
        )
        return .bundle(bundle)
    }
    
    /// Construct a new OSC message.
    public static func message(
        _ addressPattern: String,
        values: OSCValues = []
    ) -> Self {
        let message = OSCMessage(
            OSCAddressPattern(addressPattern),
            values: values
        )
        return .message(message)
    }
    
    /// Construct a new OSC message.
    public static func message(
        _ addressPattern: OSCAddressPattern,
        values: OSCValues = []
    ) -> Self {
        let message = OSCMessage(
            addressPattern,
            values: values
        )
        return .message(message)
    }
}
