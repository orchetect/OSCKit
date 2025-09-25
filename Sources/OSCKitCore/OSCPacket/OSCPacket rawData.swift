//
//  OSCPacket rawData.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

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
    
    /// Returns raw OSC packet data constructed from the packet content.
    public func rawData() throws -> Data {
        switch self {
        case let .bundle(bundle): try bundle.rawData()
        case let .message(message): try message.rawData()
        }
    }
}
