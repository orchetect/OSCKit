//
//  OSCPayload rawData.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCPayload {
    /// Returns the OSC object's raw data bytes.
    public var rawData: Data {
        switch self {
        case let .message(element):
            return element.rawData
            
        case let .bundle(element):
            return element.rawData
        }
    }
}
