//
//  OSCNumberValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// ------------------------------------------------------------------------
//                             **** NOTE ****
// ------------------------------------------------------------------------
// This struct is not public because it does not serve a practical purpose.
// The code works, but exists more as a proof-of-concept and may be removed
// in future.
// - Users should just use actual concrete types (Int, Int32, etc.)
//   and not use a specialized box.
// - This can't be used in an OSCValues mask since it is specialized.
// - `AnyOSCNumberValue` should be used in masks since it is type-erased.
// ------------------------------------------------------------------------

/// Opaque OSC type `OSCNumberValue`:
/// A box for OSC numeric value types.
/// Mainly employed as a return type from value masking methods.
struct OSCNumberValue<B: OSCValue> {
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

// MARK: - Equatable

extension OSCNumberValue: Equatable {
    // implementation is automatically synthesized by Swift
}

// MARK: - Hashable

extension OSCNumberValue: Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - Sendable

extension OSCNumberValue: Sendable { }

// MARK: - CustomStringConvertible

extension OSCNumberValue: CustomStringConvertible {
    public var description: String {
        "Number(\(base))"
    }
}

// MARK: - Codable

// extension OSCNumberValue: Codable { }

// MARK: - OSC Encoding

@_documentation(visibility: internal)
extension OSCNumberValue: OSCValue {
    // forward underlying type instead of using .number
    public static var oscValueToken: OSCValueToken { B.oscValueToken }
}

@_documentation(visibility: internal)
extension OSCNumberValue: OSCValueCodable { }

@_documentation(visibility: internal)
extension OSCNumberValue: OSCValueEncodable {
    public typealias OSCEncoded = B.OSCEncoded
    public typealias OSCValueEncodingBlock = B.OSCValueEncodingBlock
    public static var oscTagIdentity: OSCValueTagIdentity { B.oscTagIdentity }
    public static var oscEncoding: OSCValueEncodingBlock { B.oscEncoding }
}

@_documentation(visibility: internal)
extension OSCNumberValue: OSCValueDecodable {
    public typealias OSCDecoded = B.OSCDecoded
    public typealias OSCValueDecodingBlock = B.OSCValueDecodingBlock
    public static var oscDecoding: OSCValueDecodingBlock { B.oscDecoding }
}
