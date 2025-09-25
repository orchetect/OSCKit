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

extension OSCPacket: Equatable { }

extension OSCPacket: Hashable { }

extension OSCPacket: Sendable { }

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
        guard let oscPacket = try rawData.parseOSCPacket() else {
            return nil
        }
        
        self = oscPacket
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
    /// Returns an enum case describing the OSC object type.
    public var oscObjectType: OSCObjectType {
        switch self {
        case .message: .message
        case .bundle: .bundle
        }
    }
}

// MARK: - Internal

extension OSCPacket {
    /// Returns the enum case unwrapped, typed as ``OSCObject``.
    package var oscObject: any OSCObject {
        switch self {
        case let .bundle(bundle): bundle
        case let .message(message): message
        }
    }
}

// MARK: - Static Constructors

extension OSCPacket {
    /// Construct a new OSC bundle.
    public static func bundle(
        timeTag: OSCTimeTag? = nil,
        _ elements: [OSCPacket] = []
    ) -> Self {
        let bundle = OSCBundle(
            timeTag: timeTag,
            elements.map(\.oscObject)
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
