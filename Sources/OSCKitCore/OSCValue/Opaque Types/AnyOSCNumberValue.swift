//
//  AnyOSCNumberValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// A meta-type used in `OSCValues.masked()` to opaquely mask any OSC number type.
/// This type is not publicly initializable. Instead it is provided as a box for a type-erased number value when masking.
///
/// - `base` returns the strongly-typed number.
/// - `intValue` and `doubleValue` can be used as a convenience to access the base value, converting from the base type if necessary.
public struct AnyOSCNumberValue {
    /// Base value storage.
    public let base: OSCNumberValueBase
    
    init<B: OSCValue & BinaryInteger>(_ base: B) {
        self.base = .int(base)
    }
    
    init<B: OSCValue & BinaryFloatingPoint>(_ base: B) {
        self.base = .float(base)
    }
    
    /// Returns the boxed value as an `Int`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var intValue: Int {
        switch base {
        case let .int(v):
            return Int(v)
        case let .float(v):
            return Int(v)
        }
    }
    
    /// Returns the boxed value as a `Double`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var doubleValue: Double {
        switch base {
        case let .int(v):
            return Double(v)
        case let .float(v):
            return Double(v)
        }
    }
}

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

// MARK: - CustomStringConvertible

extension AnyOSCNumberValue: CustomStringConvertible {
    public var description: String {
        "OSCNumberValue(\(base))"
    }
}

// MARK: - Codable

// extension OSCNumberValue: Codable { }
