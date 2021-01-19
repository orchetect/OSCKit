//
//  OSCMessageValue.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2016-06-17.
//  Copyright © 2016 Steffan Andrews. All rights reserved.
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

/// Concrete value types that can be used in an `OSCMessage`.
public enum OSCMessageValue {
	
	// core types:
	
	case int32(Int32)
	case float32(Float32)
	case string(String)
	case blob(Data)
	
	// extended types:
	case int64(Int64)
	case timeTag(Int64)
	case double(Double)
	case stringAlt(String)
	case character(Character)
	case midi(OSCMIDIMessage)
	case bool(Bool)
	case `null`
	
	/// Returns a string representation of the value. Optionally includes a value-type label.
	@inlinable public func stringValue(withLabel: Bool = false) -> String {
		
		var prefixString = ""
		var suffixString = ""
		var outputString: String = ""
		
		switch self {
		// core types
		case let .int32(v):		outputString = String(v)			; prefixString = "int32:"		; suffixString = ""
		case let .float32(v):	outputString = String(v)			; prefixString = "float32:"		; suffixString = ""
		case let .string(v):	outputString = v					; prefixString = "string:\""	; suffixString = "\""
		case let .blob(v):		outputString = "\(v.count) bytes"	; prefixString = "blob:"		; suffixString = ""
			
		// extended types
		case let .int64(v):		outputString = String(v)			; prefixString = "int64:"		; suffixString = ""
		case let .timeTag(v):	outputString = String(v)			; prefixString = "timeTag:"		; suffixString = ""
		case let .double(v):	outputString = String(v)			; prefixString = "double:"		; suffixString = ""
		case let .stringAlt(v):	outputString = v					; prefixString = "stringAlt:\""	; suffixString = "\""
		case let .character(v):	outputString = String(v)			; prefixString = "char:"		; suffixString = ""
		case let .midi(v):		outputString = "\(v)"				; prefixString = "midi:"		; suffixString = ""
		case let .bool(v):		outputString = String(v)			; prefixString = "bool:"		; suffixString = ""
		case     .null:			outputString = "Null"				; prefixString = ""				; suffixString = ""
		}
		
		switch withLabel {
		case true: return prefixString + outputString + suffixString
		case false: return outputString
		}
		
	}
	
}

public extension Sequence where Iterator.Element == OSCMessageValue {
	
	/// Convenience: maps a sequence of `OSCMessageValue`s to a flat string, for logging/debug purposes.
	func mapDebugString(withLabel: Bool = true, separator: String = ", ") -> String {
		
		self.map { $0.stringValue(withLabel: withLabel) }
			.joined(separator: separator)
		
	}
	
}


// MARK: - Convenience methods

public extension OSCMessageValue {
	
	/// Convenience: If passed value can be converted to an Int, an Int will be returned. Used in cases where you mask an OSC message value set with .number or .numberOptional and want to get a value out without caring about preserving type.
	/// - parameter testValue: Any numerical value type that OSC supports.
	/// - returns: Double, or nil if value can't be converted.
	@inlinable static func NumberAsInt(_ testValue: Any?) -> Int? {
		
		// core types
		if let v = testValue as? Int     { return v }
		if let v = testValue as? Int32   { return Int(exactly: v) }
		if let v = testValue as? Float32 { return Int(exactly: v) }
		
		// extended types
		if let v = testValue as? Int64   { return Int(exactly: v) }
		if let v = testValue as? Double  { return Int(exactly: v) }
		
		return nil
		
	}
	
	/// Convenience: If passed value can be converted to a Double, a Double will be returned. Used in cases where you mask an OSC message value set with .number or .numberOptional and want to get a value out without caring about preserving type.
	/// - parameter testValue: Any numerical value type that OSC supports.
	/// - returns: Double, or nil if value can't be converted.
	@inlinable static func NumberAsDouble(_ testValue: Any?) -> Double? {
		
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

public struct OSCMIDIMessage: Equatable, CustomStringConvertible {
	
	public var portID: UInt8
	public var status: UInt8
	public var data1: UInt8
	public var data2: UInt8
	
	@inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
		
		lhs.portID == rhs.portID &&
			lhs.status == rhs.status &&
			lhs.data1 == rhs.data1 &&
			lhs.data2 == rhs.data2
		
	}
	
	@inlinable public init(portID: UInt8,
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
