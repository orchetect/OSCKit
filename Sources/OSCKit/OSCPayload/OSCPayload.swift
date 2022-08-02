//
//  OSCPayload.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// OSC payload types.
public enum OSCPayload {
    /// OSC Message.
    case message(OSCMessage)
    
    /// OSC Bundle, containing one or more OSC bundle(s) and/or OSC message(s).
    case bundle(OSCBundle)
}

// MARK: - CustomStringConvertible

extension OSCPayload: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .message(element):
            return element.description
            
        case let .bundle(element):
            return element.description
        }
    }
}

extension OSCPayload: Codable {
    enum CodingKeys: String, CodingKey {
        case message
        case bundle
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let key = container.allKeys.first else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: container.codingPath,
                    debugDescription: "Key not present in data."
                )
            )
        }
        
        switch key {
        case .message:
            let message = try container.decode(OSCMessage.self, forKey: key)
            self = .message(message)
            
        case .bundle:
            let bundle = try container.decode(OSCBundle.self, forKey: key)
            self = .bundle(bundle)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .message(message):
            try container.encode(message, forKey: .message)
            
        case let .bundle(bundle):
            try container.encode(bundle, forKey: .bundle)
        }
    }
}
