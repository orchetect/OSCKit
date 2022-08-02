//
//  Mask.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCMessage.Value {
    /// OSC message values mask.
    /// Contains a sequence of value type tokens, including optional variants and meta types.
    public struct Mask {
        /// Ordered array of value mask tokens.
        public var tokens: [Token]
    }
}
