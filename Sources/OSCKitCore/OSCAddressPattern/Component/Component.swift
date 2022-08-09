//
//  Component.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCAddressPattern {
    /// OSC Address Component.
    /// A tokenized pattern of an individual path component in an OSC address pattern.
    ///
    /// For a detailed discussion on OSC address pattern matching, see the inline documentation for `OSCAddressPattern`.
    struct Component {
        var tokens: [Token] = []
        
        init() { }
    }
}
