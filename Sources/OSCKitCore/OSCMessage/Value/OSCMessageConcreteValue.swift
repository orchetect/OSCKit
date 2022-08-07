//
//  OSCMessageConcreteValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// Protocol that all OSC value types conform to.
public protocol OSCMessageConcreteValue { }

// true concrete types
extension Int32: OSCMessageConcreteValue { }
extension Float32: OSCMessageConcreteValue { }
extension ASCIIString: OSCMessageConcreteValue { }
extension Data: OSCMessageConcreteValue { }
extension Int64: OSCMessageConcreteValue { }
extension Double: OSCMessageConcreteValue { }
extension ASCIICharacter: OSCMessageConcreteValue { }
extension OSCMessage.Value.MIDIMessage: OSCMessageConcreteValue { }
extension Bool: OSCMessageConcreteValue { }
extension NSNull: OSCMessageConcreteValue { }

extension OSCTimeTag: OSCMessageConcreteValue { }
extension UInt64: OSCMessageConcreteValue { }

// substitute types
extension Int: OSCMessageConcreteValue { }
extension String: OSCMessageConcreteValue { }
extension Character: OSCMessageConcreteValue { }

// meta types
extension OSCMessage.Value.Number: OSCMessageConcreteValue { }
