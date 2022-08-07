//
//  Value stringValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCMessage.Value {
    /// Returns a string representation of the value. Optionally includes a value-type label.
    public func stringValue(withLabel: Bool = false) -> String {
        var prefixString = ""
        var suffixString = ""
        var outputString = ""
        
        switch self {
            // core types
            
        case let .int32(v):
            outputString = String(v)
            prefixString = "int32:"
            suffixString = ""
        case let .float32(v):
            outputString = String(v)
            prefixString = "float32:"
            suffixString = ""
        case let .string(v):
            outputString = v.stringValue
            prefixString = "string:\""
            suffixString = "\""
        case let .blob(v):
            outputString = "\(v.count) bytes"
            prefixString = "blob:"
            suffixString = ""
            
            // extended types
            
        case let .int64(v):
            outputString = String(v)
            prefixString = "int64:"
            suffixString = ""
        case let .timeTag(v):
            outputString = String(v.rawValue)
            prefixString = "timeTag:"
            suffixString = ""
        case let .double(v):
            outputString = String(v)
            prefixString = "double:"
            suffixString = ""
        case let .stringAlt(v):
            outputString = v.stringValue
            prefixString = "stringAlt:\""
            suffixString = "\""
        case let .character(v):
            outputString = String(v.characterValue)
            prefixString = "char:"
            suffixString = ""
        case let .midi(v):
            outputString = "\(v)"
            prefixString = ""
            suffixString = ""
        case let .bool(v):
            outputString = String(v)
            prefixString = "bool:"
            suffixString = ""
        case .null:
            outputString = "Null"
            prefixString = ""
            suffixString = ""
        }
        
        switch withLabel {
        case true:
            return "\(prefixString)\(outputString)\(suffixString)"
        case false:
            return outputString
        }
    }
}
