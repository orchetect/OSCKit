//
//  Value Codable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import SwiftASCII

extension OSCMessage.Value: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        // core types
        
        case int32
        case float32
        case string
        case blob
        
        // extended types
        
        case int64
        case timeTag
        case double
        case stringAlt
        case character
        case midi
        case bool
        case `null`
        
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
            
            // core types
            
        case .int32:
            let value = try container.decode(Int32.self, forKey: key)
            self = .int32(value)
            
        case .float32:
            let value = try container.decode(Float32.self, forKey: key)
            self = .float32(value)
            
        case .string:
            let value = try container.decode(ASCIIString.self, forKey: key)
            self = .string(value)
            
        case .blob:
            let value = try container.decode(Data.self, forKey: key)
            self = .blob(value)
            
            // extended types
            
        case .int64:
            let value = try container.decode(Int64.self, forKey: key)
            self = .int64(value)
            
        case .timeTag:
            let value = try container.decode(Int64.self, forKey: key)
            self = .timeTag(value)
            
        case .double:
            let value = try container.decode(Double.self, forKey: key)
            self = .double(value)
            
        case .stringAlt:
            let value = try container.decode(ASCIIString.self, forKey: key)
            self = .stringAlt(value)
            
        case .character:
            let value = try container.decode(ASCIICharacter.self, forKey: key)
            self = .character(value)
            
        case .midi:
            let value = try container.decode(OSCMessage.Value.MIDIMessage.self, forKey: key)
            self = .midi(value)
            
        case .bool:
            let value = try container.decode(Bool.self, forKey: key)
            self = .bool(value)
            
        case .null:
            let _ = try container.decodeNil(forKey: key)
            self = .null
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .int32(let value):
            try container.encode(value, forKey: .int32)
        case .float32(let value):
            try container.encode(value, forKey: .float32)
        case .string(let value):
            try container.encode(value, forKey: .string)
        case .blob(let value):
            try container.encode(value, forKey: .blob)
        case .int64(let value):
            try container.encode(value, forKey: .int64)
        case .timeTag(let value):
            try container.encode(value, forKey: .timeTag)
        case .double(let value):
            try container.encode(value, forKey: .double)
        case .stringAlt(let value):
            try container.encode(value, forKey: .stringAlt)
        case .character(let value):
            try container.encode(value, forKey: .character)
        case .midi(let value):
            try container.encode(value, forKey: .midi)
        case .bool(let value):
            try container.encode(value, forKey: .bool)
        case .null:
            try container.encodeNil(forKey: .null)
        }
        
    }
    
}
