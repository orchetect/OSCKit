//
//  OSCInterpolatedValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Interpolated types

/// Protocol to which all interpolated OSC value types conform.
/// This includes all convenience types that are not themselves core OSC value types.
///
/// For example, types like `Int8` and `Int16` gain ``OSCValue`` compatibility by way of `OSCInterpolatedValue` conformance: they will be transparently encoded as the most common related OSC core type (which this example would be `Int32`).
public protocol OSCInterpolatedValue: OSCValue
    where OSCEncoded == Self,
    OSCDecoded == Self
{
    associatedtype CoreOSCValue: OSCValue
}

// MARK: - Default Implementation

extension OSCInterpolatedValue {
    public static var oscTagIdentity: OSCValueTagIdentity {
        CoreOSCValue.oscTagIdentity
    }
    
    public static var oscValueToken: OSCValueToken {
        CoreOSCValue.oscValueToken
    }
}
