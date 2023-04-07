//
//  OSCTimeTag.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC Time Tag.
///
/// > OSC 1.0 Spec:
/// >
/// > Time tags are represented by a 64 bit fixed point number. The first 32 bits specify the number
/// > of seconds since midnight on January 1, 1900, and the last 32 bits specify fractional parts of
/// > a second to a precision of about 200 picoseconds. This is the representation used by Internet
/// > NTP timestamps.
/// >
/// > The time tag value consisting of 63 zero bits followed by a one in the least significant bit
/// > (essentially a `UInt64` integer value of 1) is a special case meaning 'immediately.'
public struct OSCTimeTag {
    /// NTP time format era number.
    ///
    /// The OSC Time Tag encoding uses NTPv3 time encoding which specifies 32 bits for seconds and
    /// 32 bits for fractional sections. Given that the prime epoch (era 0) is the year 1990, 32 bit
    /// seconds storage rolls over approximate every 136 years. Every time this rollover occurs, the
    /// era increments by 1.
    ///
    /// Hence, the period between 1 Jan 1900 and 7 Feb 2036 is considered era 0. Dates after 7 Feb
    /// 2036 for the following 136 years are considered era 1. And so on.
    ///
    /// - Note: See https://www.eecis.udel.edu/~mills/y2k.html for details.
    public let era: Int
    
    /// Raw value type (aka `UInt64`)
    public typealias RawValue = UInt64
    
    /// Raw Time Tag value as encoded in OSC.
    public let rawValue: RawValue
}

// MARK: - Equatable, Hashable

extension OSCTimeTag: Equatable, Hashable {
    // implementation is automatically synthesized by Swift
}

// MARK: - CustomStringConvertible

extension OSCTimeTag: CustomStringConvertible {
    public var description: String {
        if rawValue == 1 {
            return "1 (immediate)"
        }
        
        switch era {
        case 0:
            return "\(rawValue)"
        default:
            return "\(rawValue)-era:\(era)"
        }
    }
}
