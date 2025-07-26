//
//  Optional.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - OSCKitOptional

/// Protocol describing an optional, used to enable extensions on types such as `Type<T>?`.
package protocol OSCKitOptional {
    associatedtype Wrapped
    
    /// Semantic workaround used to enable extensions on types such as `Type<T>?
    @inlinable
    var optional: Wrapped? { get }
}

extension OSCKitOptional {
    /// Same as `Wrapped?.none`.
    @inlinable
    package static var noneValue: Wrapped? {
        .none
    }
}

extension Optional: OSCKitOptional {
    @inlinable
    package var optional: Wrapped? {
        self
    }
}
