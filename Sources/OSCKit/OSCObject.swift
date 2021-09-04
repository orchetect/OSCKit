//
//  OSCObject.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation
import SwiftASCII

// MARK: - OSCObject

/// Protocol applied to OSC data objects
public protocol OSCObject {
	
	/// Returns a raw OSC packet constructed from the struct's properties
	var rawData: Data { get }
	
	/// Initialize by parsing raw OSC packet data bytes.
	init(from rawData: Data) throws
	
}


// MARK: - appearsToBeOSC

public extension Data {
	
	/// Test if `Data` appears to be an OSC bundle or OSC message. (Basic validation)
	///
	/// Returns a type if validation succeeds, otherwise:
	/// Returns `nil` if neither.
	@inlinable var appearsToBeOSC: OSCObjectType? {
		
		if appearsToBeOSCBundle {
			return .bundle
		} else if appearsToBeOSCMessage {
			return .message
		}
		
		return nil
		
	}
	
}


// MARK: - OSCObjectType

/// Enum describing an OSC message type.
public enum OSCObjectType {
	
	case message
	case bundle
	
}


// MARK: - OSCBundlePayload

public extension Data {
	
	/// Parses raw data and returns valid OSC objects if data is successfully parsed as OSC.
	///
	/// Returns `nil` if neither.
	@inlinable func parseOSC() throws -> OSCPayload? {
		
		if appearsToBeOSCBundle {
			return .bundle(try OSCBundle(from: self))
		} else if appearsToBeOSCMessage {
			return .message(try OSCMessage(from: self))
		}
		
		return nil
		
	}
	
}

