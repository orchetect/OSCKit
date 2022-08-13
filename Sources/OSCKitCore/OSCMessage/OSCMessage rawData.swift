//
//  OSCMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

// MARK: - OSCMessage

/// OSC Message.
extension OSCMessage {
    /// Initialize by parsing raw OSC message data bytes.
    public init(from rawData: Data) throws {
        // cache raw data
        self._rawData = rawData
        
        let decoded = try OSCMessageDecoder.decode(rawData: rawData)
        
        // update public properties
        addressPattern = .init(decoded.addressPattern)
        values = decoded.values
    }
    
    public func rawData() throws -> Data {
        // return cached data if struct was originally initialized from raw data
        // so we don't needlessly church CPU cycles to generate the data
        if let cached = _rawData {
            return cached
        }
        
        let encoder = try OSCMessageEncoder(
            addressPattern: addressPattern,
            values: values
        )
        
        return encoder.rawOSCMessageData()
    }
}
