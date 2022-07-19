//
//  OSCMessageValue stringValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCMessageValue {
    
    /// Returns a string representation of the value. Optionally includes a value-type label.
    public func stringValue(withLabel: Bool = false) -> String {
        
        var prefixString = ""
        var suffixString = ""
        var outputString: String = ""
        
        switch self {
            
            // core types
            
        case .int32(let v):
            outputString = String(v)
            prefixString = "int32:"
            suffixString = ""
        case .float32(let v):
            outputString = String(v)
            prefixString = "float32:"
            suffixString = ""
        case .string(let v):
            outputString = v.stringValue
            prefixString = "string:\""
            suffixString = "\""
        case .blob(let v):
            outputString = "\(v.count) bytes"
            prefixString = "blob:"
            suffixString = ""
            
            // extended types
            
        case .int64(let v):
            outputString = String(v)
            prefixString = "int64:"
            suffixString = ""
        case .timeTag(let v):
            outputString = String(v)
            prefixString = "timeTag:"
            suffixString = ""
        case .double(let v):
            outputString = String(v)
            prefixString = "double:"
            suffixString = ""
        case .stringAlt(let v):
            outputString = v.stringValue
            prefixString = "stringAlt:\""
            suffixString = "\""
        case .character(let v):
            outputString = String(v.characterValue)
            prefixString = "char:"
            suffixString = ""
        case .midi(let v):
            outputString = "\(v)"
            prefixString = "midi:"
            suffixString = ""
        case .bool(let v):
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
