/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Foundation/String and CharacterSet.swift
///
/// Borrowed from OTCore 1.4.10 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import Foundation

// MARK: - Character tests

extension StringProtocol {
    /// Returns true if the string is entirely comprised of ASCII characters (0-127).
    @inlinable @_disfavoredOverload
    var isASCII: Bool {
        allSatisfy(\.isASCII)
    }
    
    /// Returns true if all characters in the string are contained in the character set.
    @_disfavoredOverload
    func isOnly(
        _ characterSet: CharacterSet,
        _ characterSets: CharacterSet...
    ) -> Bool {
        let mergedCharacterSet = characterSets.isEmpty
            ? characterSet
            : characterSets.reduce(into: characterSet, +=)
        
        return allSatisfy(mergedCharacterSet.contains(_:))
    }
    
    /// Returns true if all characters in the string are contained in the character set.
    @_disfavoredOverload
    func isOnly(characters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: characters)
        return allSatisfy(characterSet.contains(_:))
    }
    
    /// Returns true if any character in the string are contained in the character set.
    @_disfavoredOverload
    func contains(
        any characterSet: CharacterSet,
        _ characterSets: CharacterSet...
    ) -> Bool {
        let mergedCharacterSet = characterSets.isEmpty
            ? characterSet
            : characterSets.reduce(into: characterSet, +=)
        
        for char in self {
            if mergedCharacterSet.contains(char) { return true }
        }
        
        return false
    }
    
    /// Returns true if any character in the string are contained in the character set.
    @_disfavoredOverload
    func contains(anyCharacters characters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: characters)
        
        for char in self {
            if characterSet.contains(char) { return true }
        }
        
        return false
    }
}
