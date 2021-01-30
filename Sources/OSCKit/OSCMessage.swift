//
//  OSCMessage.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

// MARK: - OSCMessage

/// OSC Message object.
///
/// - `address`: OSC address string (ASCII only)
/// - `values`: `[OSCMessageValue]`
/// - `rawData`: Set or get to parse or encode the contents.
public struct OSCMessage: OSCObject {
	
	// MARK: - Properties
	
	/// OSC message address.
	public let address: ASCIIString
    
	/// OSC values contained within the message.
	public let values: [OSCMessageValue]
	
	
	// MARK: - init
	
	@inlinable public init(address: ASCIIString,
						   values: [OSCMessageValue] = []) {
		
		self.address = address
		self.values = values
		self.rawData = Self.generateRawData(address: address,
											values: values)
		
	}
    
	/// Initialize by parsing raw OSC message data bytes.
	public init(from rawData: Data) throws {
		
		// cache raw data
		
		self.rawData = rawData
		
		// parse a raw OSC packet and populates the struct's properties
		
		let len = rawData.count
		var ppos: Int = 0 // parse byte position
		var remainingData: Data
		
		// validation: length. all bundles must include the header (8 bytes) and timetag (8 bytes).
		if len % 4 != 0 { // isn't a multiple of 4 bytes (as per OSC spec)
			throw DecodeError.malformed("Length not a multiple of 4 bytes.")
		}
		// validation: check header
		guard rawData.appearsToBeOSCMessage else {
			throw DecodeError.malformed("Does not start with an address.")
		}
		
		// OSC address
		
		guard let addressPull = rawData.extractNull4ByteTerminatedASCIIString() else {
			throw DecodeError.malformed("Address string could not be parsed.")
		}
		
		let extractedAddress = addressPull.asciiStringValue
		ppos += addressPull.byteCount
		
		// test for presence of values
		
		remainingData = rawData.subdata(in: ppos..<rawData.count)
		
		// OSC-type chunk
		
		var extractedOSCtypes: ASCIIString
		
		guard let oscTypesPull = remainingData.extractNull4ByteTerminatedASCIIString() else {
			throw DecodeError.malformed("Couldn't extract OSC-type chunk.")
		}
		
		extractedOSCtypes = oscTypesPull.asciiStringValue
		ppos += oscTypesPull.byteCount
		
		// set up value array
		var extractedValues = [OSCMessageValue]()
		
		for char in extractedOSCtypes.stringValue {
			remainingData = rawData.subdata(in: ppos..<rawData.count)
			switch char {
			// core types
			case "i":
				if let pull = remainingData.extractInt32() {
					extractedValues.append(.int32(pull.int32Value))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("Int32 value couldn't be read.")
				}
				
			case "f":
				if let pull = remainingData.extractFloat32() {
					extractedValues.append(.float32(pull.float32Value))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("Float32 value couldn't be read.")
				}
				
			case "s":
				if let pull = remainingData.extractNull4ByteTerminatedASCIIString() {
					extractedValues.append(.string(pull.asciiStringValue))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("String value couldn't be read.")
				}
				
			case "b":
				if let pull = remainingData.extractBlob() {
					extractedValues.append(.blob(pull.blobValue))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("Blob data couldn't be read.")
				}
				
			// extended types:
				
			case "h":	// 64 bit big-endian two's complement integer
				if let pull = remainingData.extractInt64() {
					extractedValues.append(.int64(pull.int64Value))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("Int64 value couldn't be read.")
				}
				
			case "t":	// 64 bit big-endian two's complement integer
				if let pull = remainingData.extractInt64() {
					extractedValues.append(.timeTag(pull.int64Value))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("TimeTag value couldn't be read.")
				}
				
			case "d":
				if let pull = remainingData.extractDouble() {
					extractedValues.append(.double(pull.doubleValue))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("Double value couldn't be read.")
				}
				
			case "S":
				if let pull = remainingData.extractNull4ByteTerminatedASCIIString() {
					extractedValues.append(.stringAlt(pull.asciiStringValue))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("StringAlt value couldn't be read.")
				}
				
			case "c":
				if let pull = remainingData.extractInt32() {
					let asciiCharNum = Int(pull.int32Value)
					guard let asciiChar = ASCIICharacter(asciiCharNum) else {
						throw DecodeError.malformed("Character value couldn't be read. Could not form a Unicode scalar from the value.")
					}
					extractedValues.append(.character(asciiChar))
					ppos += pull.byteCount
				} else {
					throw DecodeError.malformed("Character value couldn't be read.")
				}
				
			case "m":
				if let pull = remainingData.extract(byteCount: 4) {
					extractedValues.append(.midi(OSCMIDIMessage(portID: pull[0],
																status: pull[1],
																data1: pull[2],
																data2: pull[3])))
					ppos += 4
				} else {
					throw DecodeError.malformed("MIDI value couldn't be read.")
				}
				
			case "T":
				extractedValues.append(.bool(true))
				
			case "F":
				extractedValues.append(.bool(false))
				
			case "N":
				extractedValues.append(.null)
				
			case ",", "\0":
				break // ignore
				
			default:
				throw DecodeError.unexpectedType(char)
				
			}
		}
		
		// update public properties
		address = extractedAddress
		values = extractedValues
		
	}
	
	
	// MARK: - rawData
	
