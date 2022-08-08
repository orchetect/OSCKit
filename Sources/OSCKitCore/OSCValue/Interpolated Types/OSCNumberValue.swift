//
//  OSCNumberValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

// TODO: rethink this implementation?

/// `OSCValue` meta type `OSCNumberValue`:
/// A box for OSC numeric value types.
/// Mainly employed as a return type from value masking methods.
public struct OSCNumberValue<T: Numeric & Codable> {
    public let value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    /// Returns the boxed value as an `Int`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var intValue: Int {
        switch value {
        case let v as Int:     return v
        case let v as Int8:    return Int(v)
        case let v as Int16:   return Int(v)
        case let v as Int32:   return Int(v)
        case let v as Int64:   return Int(v)
        case let v as UInt:    return Int(v)
        case let v as UInt8:   return Int(v)
        case let v as UInt16:  return Int(v)
        case let v as UInt32:  return Int(v)
        case let v as UInt64:  return Int(v)
        case let v as Float:   return Int(v)
        case let v as Float32: return Int(v)
        case let v as Double:  return Int(v)
        default: return 0
        }
    }
    
    /// Returns the boxed value as a `Double`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var doubleValue: Double {
        switch value {
        case let v as Int:     return Double(v)
        case let v as Int8:    return Double(v)
        case let v as Int16:   return Double(v)
        case let v as Int32:   return Double(v)
        case let v as Int64:   return Double(v)
        case let v as UInt:    return Double(v)
        case let v as UInt8:   return Double(v)
        case let v as UInt16:  return Double(v)
        case let v as UInt32:  return Double(v)
        case let v as UInt64:  return Double(v)
        case let v as Float:   return Double(v)
        case let v as Float32: return Double(v)
        case let v as Double:  return v
        default: return 0
        }
    }
}

// MARK: - Equatable, Hashable

extension OSCNumberValue: Equatable, Hashable where T : Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - CustomStringConvertible

extension OSCNumberValue: CustomStringConvertible {
    public var description: String {
        "OSCNumberValue(\(value))"
    }
}

// MARK: - Codable

extension OSCNumberValue: Codable where T : Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - OSC Encoding

//extension OSCNumberValue: OSCInterpolatedValue where T.CoreOSCValue: OSCValue {
//    public typealias CoreOSCValue = T.CoreOSCValue
//    
//    // TODO: figure out how to implement this
//    
//    public func oscEncode() -> Data {
//        value.oscEncode()
//    }
//    
//    public func oscDecode(_ data: Data) -> Self {
//        value.oscDecode(data)
//    }
//}
