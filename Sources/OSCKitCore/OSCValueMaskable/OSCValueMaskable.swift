//
//  OSCValueMaskable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol which all maskable ``OSCValue`` types conform.
public protocol OSCValueMaskable: SendableMetatype {
    /// Token describing the OSC value's OSC type.
    static var oscValueToken: OSCValueToken { get }
}

extension OSCValueMaskable {
    /// Token describing the OSC value's OSC type.
    public var oscValueToken: OSCValueToken { Self.oscValueToken }
}
