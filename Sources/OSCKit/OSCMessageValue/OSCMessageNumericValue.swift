//
//  OSCMessageNumericValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// A box for OSC numeric value types.
/// Mainly employed in value masking.
public enum OSCMessageNumericValue: OSCMessageValueProtocol {
    
    case int32(Int32)
    case float32(Float32)
    case double(Double)
    case int64(Int64)
    
}