	public let rawData: Data
	
	/// Internal: generate raw OSC bytes from struct's properties
	@usableFromInline
	internal static func generateRawData(address: ASCIIString,
										 values: [OSCMessageValue]) -> Data {
		
		// returns a raw OSC packet constructed out of the struct's properties
		
		var data = Data()
		var buildDataTypes = "," // prime the types chunk
		var buildValues = Data() // prime the values chunk
		
		// add OSC address
		let addressData = address.rawData
		
		data.append(addressData.fourNullBytePadded)
		
		// iterate data types in values array to prepare ODC-type string
		for value in values {
			switch value {
			// core types
			case let .int32(val):
				buildDataTypes += "i"
				buildValues += val.toData(.bigEndian)
				
			case let .float32(val):
				buildDataTypes += "f"
				buildValues += val.toData(.bigEndian)
				
			case let .string(val):
				buildDataTypes += "s"
				buildValues += val.rawData.fourNullBytePadded
				
			case let .blob(val):
				buildDataTypes += "b"
				// blob: An int32 size count, followed by that many 8-bit bytes of arbitrary binary data, followed by 0-3 additional zero-bytes to make the total number of bits a multiple of 32.
				buildValues += val.count.int32.toData(.bigEndian)
				buildValues += val.fourNullBytePadded
				
			// extended types
			case let .int64(val):
				buildDataTypes += "h"
				buildValues += val.toData(.bigEndian)
				
			case let .timeTag(val):
				buildDataTypes += "t"
				buildValues += val.toData(.bigEndian)
				
			case let .double(val):
				buildDataTypes += "d"
				buildValues += val.toData(.bigEndian)
				
			case let .stringAlt(val):
				buildDataTypes += "S"
				buildValues += val.rawData.fourNullBytePadded
				
			case let .character(val):
				buildDataTypes += "c"
				buildValues += val.asciiValue.int32.toData(.bigEndian)
				
			case let .midi(val):
				buildDataTypes += "m"
				buildValues += [val.portID, val.status, val.data1, val.data2].data
				
			case let .bool(val):
				buildDataTypes += val ? "T" : "F"
				
			case .null:
				buildDataTypes += "N"
				
			}
		}
		
		// assemble OSC-type and values chunk
		data += buildDataTypes.toData(using: .nonLossyASCII)!.fourNullBytePadded // toData should never fail here
		data += buildValues
		
		// return data
		return data
		
	}
	
}


// MARK: - CustomStringConvertible

extension OSCMessage: CustomStringConvertible {
	
	public var description: String {
		values.count < 1
			? "OSCMessage(address: \"\(address)\")"
			: "OSCMessage(address: \"\(address)\", values: [\(values.mapDebugString(withLabel: true))])"
	}
	
	/// Same as `description` but values are separated with new-line characters and indented.
	public var descriptionPretty: String {
		
		values.count < 1
			? "OSCMessage(address: \"\(address)\")"
			: "OSCMessage(address: \"\(address)\") Values:\n  \(values.mapDebugString(withLabel: true, separator: "\n  "))"
			.trimmed
		
	}
	
}


// MARK: - Header

extension OSCMessage {
	
	/// Constant caching an OSCMessage header
	public static let header: Data = "/".toData(using: .nonLossyASCII)!
	
}

extension Data {
	
	/// A fast test if Data() appears tor be an OSC message
	/// (Note: Does NOT do extensive checks to ensure message isn't malformed)
	@inlinable public var appearsToBeOSCMessage: Bool {
		
		// it's possible an OSC address won't start with "/", but it should!
		self.starts(with: OSCMessage.header)
		
	}
	
}
