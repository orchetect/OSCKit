//
//  OSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// Protocol to which all compatible OSC value types conform.
public protocol OSCValue: Equatable, Hashable, OSCValueCodable {
    /// Core concrete type that the value uses for storage and encoding.
    static var oscCoreType: OSCValueMask.Token { get }
}
