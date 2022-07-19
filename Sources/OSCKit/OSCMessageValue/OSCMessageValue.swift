//
//  OSCMessageValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix
import SwiftASCII

/// Concrete value types that can be used in an `OSCMessage`.
public enum OSCMessageValue: Equatable, Hashable {
    
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
    case `null`
    
}

extension OSCMessageValue: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        stringValue(withLabel: false)
    }
    
    public var debugDescription: String {
        stringValue(withLabel: true)
    }
    
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


// MARK: - Initializers

public extension OSCMessageValue {
    
    // core types
    
    @inlinable
    init(_ source: Int32) {
        self = .int32(source)
    }
    
    @inlinable
    init(_ source: Float32) {
        self = .float32(source)
    }
    
    @inlinable
    init(_ source: ASCIIString) {
        self = .string(source)
    }
    
    @inlinable
    init(_ source: Data) {
        self = .blob(source)
    }
    
    // extended types
    
    @inlinable
    init(_ source: Int64) {
        self = .int64(source)
    }
    
    @inlinable
    init(timeTag source: Int64) {
        self = .timeTag(source)
    }
    
    @inlinable
    init(_ source: Double) {
        self = .double(source)
    }
    
    @inlinable
    init(stringAlt source: ASCIIString) {
        self = .stringAlt(source)
    }
    
    @inlinable
    init(character source: ASCIICharacter) {
        self = .character(source)
    }
    
    @inlinable
    init(_ source: MIDIMessage) {
        self = .midi(source)
    }
    
    @inlinable
    static func midi(portID: UInt8,
                     status: UInt8,
                     data1: UInt8 = 0x00,
                     data2: UInt8 = 0x00) -> Self {
        
        .midi(MIDIMessage(portID: portID,
                          status: status,
                          data1: data1,
                          data2: data2))
        
    }
    
    @inlinable
    init(_ source: Bool) {
        self = .bool(source)
    }
    
}



// MARK: - Map Debug String

public extension Sequence where Iterator.Element == OSCMessageValue {
    
    /// Convenience: maps a sequence of `OSCMessageValue`s to a flat string, for logging/debug purposes.
    func mapDebugString(withLabel: Bool = true, separator: String = ", ") -> String {
        
        self.map { $0.stringValue(withLabel: withLabel) }
        .joined(separator: separator)
        
    }
    
}


// MARK: - Convenience methods

public extension OSCMessageValue {
    
    /// Convenience:
    /// If passed value can be converted to an `Int`, an `Int` will be returned.
    /// Used in cases where you mask an OSC message value set with `.number` or `.numberOptional` and want to get a value out without caring about preserving type.
    ///
    /// - parameter testValue: Any numerical value type that OSC supports.
    /// - returns: `Double`, or `nil` if value can't be converted.
    @inlinable
    static func numberAsInt(_ testValue: Any?) -> Int? {
        
        // core types
        if let v = testValue as? Int     { return v }
        if let v = testValue as? Int32   { return Int(exactly: v) }
        if let v = testValue as? Float32 { return Int(exactly: v) }
        
        // extended types
        if let v = testValue as? Int64   { return Int(exactly: v) }
        if let v = testValue as? Double  { return Int(exactly: v) }
        
        return nil
        
    }
    
    /// Convenience:
    /// If passed value can be converted to a `Double`, a `Double` will be returned.
    /// Used in cases where you mask an OSC message value set with `.number` or `.numberOptional` and want to get a value out without caring about preserving type.
    ///
    /// - parameter testValue: Any numerical value type that OSC supports.
    /// - returns: `Double`, or `nil` if value can't be converted.
    @inlinable
    static func numberAsDouble(_ testValue: Any?) -> Double? {
        
        // core types
        if let v = testValue as? Int     { return Double(exactly: v) }
        if let v = testValue as? Int32   { return Double(exactly: v) }
        if let v = testValue as? Float32 { return Double(exactly: v) }
        
        // extended types
        if let v = testValue as? Int64   { return Double(exactly: v) }
        if let v = testValue as? Double  { return v }
        
        return nil
        
    }
    
}


// MARK: - Peculiar OSC Values

extension OSCMessageValue {
    
    public struct MIDIMessage: Equatable, Hashable, CustomStringConvertible {
        
        public var portID: UInt8
        public var status: UInt8
        public var data1: UInt8
        public var data2: UInt8
        
        @inlinable
        public init(portID: UInt8,
                    status: UInt8,
                    data1: UInt8 = 0x00,
                    data2: UInt8 = 0x00) {
            
            self.portID = portID
            self.status = status
            self.data1 = data1
            self.data2 = data2
            
        }
        
        public var description: String {
            
            "portID:\(portID.hex.stringValue) status:\(status.hex.stringValue) data1:\(data1.hex.stringValue) data2:\(data2.hex.stringValue)"
            
        }
        
    }
    
}
