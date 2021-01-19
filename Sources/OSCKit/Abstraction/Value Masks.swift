//
//  Abstraction/Value Masks.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation

// Abstraction used to add optional and meta types of existing concrete types

// MARK: - OSCMessageValueType

/// Value types that can be used in an `OSCMessage` including optional variants and meta types useful for masking sequences of values.
public enum OSCMessageValueType: Int, CaseIterable {
	
	// concrete types
	
	// -- core types
	case int32
	case float32
	case string
	case blob
	
	// -- extended types
	case int64
	case timeTag
	case double
	case stringAlt
	case character
	case midi
	case bool
	case `null`
	
	// "meta" types
	
	/// Not a specific type like the others. Used when defining a `OSCMessageValueType` mask to accept either int32 or float32 for an expected value placeholder.
	case number // accepts any OSC number type
	
	// optional versions of concrete types
	
	// -- core types
	case int32Optional // signifies a value that is optional or has a default value
	case float32Optional
	case stringOptional
	case blobOptional
	
	// -- extended types
	case int64Optional
	case timeTagOptional
	case doubleOptional
	case stringAltOptional
	case characterOptional
	case midiOptional
	case boolOptional
	case nullOptional
	
	// -- meta types
	/// Not a specific type like the others. Used when defining a `OSCMessageValueType` mask to accept either int32 or float32 for an expected value placeholder.
	case numberOptional // accepts any OSC number type
	
}


// MARK: - Base Type

public extension OSCMessageValueType {
	
	/// Returns base type `OSCMessageValueType` (by removing 'optional' component)
	@inlinable var baseType: OSCMessageValueType {
		
		switch self {
		// core types
		case .int32,		.int32Optional:		return .int32
		case .float32,		.float32Optional:	return .float32
		case .string,		.stringOptional:	return .string
		case .blob,			.blobOptional:		return .blob
			
		// extended types
		case .int64,		.int64Optional:		return .int64
		case .timeTag,		.timeTagOptional:	return .timeTag
		case .double,		.doubleOptional:	return .double
		case .stringAlt,	.stringAltOptional:	return .stringAlt
		case .character,	.characterOptional:	return .character
		case .midi,			.midiOptional:		return .midi
		case .bool,			.boolOptional:		return .bool
		case .null,			.nullOptional:		return .null
		
		// meta types
		case .number,		.numberOptional:	return .number
		}
		
	}
	
	/// Tests if a OSCMessageValueType is optional (has default) or not.
	@inlinable var isOptional: Bool {
		
		switch self {
		// concrete types
		// -- core types
		case .int32, .float32, .string, .blob: return false
		// -- extended types
		case .int64, .timeTag, .double, .stringAlt, .character, .midi, .bool, .null: return false
			
		// meta types
		case .number: return false
			
		// optional versions of concrete types
		// -- core types
		case .int32Optional, .float32Optional, .stringOptional, .blobOptional: return true
		// -- extended types
		case .int64Optional, .timeTagOptional, .doubleOptional, .stringAltOptional, .characterOptional, .midiOptional, .boolOptional, .nullOptional: return true
		// -- meta types
		case .numberOptional: return true
		}
		
	}
	
}

public extension OSCMessageValue {
	
	/// Tests if the type of a OSCMessageValue matches the supplied OSCMessageValueType (optional/default or not) and returns base type. Returns nil if does not match.
	/// - parameter type: `OSCMessageValueType` to compare to.
	/// - parameter canMatchMetaTypes: Match a meta type (if a meta type is passed in `type`)
	///   - If `true`, only exact matches will return `true` (`.int32` matches only `.int32` and not `.number` "meta" type; `.number` only matches `.number`).
	///   - If `false`, "meta" types matches will return true (ie: `.int32` or `.float32` will return true if `type` = `.number`).
	///   - (default = `false`)
	@inlinable func baseTypeMatches(type: OSCMessageValueType, canMatchMetaTypes: Bool = false) -> Bool {
		
		// if types explicitly match, return true
		
		// concrete types match, or a meta type matches the same meta type
		// ie: .int32,	.float32	= return false
		//     .int32,	.int32		= return true
		//     .int32,	.number		= return false
		//     .number,	.number		= return true
		if self.baseType.rawValue == type.rawValue { return true }
		
		switch canMatchMetaTypes {
		case false: break
			// we already covered this with the code above so execution will never reach this switch case
		
		case true:
			// add additional case to allow "meta" types to also match concrete types
			
			// ie: .int32,	.float32	= return false
			//     .int32,	.int32		= return true
			//     .int32,	.number		= return false
			//     .number,	.number		= return true
			
			// (FYI, `self` will never be a meta type itself, only a concrete type)
			if type.rawValue == OSCMessageValueType.number.rawValue &&
				(self.baseType.rawValue == OSCMessageValueType.int32.rawValue ||
					self.baseType.rawValue == OSCMessageValueType.float32.rawValue ||
					self.baseType.rawValue == OSCMessageValueType.int64.rawValue ||
					self.baseType.rawValue == OSCMessageValueType.double.rawValue)
			{ return true }
			
		}
		
		return false
		
	}
	
