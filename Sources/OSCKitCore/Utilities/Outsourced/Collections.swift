/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Swift/Collections.swift
///
/// Borrowed from OTCore 1.4.10 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// MARK: - Operators

extension Collection where Self: RangeReplaceableCollection,
                           Self: MutableCollection {
    /// Syntactic sugar: Append an element to an array.
    @inlinable
    static func += (lhs: inout Self, rhs: Element) {
        lhs.append(rhs)
    }
}

// MARK: - Indexes

extension Collection {
    /// Returns an index that is the specified distance from the start index.
    @_disfavoredOverload
    func startIndex(offsetBy distance: Int) -> Index {
        index(startIndex, offsetBy: distance)
    }
    
    /// Returns an index that is the specified distance from the end index.
    @_disfavoredOverload
    func endIndex(offsetBy distance: Int) -> Index {
        index(endIndex, offsetBy: distance)
    }
}

extension Collection {
    /// Returns the character at the given character position (offset from the start index).
    @_disfavoredOverload
    subscript(position offsetIndex: Int) -> Element {
        let fromIndex = index(startIndex, offsetBy: offsetIndex)
        return self[fromIndex]
    }
    
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    subscript(position offsetRange: ClosedRange<Int>) -> SubSequence {
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[fromIndex ... toIndex]
    }
    
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    subscript(position offsetRange: Range<Int>) -> SubSequence {
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[fromIndex ..< toIndex]
    }
    
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    subscript(position offsetRange: PartialRangeFrom<Int>) -> SubSequence {
        let fromIndex = index(startIndex, offsetBy: offsetRange.lowerBound)
        return self[fromIndex...]
    }
    
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    subscript(position offsetRange: PartialRangeThrough<Int>) -> SubSequence {
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[...toIndex]
    }
    
    /// Returns the substring in the given range of character positions (offsets from the start index).
    @_disfavoredOverload
    subscript(position offsetRange: PartialRangeUpTo<Int>) -> SubSequence {
        let toIndex = index(startIndex, offsetBy: offsetRange.upperBound)
        return self[..<toIndex]
    }
}
