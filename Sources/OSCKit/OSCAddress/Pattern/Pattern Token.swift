//
//  Pattern Token.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCAddress.Pattern {
    
    internal enum Token: Equatable, Hashable {
        
        /// One or more sequential literal characters.
        case literal(String)
        
        /// `*`
        case zeroOrMoreWildcard
        
        /// `?`
        case singleCharWildcard
        
        /// `[]` bracket expression.
        case singleChar(isExclusion: Bool, groups: Set<CharacterGroup>)
        
        /// `{}` curly-brace expression.
        case strings(strings: Set<String>)
        
    }
    
}

extension OSCAddress.Pattern.Token {
    
    enum CharacterGroup: Equatable, Hashable {
        
        /// Single character.
        case single(Character)
        
        /// Contiguous range of ASCII characters.
        case asciiRange(start: Character, end: Character)
        
    }
    
}
