//
//  OSCNumberValueBase.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased OSC number value base value encapsulation.
public enum OSCNumberValueBase {
    /// Boolean value.
    case bool(Bool)
    
    /// Integer value.
    case int(any(OSCValue & BinaryInteger))
    
    /// Floating-point value.
    case float(any(OSCValue & BinaryFloatingPoint))
}

// MARK: - Equatable

extension OSCNumberValueBase: Equatable {
    public static func == (lhs: OSCNumberValueBase, rhs: OSCNumberValueBase) -> Bool {
        lhs.anyHashable() == rhs.anyHashable()
    }
}

// MARK: - Hashable

extension OSCNumberValueBase: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .bool(v):
            hasher.combine(v)
        case let .int(v):
            hasher.combine(v)
        case let .float(v):
            hasher.combine(v)
        }
    }
}

extension OSCNumberValueBase {
    /// Unwraps the base value and returns it as an `AnyHashable` instance.
    public func anyHashable() -> AnyHashable {
        switch self {
        case let .bool(v):
            AnyHashable(v)
        case let .int(v):
            AnyHashable(v)
        case let .float(v):
            AnyHashable(v)
        }
    }
}

// MARK: - Sendable

extension OSCNumberValueBase: Sendable { }

// MARK: - CustomStringConvertible

extension OSCNumberValueBase: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .bool(v):
            "\(v)"
        case let .int(v):
            "\(v)"
        case let .float(v):
            "\(v)"
        }
    }
}
