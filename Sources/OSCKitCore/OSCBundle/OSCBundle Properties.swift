//
//  OSCBundle Properties.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

extension OSCBundle {
    /// A convenience to access all messages within the bundle, including within any nested bundles,
    /// preserving order.
    public var messages: [OSCMessage] {
        elements.reduce(into: []) { base, element in
            base.append(contentsOf: element.messages)
        }
    }
}
