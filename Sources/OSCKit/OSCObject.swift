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
	@inlinable func parseOSC() throws -> OSCBundlePayload? {
		
		if appearsToBeOSCBundle {
			return .bundle(try OSCBundle(from: self))
		} else if appearsToBeOSCMessage {
			return .message(try OSCMessage(from: self))
		}
		
		return nil
		
	}
	
}

/// Enum describing an OSC message type.
public enum OSCBundlePayload {
	
	case message(OSCMessage)
	case bundle(OSCBundle)
	
	/// Returns the OSC object's raw data bytes
	public var rawData: Data {
		switch self {
		case .message(let element):
			return element.rawData
			
		case .bundle(let element):
			return element.rawData
			
		}
	}
	
	/// Syntactic sugar convenience
	public init(_ message: OSCMessage) {
		self = .message(message)
	}
	
	/// Syntactic sugar convenience
	public init(_ bundle: OSCBundle) {
		self = .bundle(bundle)
	}
	
	/// Syntactic sugar convenience
	public static func message(address: ASCIIString, values: [OSCMessageValue] = []) -> Self {
		
		.message(OSCMessage(address: address,
							values: values))
		
	}
	
	/// Syntactic sugar convenience
	public static func bundle(elements: [OSCBundlePayload], timeTag: Int64 = 1) -> Self {
		
		.bundle(OSCBundle(elements: elements,
						  timeTag: timeTag))
		
	}
	
}


// MARK: - CustomStringConvertible

extension OSCBundlePayload: CustomStringConvertible {
	
	public var description: String {
		switch self {
		case .message(let element):
			return element.description
			
		case .bundle(let element):
			return element.description
			
		}
	}
	
}
