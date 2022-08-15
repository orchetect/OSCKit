//
//  OSCValueTagIdentity.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

public enum OSCValueTagIdentity: Equatable, Hashable {
    case atomic(Character)
    case variable([Character])
    case variadic(minCount: Int?, maxCount: Int?)
}

extension OSCValueTagIdentity {
    /// Returns `true` if the identity matches the given tag.
    /// If the identity is variadic, `false` is always returned.
    public func isEqual(to otherTag: Character) -> Bool {
        switch self {
        case let .atomic(character):
            return otherTag == character
        case let .variable(array):
            return array.contains(otherTag)
        case .variadic:
            return false
        }
    }
    
    /// Returns static tag(s) of the tag identity.
    /// If the identity is variadic, an empty array is always returned since the tags are known only to the type's `OSCValueCodable` implementation.
    func staticTags() -> [Character] {
        switch self {
        case let .atomic(character):
            return [character]
        case let .variable(array):
            return array
        case .variadic:
            return []
        }
    }
}
