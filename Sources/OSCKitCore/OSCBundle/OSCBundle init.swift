//
//  OSCBundle init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

// NOTE: Overloads that take variadic values were tested,
// however for code consistency and proper indentation, it is
// undesirable to have variadic parameters.

extension OSCBundle {
    /// OSC Bundle.
    @inlinable
    public init(
        timeTag: OSCTimeTag? = nil,
        _ elements: [any OSCObject] = []
    ) {
        self.timeTag = timeTag ?? .init(1)
        self.elements = elements
        self._rawData = nil
    }
}
