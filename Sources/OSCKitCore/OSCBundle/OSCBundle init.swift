//
//  OSCBundle init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCBundle {
    /// OSC Bundle.
    @inlinable
    public init(
        timeTag: OSCTimeTag? = nil,
        _ elements: [any OSCObject]
    ) {
        self.timeTag = timeTag ?? .init(1)
        self.elements = elements
        self._rawData = nil
    }
    
    /// OSC Bundle.
    @inlinable
    public init(
        timeTag: OSCTimeTag? = nil,
        _ elements: (any OSCObject)...
    ) {
        self.timeTag = timeTag ?? .init(1)
        self.elements = elements
        self._rawData = nil
    }
}
