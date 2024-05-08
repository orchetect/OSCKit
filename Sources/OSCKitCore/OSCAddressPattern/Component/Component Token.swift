//
//  Component Token.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCAddressPattern.Component {
    enum Token: Equatable, Hashable {
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

extension OSCAddressPattern.Component.Token {
    enum CharacterGroup: Equatable, Hashable {
        /// Single character.
        case single(Character)
        
        /// Contiguous range of ASCII characters.
        case asciiRange(start: Character, end: Character)
    }
}
