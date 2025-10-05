//
//  OSCBundle Static.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCBundle {
    /// Enum describing the OSC packet type.
    public static let packetType: OSCPacketType = .bundle
    
    /// Constant caching an OSCBundle header.
    public static let header: Data = {
        guard let data = "#bundle".toData(using: .nonLossyASCII) else {
            assertionFailure("Failed to form OSC bundle header data.")
            return Data()
        }
        
        return OSCMessageEncoder.fourNullBytePadded(data)
    }()
}
