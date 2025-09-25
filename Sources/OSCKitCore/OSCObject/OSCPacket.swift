//
//  OSCPacket.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Packet enum containing an OSC bundle or message.
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
    
    /// Returns an enum case describing the OSC object type.
    public var oscObjectType: OSCObjectType {
        switch self {
        case .message: .message
        case .bundle: .bundle
        }
    }
    
    /// Returns the enum case unwrapped, typed as ``OSCObject``.
    package var oscObject: any OSCObject {
        switch self {
        case let .bundle(bundle): bundle
        case let .message(message): message
        }
    }
}
