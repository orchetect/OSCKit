//
//  OSCMessage.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation
@_implementationOnly import OTCore

// MARK: - OSCMessage

/// OSC Message object.
///
/// - `address`: OSC address string (ASCII only)
/// - `values`: `[OSCMessageValue]`
/// - `rawData`: Set or get to parse or encode the contents.
public struct OSCMessage: OSCObject {
	
	// MARK: - Properties
	
	/// OSC message address.
	public var address = "/"
    
	/// OSC values contained within the message.
	public var values: [OSCMessageValue] = []
	
	
	// MARK: - init
	
	/// Initialize with default "/" address and no values.
	@inlinable public init() { }
    
	@inlinable public init(address: String, values: [OSCMessageValue] = []) {
		self.address = address
		self.values = values
	}
    
	/// Initialize by parsing raw OSC message data bytes.
	@inlinable public init(from rawData: Data) {
		self.rawData = rawData
	}
	
	
	// MARK: - rawData
	
	/// Get: returns a raw OSC packet constructed out of the class's properties. Set: parses a raw OSC packet and populates the class's properties.
	///
	/// - warning: This is a computed property, so it's best to cache the result in a variable instead of calling repeatedly if the data is required more than once.
	public var rawData: Data? {
		
		get {
			
			// returns a raw OSC packet constructed out of the class's properties
			
			var data = Data()
			var buildDataTypes = "," // prime the types chunk
			var buildValues = Data() // prime the values chunk
			
			// add OSC address
			guard let addressData = address.toData(using: .nonLossyASCII) else {
				Log.debug("OSCMessage rawData error: could not encode address as Data. Address string may contain invalid non-ASCII characters.")
				return nil
			}
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
					
					guard let valData = val.toData(using: .nonLossyASCII) else {
						Log.debug("OSCMessage rawData error: could not encode string value as Data.")
						return nil
					}
					
					buildValues += valData.fourNullBytePadded
					
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
					
					guard let valData = val.toData(using: .nonLossyASCII) else {
						Log.debug("OSCMessage rawData error: could not encode stringAlt value as Data.")
						return nil
					}
					
					buildValues += valData.fourNullBytePadded
					
				case let .character(val):
					buildDataTypes += "c"
					guard let asciiCharNum = val.asciiValue else {
						Log.debug("OSCMessage rawData error: could not convert character to ASCII char number. It may not be a valid ASCII character.")
						return nil
					}
					buildValues += asciiCharNum.int32.toData(.bigEndian)
					
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
		
		set {
			
			// parses a raw OSC packet and populates the class's properties
			
			let len = newValue!.count
			var ppos: Int = 0 // parse byte position
			var remainingData: Data
			
			// validation: length. all bundles must include the header (8 bytes) and timetag (8 bytes).
			if len % 4 != 0 { // isn't a multiple of 4 bytes (as per OSC spec)
				Log.debug("OSCMessage parse error: length not a multiple of 4 bytes.")
				return
			}
			// validation: check header
			if newValue!.appearsToBeOSCMessage == false {
				Log.debug("OSCMessage parse error: does not start with an address. Aborting.")
				return
			}
			
			// OSC address
			var extractedAddress = ""
			if let pull = newValue!.extractNull4ByteTerminatedString() {
				extractedAddress = pull.stringValue
				ppos += pull.byteCount
			} else {
				Log.debug("OSCMessage parse error: address string could not be parsed. Aborting.")
				return
			}
			
			// test for presence of values
			
			remainingData = newValue!.subdata(in: ppos..<newValue!.count)
			
			// OSC-type chunk
			var extractedOSCtypes = ""
			if let pull = remainingData.extractNull4ByteTerminatedString() {
				extractedOSCtypes = pull.stringValue
				ppos += pull.byteCount
			} else {
				Log.debug("OSCMessage parse error: couldn't extract OSC-type chunk.")
				return
			}
			
			// set up value array
			var extractedValues = [OSCMessageValue]()
			
			for char in extractedOSCtypes {
				remainingData = newValue!.subdata(in: ppos..<newValue!.count)
				switch char {
				// core types
				case "i":
					if let pull = remainingData.extractInt32() {
						extractedValues.append(.int32(pull.int32Value))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: int32 value couldn't be read. Aborting.")
						return
					}
					
				case "f":
					if let pull = remainingData.extractFloat32() {
						extractedValues.append(.float32(pull.float32Value))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: float32 value couldn't be read. Aborting.")
						return
					}
					
				case "s":
					if let pull = remainingData.extractNull4ByteTerminatedString() {
						extractedValues.append(.string(pull.stringValue))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: string value couldn't be read. Aborting.")
						return
					}
					
				case "b":
					if let pull = remainingData.extractBlob() {
						extractedValues.append(.blob(pull.blobValue))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: blob data couldn't be read. Aborting.")
						return
					}
					
				// extended types:
					
				case "h":	// 64 bit big-endian two's complement integer
					if let pull = remainingData.extractInt64() {
						extractedValues.append(.int64(pull.int64Value))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: int64 value couldn't be read. Aborting.")
						return
					}
					
				case "t":	// 64 bit big-endian two's complement integer
					if let pull = remainingData.extractInt64() {
						extractedValues.append(.timeTag(pull.int64Value))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: timeTag value couldn't be read. Aborting.")
						return
					}
					
				case "d":
					if let pull = remainingData.extractDouble() {
						extractedValues.append(.double(pull.doubleValue))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: double value couldn't be read. Aborting.")
						return
					}
					
				case "S":
					if let pull = remainingData.extractNull4ByteTerminatedString() {
						extractedValues.append(.stringAlt(pull.stringValue))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: string value couldn't be read. Aborting.")
						return
					}
					
				case "c":
					if let pull = remainingData.extractInt32() {
						guard let asciiCharNum = Int(exactly: pull.int32Value) else {
							Log.debug("OSCMessage parse error: char data couldn't be read. Aborting.")
							return
						}
						guard let scalar = UnicodeScalar(asciiCharNum) else {
							Log.debug("OSCMessage parse error: char data couldn't be read. Aborting.")
							return
						}
						extractedValues.append(.character(Character(scalar)))
						ppos += pull.byteCount
					} else {
						Log.debug("OSCMessage parse error: char value couldn't be read. Aborting.")
						return
					}
					
				case "m":
					if let pull = remainingData.extract(byteCount: 4) {
						extractedValues.append(.midi(OSCMIDIMessage(portID: pull[0], status: pull[1], data1: pull[2], data2: pull[3])))
						ppos += 4
					} else {
						Log.debug("OSCMessage parse error: midi value couldn't be read. Aborting.")
						return
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
					Log.debug("OSCMessage parse error: unexpected osc-type encountered: \"\(char)\". Aborting.")
					return
					
				}
			}
			
			// update exposed properties
			address = extractedAddress
			values = extractedValues
			
		}
		
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
