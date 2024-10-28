//
//  StringProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - StringProtocol Default Implementation

extension OSCInterpolatedValue
    where Self: StringProtocol,
//      CoreOSCValue == String,
    OSCValueEncodingBlock == OSCValueAtomicEncoder<Self>,
    OSCValueDecodingBlock == OSCValueAtomicDecoder<Self>,
    CoreOSCValue.OSCValueEncodingBlock == OSCValueAtomicEncoder<CoreOSCValue>,
    CoreOSCValue.OSCValueDecodingBlock == OSCValueAtomicDecoder<CoreOSCValue>
{
    public typealias CoreOSCValue = String
    
    public static var oscEncoding: OSCValueEncodingBlock { OSCValueEncodingBlock { value in
        try CoreOSCValue.oscEncoding.block(CoreOSCValue(value))
    } }
    
    public static var oscDecoding: OSCValueDecodingBlock { OSCValueDecodingBlock { decoder in
        try await Self(stringLiteral: CoreOSCValue.oscDecoding.block(&decoder))
    } }
}

// MARK: - Individual Conformances

// `String` is already a core type

extension Substring: OSCInterpolatedValue {
    public typealias CoreOSCValue = String
}
