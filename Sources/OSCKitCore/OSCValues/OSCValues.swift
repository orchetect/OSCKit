//
//  OSCValues.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public typealias OSCValues = [AnyOSCValue]

// MARK: - Equatable

extension OSCValues {
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

extension OSCValues {
    public func hash(into hasher: inout Hasher) {
        forEach { hasher.combine($0) }
    }
}
