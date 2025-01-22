//
//  OSCMessage rawData.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - OSCMessage

/// OSC Message.
extension OSCMessage {
    /// Initialize by parsing raw OSC message data bytes.
    public init(from rawData: Data) throws {
        // cache raw data
        _rawData = rawData
        
        let decoded = try OSCMessageDecoder.decode(rawData: rawData)
        
        // update public properties
        addressPattern = .init(decoded.addressPattern)
        values = decoded.values
    }
    
    // (inline docs inherited from OSCObject protocol)
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
