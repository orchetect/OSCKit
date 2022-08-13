//
//  Component parse.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCAddressPattern.Component {
    /// Initializes a new `Pattern` instance tokenizing an individual path component of an OSC address.
    init(string pattern: String) {
        if pattern.isEmpty { return }
        
        var tokens: [Token] = []
        var currentTokenBuffer = ""
        
        func closeBuffer() {
            if !currentTokenBuffer.isEmpty {
                tokens.append(.literal(currentTokenBuffer))
                currentTokenBuffer = ""
            }
        }
        
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
        
        // bounded expression
        func getRange(
            endBound: Character
        ) -> (
            outerString: Substring,
            innerString: Substring
        )? {
            guard let closeBracketIndex = patternRemainder()?
                .firstIndex(of: endBound)
            else { return nil }
            
            let bracketSubstring = pattern[patternIndex ... closeBracketIndex]
            
            let bracketInternalSubstring: String.SubSequence
            
            if bracketSubstring.count > 2 {
                let internalStartIndex = pattern.index(after: patternIndex)
                let internalEndIndex = pattern.index(before: closeBracketIndex)
                bracketInternalSubstring = pattern[internalStartIndex ... internalEndIndex]
            } else {
                bracketInternalSubstring = ""
            }
            
            return (
                outerString: bracketSubstring,
                innerString: bracketInternalSubstring
            )
        }
        
        repeat {
            guard !isPatternIndexExhausted() else { break }
            let patternChar = pattern[patternIndex]
            
            switch patternChar {
            case "*":
                // matches zero or more of any character
                
                closeBuffer()
                if tokens.last != .zeroOrMoreWildcard { // avoid sequential copies
                    tokens.append(.zeroOrMoreWildcard)
                }
                patternIndexIncrement()
                
            case "?":
                // matches any single char
                
                closeBuffer()
                tokens.append(.singleCharWildcard)
                patternIndexIncrement()
                
            case "[":
                // [] match any char between brackets
                
                guard let bracketStrings = getRange(endBound: "]")
                else {
                    // treat as literal character if balanced close bracket is not found
                    fallthrough
                }
                
                let r = Self.parse(
                    bracketExpression: bracketStrings.innerString
                )
                
                closeBuffer()
                tokens.append(.singleChar(
                    isExclusion: r.isExclusion,
                    groups: r.groups
                ))
                patternIndexIncrement(by: bracketStrings.outerString.count)
                
            case "{":
                // {foo,bar} - A comma-separated list of strings
                
                guard let braceStrings = getRange(endBound: "}")
                else {
                    // treat as literal character if balanced close brace is not found
                    fallthrough
                }
                
                let strings = Self.parse(
                    braceExpression: braceStrings.innerString
                )
                
                closeBuffer()
                tokens.append(.strings(strings: strings))
                patternIndexIncrement(by: braceStrings.outerString.count)
                
            default:
                currentTokenBuffer.append(patternChar)
                patternIndexIncrement()
            }
        } while !isPatternIndexExhausted()
        
        closeBuffer()
        
        self.tokens = tokens
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
    internal static func parse(
        bracketExpression: Substring
    ) -> (
        isExclusion: Bool,
        groups: Set<Token.CharacterGroup>
    ) {
        guard !bracketExpression.isEmpty else { return (false, []) }
        
        var charGroups: Set<Token.CharacterGroup> = []
        
        var bracketExpression = bracketExpression
        
        var isExclusion = false
        if bracketExpression.first == "!" {
            isExclusion = true
            guard bracketExpression.count > 1 else {
                return (true, [])
            }
            bracketExpression = bracketExpression[position: 1...]
        }
        
        var isOrphanDashPresent = false
        while true {
            guard let dashIndex = bracketExpression.firstIndex(of: "-")
            else { break }
            
            guard dashIndex != bracketExpression.startIndex,
                  dashIndex != bracketExpression.index(before: bracketExpression.endIndex)
            else {
                isOrphanDashPresent = true
                bracketExpression.removeSubrange(dashIndex ... dashIndex)
                continue
            }
            
            let rangeStartIndex = bracketExpression.index(before: dashIndex)
            let rangeEndIndex = bracketExpression.index(after: dashIndex)
            
            let startChar = bracketExpression[rangeStartIndex]
            let endChar = bracketExpression[rangeEndIndex]
            
            charGroups.insert(.asciiRange(start: startChar, end: endChar))
            bracketExpression.removeSubrange(rangeStartIndex ... rangeEndIndex)
        }
        
        bracketExpression.forEach { charGroups.insert(.single($0)) }
        
        // since we removed all dashes above, re-add one if an orphan dash
        // if one was found so it can be matched verbatim
        if isOrphanDashPresent {
            charGroups.insert(.single("-"))
        }
        
        return (
            isExclusion: isExclusion,
            groups: charGroups
        )
    }
    
    /// `{}` expression sub-parser.
    ///
    /// Matches any of a comma-separated list of strings.
    internal static func parse(
        braceExpression: Substring
    ) -> Set<String> {
        braceExpression
            .split(separator: ",")
            .reduce(into: Set<String>()) {
                $0.insert(String($1))
            }
    }
}
