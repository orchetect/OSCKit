//
//  BinaryFloatingPoint.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

// MARK: - BinaryFloatingPoint Default Implementation

extension OSCInterpolatedValue
where Self: BinaryFloatingPoint,
      CoreOSCValue: BinaryFloatingPoint,
      OSCValueEncodingBlock == OSCValueAtomicEncoder<Self>,
      OSCValueDecodingBlock == OSCValueAtomicDecoder<Self>,
      CoreOSCValue.OSCValueEncodingBlock == OSCValueAtomicEncoder<CoreOSCValue>,
      CoreOSCValue.OSCValueDecodingBlock == OSCValueAtomicDecoder<CoreOSCValue>
{
    public static var oscEncoding: OSCValueEncodingBlock { OSCValueEncodingBlock { value in
        try CoreOSCValue.oscEncoding.block(CoreOSCValue(value))
    } }
    
    public static var oscDecoding: OSCValueDecodingBlock { OSCValueDecodingBlock { decoder in
        Self(try CoreOSCValue.oscDecoding.block(&decoder))
    } }
}

// `Float` is equivalent to `Float32` already
// extension Float: OSCInterpolatedValue { }

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Float16: OSCInterpolatedValue {
    public typealias CoreOSCValue = Float32
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80: OSCInterpolatedValue {
    public typealias CoreOSCValue = Double
}
#endif
