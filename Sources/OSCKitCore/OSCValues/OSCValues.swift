//
//  OSCValues.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

public typealias OSCValues = [any OSCValue]

extension OSCValues {
    /// Syntactic convenience to allow the formation of an `any` ``OSCValue`` array by using
    /// `OSCValues()` as an initializer.
    @_disfavoredOverload
    public init(_ values: [any OSCValue]) {
        self = values
    }
}

// MARK: - Equatable

extension OSCValues {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (lhsIndex, rhsIndex) in zip(lhs.indices, rhs.indices) {
            guard lhs[lhsIndex].hashMatches(rhs[rhsIndex]) else {
                return false
            }
        }
        return true
    }
    
    public static func != (lhs: Self, rhs: Self) -> Bool {
        !(lhs == rhs)
    }
}

// MARK: - Hashable

extension OSCValues {
    public func hash(into hasher: inout Hasher) {
        forEach { hasher.combine($0) }
    }
}
