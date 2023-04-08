/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Foundation/CharacterSet.swift
///
/// Borrowed from OTCore 1.4.10 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import Foundation

extension CharacterSet {
    /// Initialize a `CharacterSet` from one or more `Character`.
    @_disfavoredOverload
    init(_ characters: Character...) {
        self.init(characters)
    }
    
    /// Initialize a `CharacterSet` from one or more `Character`.
    @_disfavoredOverload
    init(_ characters: [Character]) {
        self.init()
        
        characters.forEach {
            $0.unicodeScalars.forEach { insert($0) }
        }
    }
}

extension CharacterSet {
    /// Returns true if the `CharacterSet` contains the given `Character`.
    @_disfavoredOverload
    func contains(_ character: Character) -> Bool {
        character
            .unicodeScalars
            .allSatisfy(contains(_:))
    }
}

extension CharacterSet {
    /// Same as `lhs.union(rhs)`.
    @_disfavoredOverload
    static func + (lhs: Self, rhs: Self) -> Self {
        lhs.union(rhs)
    }
    
    /// Same as `lhs.formUnion(rhs)`.
    @_disfavoredOverload
    static func += (lhs: inout Self, rhs: Self) {
        lhs.formUnion(rhs)
    }
    
    /// Same as `lhs.subtracting(rhs)`.
    @_disfavoredOverload
    static func - (lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs)
    }
    
    /// Same as `lhs.subtract(rhs)`.
    @_disfavoredOverload
    static func -= (lhs: inout Self, rhs: Self) {
        lhs.subtract(rhs)
    }
}
