//
//  Value Number.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCMessage.Value {
    /// `OSCMessage.Value` meta type `Number`:
    /// A box for OSC numeric value types.
    /// Mainly employed as a return type from value masking methods.
    public enum Number: Equatable, Hashable {
        case int32(Int32)
        case float32(Float32)
        case double(Double)
        case int64(Int64)
    }
}

extension OSCMessage.Value.Number {
    /// Returns the boxed value as an `Int`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var intValue: Int {
        switch self {
        case let .int32(int32):
            return int32.int
            
        case let .float32(float32):
            return float32.int
            
        case let .double(double):
            return double.int
            
        case let .int64(int64):
            return int64.int
        }
    }
    
    /// Returns the boxed value as a `Double`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    public var doubleValue: Double {
        switch self {
        case let .int32(int32):
            return int32.double
            
        case let .float32(float32):
            return float32.double
            
        case let .double(double):
            return double.double
            
        case let .int64(int64):
            return int64.double
        }
    }
}
