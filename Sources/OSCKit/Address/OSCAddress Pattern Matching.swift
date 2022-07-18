//
//  OSCAddress Pattern Matching.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCAddress {
    
    /// Evaluate pattern matching against a single path component in an OSC address.
    ///
    /// - Parameters:
    ///   - pattern: pattern string
    ///   - name: OSC address path component
    /// - Returns: true if the path component pattern matches the supplied path component string.
    internal static func pathComponent(pattern: String,
                                       matches name: String) -> Bool {
        
        if pattern.isEmpty { return true }
        
        // pattern
        var patternIndex = pattern.startIndex
        func patternRemainder() -> Substring? {
            isPatternIndexExhausted() ? nil : pattern[patternIndex...]
        }
        func patternIndexIncrement() {
            patternIndex = pattern.index(after: patternIndex)
        }
        func patternIndexIncrement(by numberOfChars: Int) {
            patternIndex = pattern.index(patternIndex, offsetBy: numberOfChars)
        }
        func isPatternIndexLastChar() -> Bool {
            patternIndex == pattern.index(before: pattern.endIndex)
        }
        func isPatternIndexExhausted() -> Bool {
            patternIndex >= pattern.endIndex
        }
        
        // name
        var nameIndex = name.startIndex
        func nameIndexIncrement() {
            nameIndex = name.index(after: nameIndex)
        }
        func nameIndexIncrement(by numberOfChars: Int) {
            nameIndex = name.index(nameIndex, offsetBy: numberOfChars)
        }
        func isNameIndexLastChar() -> Bool {
            nameIndex == name.index(before: name.endIndex)
        }
        func isNameIndexExhausted() -> Bool {
            nameIndex >= name.endIndex
        }
        
        // bounded expression
        func getRange(
            endBound: Character
        ) -> (outerString: Substring,
              innerString: Substring)?
        {
            guard let closeBracketIndex = patternRemainder()?
                .firstIndex(of: endBound)
            else { return nil }
            
            let bracketSubstring = pattern[patternIndex...closeBracketIndex]
            
            guard bracketSubstring.count > 2 else { return nil }
            
            let internalStartIndex = pattern.index(after: patternIndex)
            let internalEndIndex = pattern.index(before: closeBracketIndex)
            let bracketInternalSubstring = pattern[internalStartIndex...internalEndIndex]
            
            return (outerString: bracketSubstring,
                    innerString: bracketInternalSubstring)
        }
        
        repeat {
            guard !isPatternIndexExhausted() else { return false }
            let patternChar = pattern[patternIndex]
            
            switch patternChar {
            case "*":
                // matches zero or more chars
                if isPatternIndexLastChar() { return true }
                
                // otherwise, if not last char, we have to handle it differently
                fatalError("Not implemented yet.")
                
            case "?":
                // matches any single char
                patternIndexIncrement()
                nameIndexIncrement()
                
            case "[":
                // [] match any char between brackets
                
                guard let bracketStrings = getRange(endBound: "]")
                else { return false }
                
                let isMatch = pathComponent(
                    bracketExpression: bracketStrings.innerString,
                    matches: name[nameIndex]
                )
                guard isMatch else { return false }
                
                patternIndexIncrement(by: bracketStrings.outerString.count)
                nameIndexIncrement()
                
            case "]":
                // should not encounter an unbalanced closing bracket
                return false
                
            case "{":
                // {foo,bar} - A comma-separated list of strings
                
                guard let braceStrings = getRange(endBound: "}")
                else { return false }
                
                let braceResult = pathComponent(
                    braceExpression: braceStrings.innerString,
                    prefixes: name[nameIndex...]
                )
                guard braceResult.isMatch else { return false }
                
                patternIndexIncrement(by: braceStrings.outerString.count)
                nameIndexIncrement(by: braceResult.length)
                
            case "}":
                // should not encounter an unbalanced closing bracket
                return false
                
            default:
                guard !isNameIndexExhausted() else { return false }
                if patternChar != name[nameIndex] { return false }
                patternIndexIncrement()
                nameIndexIncrement()
                
            }
        } while !(isPatternIndexExhausted() && isNameIndexExhausted())
        
        return true
        
    }
    
    /// `[]` expression sub-parser.
    ///
    /// Special character `-`:
    /// - only valid inside `[]`;
    /// - matches any char in an ASCII char range when between two chars;
    /// - `-` at the end of the string has no special meaning
    /// - `-` at the start of the string is undefined (spec doesn't say)
    ///
    /// Special character `!`:
    /// - only valid inside `[]`;
    /// - at the beginning of a bracketed string negates the sense of the list, meaning that the list matches any character not in the list
    /// - `!` as any other char than first char has no special meaning
    internal static func pathComponent(
        bracketExpression: Substring,
        matches char: Character
    ) -> Bool {
        
        guard !bracketExpression.isEmpty else { return false }
        
        var bracketExpression = bracketExpression
        
        var isExclusion = false
        if bracketExpression.first == "!" {
            isExclusion = true
            guard bracketExpression.count > 1 else { return true }
            bracketExpression = bracketExpression[position: 1...]
        }
        
        var isOrphanDashPresent = false
        while true {
            guard let dashIndex = bracketExpression.firstIndex(of: "-")
            else { break }
            
            guard dashIndex != bracketExpression.startIndex &&
                    dashIndex != bracketExpression.index(before: bracketExpression.endIndex)
            else {
                isOrphanDashPresent = true
                bracketExpression.removeSubrange(dashIndex...dashIndex)
                continue
            }
            
            let rangeStartIndex = bracketExpression.index(before: dashIndex)
            let rangeEndIndex = bracketExpression.index(after: dashIndex)
            
            let startChar = bracketExpression[rangeStartIndex]
            let endChar = bracketExpression[rangeEndIndex]
            
            guard let charVal = char.asciiValue,
                  let startCharVal = startChar.asciiValue,
                  let endCharVal = endChar.asciiValue
            else { return false }
            
            // ensure range is formable
            guard startCharVal <= endCharVal else { return false }
            
            let containsCharVal = (startCharVal...endCharVal).contains(charVal)
            
            if containsCharVal {
                return !isExclusion
            }
            
            bracketExpression.removeSubrange(rangeStartIndex...rangeEndIndex)
        }
        
        // since we removed all dashes above, re-add one if an orphan dash
        // if one was found so it can be matched verbatim
        if isOrphanDashPresent {
            bracketExpression.append("-")
        }
        
        let containsChar = bracketExpression.contains(char)
        
        return isExclusion ? !containsChar : containsChar
        
    }
    
    /// `{}` expression sub-parser.
    ///
    /// Matches any of a comma-separated list of strings.
    internal static func pathComponent(
        braceExpression: Substring,
        prefixes text: Substring
    ) -> (isMatch: Bool,
          length: Int)
    {
        
        let candidates = braceExpression.split(separator: ",")
        
        guard let match = candidates
            .first(where: { text.starts(with: $0) })
        else {
            return (isMatch: false, length: 0)
        }
        
        return (isMatch: true, length: match.count)
        
    }
    
}
