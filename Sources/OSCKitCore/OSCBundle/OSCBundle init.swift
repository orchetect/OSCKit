//
//  OSCBundle init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCBundle {
    @inlinable
    public init(
        elements: [any OSCObject],
        timeTag: OSCTimeTag? = nil
    ) {
        self.timeTag = timeTag ?? .init(1)
        self.elements = elements
        self._rawData = nil
    }
}
