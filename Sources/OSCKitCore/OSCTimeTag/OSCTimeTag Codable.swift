//
//  OSCTimeTag Codable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCTimeTag: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(UInt64.self)
        self.init(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
