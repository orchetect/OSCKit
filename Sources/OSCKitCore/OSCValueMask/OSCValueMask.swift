//
//  OSCValueMask.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

/// `OSCMessage` values mask.
/// Contains a sequence of value type tokens, including optional variants and meta types.
public struct OSCValueMask {
    /// Ordered array of value mask tokens.
    public var tokens: [Token]
}