	/// Returns base type of `OSCMessageValue` as an `OSCMessageValueType` (by removing 'optional' component)
	@inlinable var baseType: OSCMessageValueType {
		
		switch self {
		// core types
		case .int32(_):		return .int32
		case .float32(_):	return .float32
		case .string(_):	return .string
		case .blob(_):		return .blob
			
		// extended types
		case .int64(_):		return .int64
		case .timeTag(_):	return .timeTag
		case .double(_):	return .double
		case .stringAlt(_):	return .stringAlt
		case .character(_):	return .character
		case .midi(_):		return .midi
		case .bool(_):		return .bool
		case .null:			return .null
		}
		
	}
	
}


// MARK: - OSCMessageValueProtocol

public protocol OSCMessageValueProtocol { }

extension Int32			: OSCMessageValueProtocol { }
extension Float32		: OSCMessageValueProtocol { }
extension String		: OSCMessageValueProtocol { }
extension Data			: OSCMessageValueProtocol { }
extension Int64			: OSCMessageValueProtocol { }
extension Double		: OSCMessageValueProtocol { }
extension Character		: OSCMessageValueProtocol { }
extension OSCMIDIMessage: OSCMessageValueProtocol { }
extension Bool			: OSCMessageValueProtocol { }
extension NSNull		: OSCMessageValueProtocol { }


// MARK: - Value Mask

public extension Array where Element == OSCMessageValue {
	
	/// Returns true if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
	/// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
	/// 
	/// Some meta type(s) are available:
	///   - `number` & `numberOptional`: Accepts int32 or float32 as a value.
	/// - parameter expectedMask: OSCMessageValueType array representing a positive mask match
	@inlinable func matchesValueMask(expectedMask: [OSCMessageValueType]) -> Bool {
		
		if self.count > expectedMask.count { return false } // should not contain more values than mask
		
		var matchCount = 0
		
		for idx in 0..<expectedMask.count {
			let idxOptional = expectedMask[idx].isOptional // can be a concrete type or meta type
			
			if self.indices.contains(idx) {
				switch self[idx].baseTypeMatches(type: expectedMask[idx].baseType,
												 canMatchMetaTypes: true) {
				case true:
					matchCount += 1
					continue
					
				case false:
					return false
					
				}
			} else {
				switch idxOptional {
				case true:
					matchCount += 1
					continue
					
				case false:
					return false
					
				}
			}
		}
		
		if expectedMask.count == matchCount { return true }
		return false
		
	}
	
	/// Returns an array `[OSCMessageValueProtocol]` of non-enumeration-encapsulated values if an array of `OSCMessageValue` values matches an expected value type mask (order and type of values).
	/// To make any of the mask values optional, pass them as `.optional` in `expectedMask`.
	/// Returns nil if values do not match the mask.
	///
	/// Returns:
	/// - `.int32(...)` as `Int`
	/// - `.float32(...)` as `Float32`
	/// - `.string(...)` as `String`
	/// - `.blob(...)` as `Data`
	/// - parameter expectedMask: OSCMessageValueType array representing a positive mask match
	@inlinable func valuesFromValueMask(expectedMask: [OSCMessageValueType]) -> [OSCMessageValueProtocol?]? {
		
		if self.count > expectedMask.count { return nil } // should not contain more values than mask
		
		var values = [OSCMessageValueProtocol?]()
		
		for idx in 0..<expectedMask.count {
			let idxOptional = expectedMask[idx].isOptional
		
			if self.indices.contains(idx) {
				// check if it's the correct base type
				if !self[idx].baseTypeMatches(type: expectedMask[idx].baseType,
											  canMatchMetaTypes: true) {
					return nil
				}
				
				switch self[idx] {
				// core types
				case let .int32(v):		values.append(v)		; continue
				case let .float32(v):	values.append(v)		; continue
				case let .string(v):	values.append(v)		; continue
				case let .blob(v):		values.append(v)		; continue
					
				// extended types
				case let .int64(v):		values.append(v)		; continue
				case let .timeTag(v):	values.append(v)		; continue
				case let .double(v):	values.append(v)		; continue
				case let .stringAlt(v):	values.append(v)		; continue
				case let .character(v):	values.append(v)		; continue
				case let .midi(v):		values.append(v)		; continue
				case let .bool(v):		values.append(v)		; continue
				case .null:				values.append(NSNull())	; continue
				}
			} else {
				switch idxOptional {
				case true:				values.append(nil)		; continue
				case false:				return nil
				}
			}
		}
		
		return values
		
	}
	
}
