//
//  OSCAddressPattern.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// OSC Address Pattern
///
/// An OSC address pattern is a path string that may contain certain wildcards and pattern matching
/// sequences.
///
/// > [OSC 1.0 Spec](http://opensoundcontrol.org/spec-1_0.html):
/// >
/// > - OSC server dispatches to all OSC Method subscribers that match the address pattern.
/// > - Address path components are known as Containers, and the final path component is the Method
/// >   name.
/// > - Address patterns may or may not contain any wildcards. If no wildcards are contained, then the
/// >   address matches if it matches verbatim.
/// > - All the matching OSC Methods are invoked with the same argument data, namely, the OSC
/// >   Arguments in the OSC Message.
/// > - An OSC Address Pattern matches an OSC Address if:
/// >   1. The OSC Address and the OSC Address Pattern contain the same number of parts; and
/// >   2. Each part of the OSC Address Pattern matches the corresponding part of the OSC Address.
/// >
/// > These are the matching rules for characters in the OSC Address Pattern:
/// > - `?` in the OSC Address Pattern matches any single character
/// > - `*` in the OSC Address Pattern matches any sequence of zero or more characters
/// > - `[chars]` - a string of characters in square brackets in the OSC Address Pattern matches any
/// >   character in the string. Inside square brackets, the minus sign (`-`) and exclamation point
/// >   (`!`) have special meanings:
/// >   - Two characters separated by a minus sign indicate the range of characters between the given
/// >     two in ASCII collating sequence. (A minus sign at the end of the string has no special
/// >     meaning.)
/// >   - An exclamation point at the beginning of a bracketed string negates the sense of the list,
/// >     meaning that the list matches any character not in the list. (An exclamation point anywhere
/// >     besides the first character after the open bracket has no special meaning.)
/// > - `{foo,bar}` - A comma-separated list of strings enclosed in curly braces in the OSC Address
/// >   Pattern matches any of the strings in the list.
/// > - Any other character in an OSC Address Pattern can match only the same character.
///
/// > [OSC 1.1 Spec](http://opensoundcontrol.org/spec-1_1.html):
/// >
/// > The 1.1 spec was never formalized, but the white-paper is available.
/// >
/// > - Inherits OSC 1.0 pattern matching and adds the `//` operator
///
public struct OSCAddressPattern {
    /// OSC Address storage.
    let rawAddress: String
    
    /// Raw string data cache.
    let rawData: Data
}

// MARK: - Equatable

extension OSCAddressPattern: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawAddress == rhs.rawAddress
    }
}

// MARK: - Hashable

extension OSCAddressPattern: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawAddress)
    }
}

// MARK: - ExpressibleByStringLiteral

extension OSCAddressPattern: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral: Self.StringLiteralType) {
        self.init(stringLiteral)
    }
}

// MARK: - CustomStringConvertible

extension OSCAddressPattern: CustomStringConvertible {
    public var description: String {
        rawAddress
    }
}

// MARK: - Codable

extension OSCAddressPattern: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}
