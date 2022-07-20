//
//  OSCMessageConcreteValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// Protocol that all OSC value types conform to.
public protocol OSCMessageConcreteValue { }

// true concrete types
extension Int32                       : OSCMessageConcreteValue { }
extension Float32                     : OSCMessageConcreteValue { }
extension ASCIIString                 : OSCMessageConcreteValue { }
extension Data                        : OSCMessageConcreteValue { }
extension Int64                       : OSCMessageConcreteValue { }
extension Double                      : OSCMessageConcreteValue { }
extension ASCIICharacter              : OSCMessageConcreteValue { }
extension OSCMessageValue.MIDIMessage : OSCMessageConcreteValue { }
extension Bool                        : OSCMessageConcreteValue { }
extension NSNull                      : OSCMessageConcreteValue { }

// substitute types
extension Int                         : OSCMessageConcreteValue { }
extension String                      : OSCMessageConcreteValue { }
extension Character                   : OSCMessageConcreteValue { }

// meta types
extension OSCMessageValue.Number      : OSCMessageConcreteValue { }
