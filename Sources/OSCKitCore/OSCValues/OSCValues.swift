//
//  OSCValues.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public typealias OSCValues = [AnyOSCValue]

extension OSCValues {
    /// Syntactic convenience to allow the formation of an `AnyOSCValue` array by using `OSCValues()` as an initializer.
    @_disfavoredOverload
    public init(_ values: [AnyOSCValue]) {
        self = values
    }
}

// MARK: - Equatable

extension OSCValues {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (lhsIndex, rhsIndex) in zip(lhs.indices, rhs.indices) {
            guard lhs[lhsIndex] == rhs[rhsIndex] else {
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
