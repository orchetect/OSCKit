//
//  OSCValue Array Conformances.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

// MARK: - Equatable

extension Array where Element == any OSCValue {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == lhs.count else { return false }
        for (lhsIndex, rhsIndex) in zip(lhs.indices, rhs.indices) {
            guard isEqual(lhs[lhsIndex], rhs[rhsIndex]) else {
                return false
            }
        }
        return true
    }
}

// MARK: - Hashable

extension Array where Element == any OSCValue {
    public func hash(into hasher: inout Hasher) {
        forEach { hasher.combine($0) }
    }
}

func isEqual(_ lhs: any OSCValue, _ rhs: any OSCValue) -> Bool {
    AnyHashable(lhs) == AnyHashable(rhs)
}
