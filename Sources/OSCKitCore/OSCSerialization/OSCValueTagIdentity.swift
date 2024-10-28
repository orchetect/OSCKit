//
//  OSCValueTagIdentity.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

/// Declarative description of how an OSC value represents itself with OSC message type tag(s).
public enum OSCValueTagIdentity: Equatable, Hashable {
    /// Atomic:
    /// The OSC value is identified with a single static OSC-type tag character.
    ///
    /// Most OSC values are represented in this manner. ie: "i" for Int32, "s" for String, etc.
    case atomic(Character)
    
    /// Variable:
    /// The OSC value occupies a single static OSC-type tag character but it varies depending on the
    /// content of the value.
    /// All possible type tags must be finite and known at compile time.
    ///
    /// An example is Boolean (true/false). A single instance of the concrete type occupies a single
    /// tag but the tag may be "t" or "f".
    case variable([Character])
    
    /// Variadic:
    /// The OSC "value" may be complex in nature and occupies one or more OSC-type tag characters
    /// and they are not reasonably known at compile time. This scenario requires manual parsing and
    /// validation. Very few implementations will require this pattern.
    ///
    /// One (perhaps the only) example of a variadic implementation is an OSC value array. It starts
    /// with the "[" tag and ends with the "]" tag and may contain zero or more atomic values. It
    /// would have a `minCount` of 2 and a `maxCount` of `nil`. Variadic is how OSCKit itself
    /// internally implements OSC array encoding and decoding.
    case variadic(minCount: Int?, maxCount: Int?)
}

// MARK: - Sendable

extension OSCValueTagIdentity: Sendable { }

// MARK: - Methods

extension OSCValueTagIdentity {
    /// Returns `true` if the identity matches the given tag.
    /// If the identity is variadic, `false` is always returned.
    public func isEqual(to otherTag: Character) -> Bool {
        switch self {
        case let .atomic(character):
            otherTag == character
        case let .variable(array):
            array.contains(otherTag)
        case .variadic:
            false
        }
    }
    
    /// Returns static tag(s) of the tag identity.
    /// If the identity is variadic, an empty array is always returned since the tags are known only
    /// to the type's `OSCValueCodable` implementation.
    func staticTags() -> [Character] {
        switch self {
        case let .atomic(character):
            [character]
        case let .variable(array):
            array
        case .variadic:
            []
        }
    }
}
