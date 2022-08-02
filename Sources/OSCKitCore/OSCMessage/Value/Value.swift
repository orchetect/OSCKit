//
//  Value.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
import SwiftASCII

extension OSCMessage {
    /// Concrete value types that can be used in an `OSCMessage`.
    public enum Value: Equatable, Hashable {
        // core types
        
        case int32(Int32)
        case float32(Float32)
        case string(ASCIIString)
        case blob(Data)
        
        // extended types
        
        case int64(Int64)
        case timeTag(Int64)
        case double(Double)
        case stringAlt(ASCIIString)
        case character(ASCIICharacter)
        case midi(MIDIMessage)
        case bool(Bool)
        case null
    }
}

extension OSCMessage.Value: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        stringValue(withLabel: false)
    }
    
    public var debugDescription: String {
        stringValue(withLabel: true)
    }
}
