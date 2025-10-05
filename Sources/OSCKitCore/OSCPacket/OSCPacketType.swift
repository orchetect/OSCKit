//
//  OSCPacketType.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

/// Enum describing an OSC packet type.
public enum OSCPacketType {
    case message
    case bundle
}

extension OSCPacketType: Equatable { }

extension OSCPacketType: Hashable { }

extension OSCPacketType: Sendable { }
