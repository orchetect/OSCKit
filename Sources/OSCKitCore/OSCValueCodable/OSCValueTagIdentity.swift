//
//  OSCValueTagIdentity.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public enum OSCValueTagIdentity: Equatable, Hashable {
    case atomic(Character)
    case variable([Character])
    case variadic(minCount: Int?, maxCount: Int?)
}
