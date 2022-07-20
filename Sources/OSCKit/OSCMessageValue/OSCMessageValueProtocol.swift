//
//  OSCMessageValueProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// Protocol that all OSC value types conform to.
public protocol OSCMessageValueProtocol { }

extension Int32                       : OSCMessageValueProtocol { }
extension Float32                     : OSCMessageValueProtocol { }
extension ASCIIString                 : OSCMessageValueProtocol { }
extension Data                        : OSCMessageValueProtocol { }
extension Int64                       : OSCMessageValueProtocol { }
extension Double                      : OSCMessageValueProtocol { }
extension ASCIICharacter              : OSCMessageValueProtocol { }
extension OSCMessageValue.MIDIMessage : OSCMessageValueProtocol { }
extension Bool                        : OSCMessageValueProtocol { }
extension NSNull                      : OSCMessageValueProtocol { }
