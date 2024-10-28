//
//  AnyOSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

/// Convenience typealias for `any` ``OSCValue``.
public typealias AnyOSCValue = any OSCValue

extension OSCValue {
    /// Compare hashes of two ``OSCValue`` instances.
    ///
    /// - Note: This method is a workaround since the compiler will not allow ``AnyOSCValue`` (`any OSCValue`) to be
    ///   seen as conforming to `Equatable`.
    func hashMatches(_ other: AnyOSCValue) -> Bool {
        AnyHashable(self) == AnyHashable(other)
    }
}
