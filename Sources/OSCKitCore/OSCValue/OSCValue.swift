//
//  OSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

/// Protocol to which all compatible OSC value types conform.
public protocol OSCValue: Equatable, Hashable, OSCValueCodable, OSCValueMaskable { }
