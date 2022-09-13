//
//  OSCNumberValueBase.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC number value type-erased base value encapsulation.
public enum OSCNumberValueBase {
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
        case let .int(v):
            return AnyHashable(v)
        case let .float(v):
            return AnyHashable(v)
        }
    }
}

// MARK: - CustomStringConvertible

extension OSCNumberValueBase: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .int(v):
            return "\(v)"
        case let .float(v):
            return "\(v)"
        }
    }
}
