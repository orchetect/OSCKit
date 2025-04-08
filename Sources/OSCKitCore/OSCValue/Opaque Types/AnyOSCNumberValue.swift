//
//  AnyOSCNumberValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A meta-type used in ``OSCValues`` `masked()` to opaquely mask any OSC number type.
/// This type is not publicly initialize-able. Instead it is provided as a box for a type-erased
/// number value when masking.
///
/// - ``base`` returns the strongly-typed number.
/// - ``boolValue``, ``intValue`` and ``doubleValue`` can be used as a convenience to access the
///   base value, converting from the base type if necessary.
public struct AnyOSCNumberValue {
    /// Base value storage.
    public let base: OSCNumberValueBase
    
    init(_ base: Bool) {
        self.base = .bool(base)
    }
    
    init(_ base: some OSCValue & BinaryInteger) {
        self.base = .int(base)
    }
    
    init(_ base: some OSCValue & BinaryFloatingPoint) {
        self.base = .float(base)
    }
    
    /// Returns the boxed value as an `Bool`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var boolValue: Bool {
        switch base {
        case let .bool(v):
            v
        case let .int(v):
            Int(v) >= 1
        case let .float(v):
            Double(v) >= 1.0
        }
    }
    
    /// Returns the boxed value as an `Int`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var intValue: Int {
        switch base {
        case let .bool(v):
            v ? 1 : 0
        case let .int(v):
            Int(v)
        case let .float(v):
            Int(v)
        }
    }
    
    /// Returns the boxed value as a `Double`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var doubleValue: Double {
        switch base {
        case let .bool(v):
            v ? 1.0 : 0.0
        case let .int(v):
            Double(v)
        case let .float(v):
            Double(v)
        }
    }
}

@_documentation(visibility: internal)
extension AnyOSCNumberValue: OSCValueMaskable {
    public static let oscValueToken: OSCValueToken = .number
}

// MARK: - Equatable

extension AnyOSCNumberValue: Equatable {
    // implementation is automatically synthesized by Swift
}

// MARK: - Hashable

extension AnyOSCNumberValue: Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - Sendable

extension AnyOSCNumberValue: Sendable { }

// MARK: - CustomStringConvertible

extension AnyOSCNumberValue: CustomStringConvertible {
    public var description: String {
        "\(base)"
    }
}

// MARK: - Codable

// extension OSCNumberValue: Codable { }
