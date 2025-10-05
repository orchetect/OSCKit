//
//  OSCMessage Static.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCMessage {
    /// Enum describing the OSC packet type.
    public static let packetType: OSCPacketType = .message
    
    /// Constant caching an OSCMessage header.
    public static let header: Data = {
        guard let data = "/".toData(using: .nonLossyASCII) else {
            assertionFailure("Failed to form OSC message header data.")
            return Data()
        }
        return data
        }()
    }
