//
//  Value Sequence Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension Sequence where Iterator.Element == OSCMessage.Value {
    /// Convenience: maps a sequence of `OSCMessage.Value` to a flat string, for logging/debug purposes.
    public func mapDebugString(
        withLabel: Bool = true,
        separator: String = ", "
    ) -> String {
        map { $0.stringValue(withLabel: withLabel) }
            .joined(separator: separator)
    }
}
