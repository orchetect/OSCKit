//
//  OSCBundle.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2016-07-09.
//  Copyright © 2016 Steffan Andrews. All rights reserved.
//

import Foundation

// MARK: - OSCBundle

/// OSC Bundle object.
///
/// - `timeTag`: Int64 OSC time-tag
/// - `elements`: Array of `OSCBundle` and/or `OSCMessage` objects
/// - `rawData`: Set or get to parse or encode the contents.
public struct OSCBundle: OSCObject {
	
	// MARK: - Properties
	
	/// Timetag.
	/// Default value 1: means "immediate" in OSC spec.
	public var timeTag: Int64 = 1
	
	/// Elements contained within the bundle. These can be `OSCBundle` or `OSCMessage` objects.
	public var elements: [OSCObject] = []
	
	
	// MARK: - init
	
	public init() { } // empty bundle
	
	public init(withElements: [OSCObject] = [], withTimeTag: Int64 = 1) {
		timeTag = withTimeTag
		elements = withElements
	}
	
	public init(withRawData: Data) {
		rawData = withRawData
	}
	
	
	// MARK: - rawData
	
	/// Get: returns a raw OSC packet constructed out of the class's properties. Set: parses a raw OSC packet and populates the class's properties.
	///
	/// - warning: This is a computed property, so it's best to cache the result in a variable instead of calling repeatedly if the data is required more than once.
	public var rawData: Data? {
		
		get {
			
			// returns a raw OSC packet constructed out of the class's properties
			
			var data = OSCBundle.header // prime header
            data.append(timeTag.toData(.bigEndian)) // add timetag
			
			for element in elements {
				switch element {
				case is OSCBundle, is OSCMessage:
					let theElement = element
					guard let raw = theElement.rawData else {
						print("Could not get rawData from OSC chunk.")
						return nil
					}
					data.append(raw.count.int32.toData(.bigEndian))
					data.append(raw)
				default:
					print("Unexpected element found while building bundle rawData.")
				}
			}
			
			return data
		}
		
		set {
			
			// parses a raw OSC packet and populates the class's properties
			
			let len = newValue!.count
			var ppos: Int = 0 // parse byte position
			
			// validation: length. all bundles must include the header (8 bytes) and timetag (8 bytes).
			if len < 16 {
				print("OSCBundle parse error: data length too short. (Length is \(len)) Aborting.")
				return
			}
			// validation: check header
			if newValue!.subdata(in: Range(ppos...ppos+7)) != OSCBundle.header {
				print("OSCBundle parse error: bundle header is not present/correct. Aborting.")
				return
			}
			
			// set up object array
			var extractedElements = [OSCObject]()
			
			ppos += 8
			
			guard let extractedTimeTag = newValue!.subdata(in: ppos..<ppos+8).toInt64(from: .bigEndian) else {
				print("OSCBundle parse error: Could not convert timetag to Int64. Aborting.")
				return
			}
			
			ppos += 8
			
			while ppos < len {
				//int32 size chunk
				if newValue!.count - (ppos+3) < 0 { // failsafe for malformed message
					print("OSCBundle parse error: data stream ended earlier than expected. Aborting.")
					return
				}
				guard let elementSize = newValue!.subdata(in: ppos..<ppos+4).toInt32(from: .bigEndian)?.int else {
					print("OSCBundle parse error: Could not convert element size to Int32. Aborting.")
					return
				}
				
				ppos += 4
				
				// test for bundle or message
				if newValue!.count - (ppos+elementSize) < 0 { // fialsafe for malformed message
					print("OSCBundle parse error: data stream ended earlier than expected. Aborting.")
					return
				}
				let elementContents = newValue!.subdata(in: ppos..<ppos+elementSize)
				switch elementContents.appearsToBeOSCObject {
				case is OSCBundle.Type?:
					extractedElements.append(OSCBundle(withRawData: elementContents))
				case is OSCMessage.Type?:
					extractedElements.append(OSCMessage(withRawData: elementContents))
				default:
					print("OSCBundle parse error: unexpected element found.")
				}
				ppos += elementSize
			}
			
			// update exposed properties
			timeTag = extractedTimeTag
			elements = extractedElements
			
		}
		
	}
	
}


// MARK: - CustomStringConvertible

extension OSCBundle: CustomStringConvertible {
	
	public var description: String {
		
		elements.count < 1
			? "OSCBundle(timeTag: \(timeTag))"
			: "OSCBundle(timeTag: \(timeTag), elements: \(elements))"
		
	}
	
	/// Same as `description` but elements are separated with new-line characters.
	public var descriptionPretty: String {
		
		let elementsString =
			elements
			.map { "\($0)" }
			.joined(separator: "\n  ")
		
		return elements.count < 1
			? "OSCBundle(timeTag: \(timeTag))"
			: "OSCBundle(timeTag: \(timeTag)) Elements:\n  \(elementsString)"
			.trimmed
		
	}
	
}


// MARK: - Header

extension OSCBundle {
	
	/// Constant caching an OSCBundle header
	public static let header: Data =
		"#bundle"
		.toData(using: .nonLossyASCII)!
		.fourNullBytePadded
	
}

extension Data {
	
	/// A fast function to test if Data() begins with an OSC bundle header
	/// (Note: Does NOT do extensive checks to ensure data block isn't malformed)
	var appearsToBeOSCBundle: Bool {
		
		self.starts(with: OSCBundle.header)
		
	}
	
}
