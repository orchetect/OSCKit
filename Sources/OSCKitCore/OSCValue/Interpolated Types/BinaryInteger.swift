//
//  BinaryInteger.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - BinaryInteger Default Implementation

extension OSCInterpolatedValue
    where Self: BinaryInteger,
    CoreOSCValue: BinaryInteger,
    OSCValueEncodingBlock == OSCValueAtomicEncoder<Self>,
    OSCValueDecodingBlock == OSCValueAtomicDecoder<Self>,
    CoreOSCValue.OSCValueEncodingBlock == OSCValueAtomicEncoder<CoreOSCValue>,
    CoreOSCValue.OSCValueDecodingBlock == OSCValueAtomicDecoder<CoreOSCValue>
{
    public static var oscEncoding: OSCValueEncodingBlock { OSCValueEncodingBlock { value in
        try CoreOSCValue.oscEncoding.block(CoreOSCValue(value))
    } }
    
    public static var oscDecoding: OSCValueDecodingBlock { OSCValueDecodingBlock { decoder in
        try await Self(CoreOSCValue.oscDecoding.block(&decoder))
    } }
}

// MARK: - Individual Conformances

extension Int: OSCInterpolatedValue {
    // even though Int64 is a possible OSC type and would be safer,
    // Int32 is by far more common and is the preferred interpolation
    public typealias CoreOSCValue = Int32
}

extension Int8: OSCInterpolatedValue {
    public typealias CoreOSCValue = Int32
}

extension Int16: OSCInterpolatedValue {
    public typealias CoreOSCValue = Int32
}

// `Int32` is already a core type

// `Int64` is already an extended type

extension UInt: OSCInterpolatedValue {
    public typealias CoreOSCValue = Int64
}

extension UInt8: OSCInterpolatedValue {
    public typealias CoreOSCValue = Int32
}

extension UInt16: OSCInterpolatedValue {
    public typealias CoreOSCValue = Int32
}

extension UInt32: OSCInterpolatedValue {
    public typealias CoreOSCValue = Int64
}

extension UInt64: OSCInterpolatedValue {
    public typealias CoreOSCValue = Int64
}
