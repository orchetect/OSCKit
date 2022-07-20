//
//  OSCMessageValue Number.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

public extension OSCMessageValue {
    
    /// `OSCMessageValue` meta type "Number":
    /// A box for OSC numeric value types.
    /// Mainly employed as a return type from value masking methods.
    enum Number: OSCMessageValueProtocol, Equatable, Hashable {
        
        case int32(Int32)
        case float32(Float32)
        case double(Double)
        case int64(Int64)
        
    }
    
}

public extension OSCMessageValue.Number {
    
    /// Returns the boxed value as an `Int`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    var intValue: Int {
        
        switch self {
        case .int32(let int32):
            return int32.int
            
        case .float32(let float32):
            return float32.int
            
        case .double(let double):
            return double.int
            
        case .int64(let int64):
            return int64.int
        }
        
    }
    
    /// Returns the boxed value as a `Double`, lossily converting format if necessary.
    /// Provided as a convenience. To get the actual stored value, unwrap the enum case instead.
    var doubleValue: Double {
        
        switch self {
        case .int32(let int32):
            return int32.double
            
        case .float32(let float32):
            return float32.double
            
        case .double(let double):
            return double.double
            
        case .int64(let int64):
            return int64.double
        }
        
    }
    
}
