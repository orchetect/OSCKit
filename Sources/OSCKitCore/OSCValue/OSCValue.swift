//
//  OSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

/// Protocol to which all compatible OSC value types conform.
public protocol OSCValue: Equatable, Hashable, OSCValueCodable, OSCValueMaskable { }
