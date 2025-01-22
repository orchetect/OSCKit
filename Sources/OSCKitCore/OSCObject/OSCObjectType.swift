//
//  OSCObjectType.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

/// Enum describing an OSC message type.
public enum OSCObjectType: Equatable, Hashable, Sendable {
    case message
    case bundle
}
