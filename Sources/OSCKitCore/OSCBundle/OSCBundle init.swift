//
//  OSCBundle init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// NOTE: Overloads that take variadic values were tested,
// however for code consistency and conventional indentation, it is
// undesirable to have variadic parameters.

extension OSCBundle {
    /// OSC Bundle.
    public init(
        timeTag: OSCTimeTag? = nil,
        _ elements: [any OSCObject] = []
    ) {
        self.timeTag = timeTag ?? .init(1)
        self.elements = elements
        _rawData = nil
    }
}
