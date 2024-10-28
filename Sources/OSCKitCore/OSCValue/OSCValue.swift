//
//  OSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

/// Protocol to which all compatible OSC value types conform.
///
/// This includes standard OSC types (`Int32`, `String`, etc.) as well as interpolated types (`Int`,
/// `UInt8`, etc.) and novel OSC types (``OSCImpulseValue``, ``OSCMIDIValue``, etc.).
/// For a full list of types, see the "OSC Value Types" article in the OSCKit target documentation.
public protocol OSCValue: Equatable, Hashable, OSCValueCodable, OSCValueMaskable where Self: Sendable { }

extension OSCValue {
    /// Compare hashes of two ``OSCValue`` instances.
    ///
    /// - Note: This method is a workaround since the compiler will not allow `any OSCValue` to be
    ///   seen as conforming to `Equatable`.
    func hashMatches(_ other: any OSCValue) -> Bool {
        AnyHashable(self) == AnyHashable(other)
    }
}
