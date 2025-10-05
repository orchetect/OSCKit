//
//  OSCPacket.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC packet containing a bundle or message.
public enum OSCPacket {
    /// OSC bundle.
    case bundle(_ bundle: OSCBundle)
    
    /// OSC message.
    case message(_ message: OSCMessage)
}

// MARK: - Equatable

extension OSCPacket: Equatable { }

// MARK: - Hashable

extension OSCPacket: Hashable { }

// MARK: - Sendable

extension OSCPacket: Sendable { }

// MARK: - CustomStringConvertible

extension OSCPacket: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .bundle(bundle): bundle.description
        case let .message(message): message.description
        }
    }
    
    /// Same as `description` but values are separated with new-line characters and indented.
    public var descriptionPretty: String {
        switch self {
        case let .bundle(bundle): bundle.descriptionPretty
        case let .message(message): message.descriptionPretty
        }
    }
}
