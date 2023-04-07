//
//  Component evaluate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore

extension OSCAddressPattern.Component {
    /// Evaluate pattern matching against a single path component in an OSC address.
    ///
    /// - Parameters:
    ///   - pathComponent: OSC address path component.
    ///
    /// - Returns: `true` if the path component pattern matches the supplied path component string.
    func evaluate(matching pathComponent: any StringProtocol) -> Bool {
        // early return: empty
        if tokens.isEmpty {
            return pathComponent.isEmpty
        }
        
        // early return: single string literal
        if tokens.count == 1,
           case let .literal(string) = tokens[0]
        {
            return string == pathComponent
        }
        
        // early return: single * wildcard
        if tokens == [.zeroOrMoreWildcard] {
            return true
        }
        
        var state: [OSCAddressPatternToken] = []
        
        tokens.forEach {
            switch $0 {
            case let .literal(literal):
                let stateItem = Token.Literal(literal: literal)
                state.append(stateItem)
                
            case .zeroOrMoreWildcard:
                let stateItem = Token.ZeroOrMoreWildcard()
                state.append(stateItem)
                
            case .singleCharWildcard:
                let stateItem = Token.SingleCharWildcard()
                state.append(stateItem)
                
            case let .singleChar(isExclusion, groups):
                let stateItem = Token.SingleChar(
                    isExclusion: isExclusion,
                    groups: groups
                )
                state.append(stateItem)
                
            case let .strings(strings):
                let stateItem = Token.Strings(strings: strings)
                state.append(stateItem)
            }
        }
        
        var matchPos = 0
        
        func runState(index: Int) -> Bool {
            state[index].reset()
            let entryPos = matchPos
            
            repeat {
                let idx = pathComponent.index(
                    pathComponent.startIndex,
                    offsetBy: entryPos
                )
                let r = state[index].matches(string: pathComponent[idx...])
                
                switch r {
                case .noMatch:
                    break
                    
                case let .match(len):
                    matchPos = entryPos + len
                    
                    if index < state.count - 1 {
                        if runState(index: index + 1) {
                            return true
                        }
                    } else { // is the final state item...
                        let matchPosIdx = pathComponent.index(
                            pathComponent.startIndex,
                            offsetBy: matchPos
                        )
                        if matchPosIdx == pathComponent.endIndex {
                            return true
                        }
                    }
                }
                
                state[index].next(remainingLength: pathComponent.count - entryPos)
            } while !state[index].isExhausted
            
            return false
        }
        
        return runState(index: 0)
    }
}

// MARK: - OSCAddressPatternToken

protocol OSCAddressPatternToken {
    func matches(string: any StringProtocol) -> OSCAddressPattern.Component.Token.Match
    
    var isExhausted: Bool { get }
    
    mutating func next(remainingLength: Int)
    
    mutating func reset()
}

extension OSCAddressPattern.Component.Token {
    enum Match: Equatable, Hashable {
        case noMatch
        case match(length: Int)
    }
}

extension OSCAddressPattern.Component.Token {
    struct Literal: OSCAddressPatternToken {
        let literal: String
        
        func matches(string: any StringProtocol) -> Match {
            string.starts(with: literal)
                ? .match(length: literal.count)
                : .noMatch
        }
        
        let isExhausted: Bool = true
        
        mutating func next(remainingLength: Int) { }
        
        mutating func reset() { }
    }
    
    struct ZeroOrMoreWildcard: OSCAddressPatternToken {
        private var currentLength = 0
        
        func matches(string: any StringProtocol) -> Match {
            currentLength <= string.count
                ? .match(length: currentLength)
                : .noMatch
        }
        
        private(set) var isExhausted: Bool = false
        
        mutating func next(remainingLength: Int) {
            currentLength += 1
            isExhausted = currentLength > remainingLength
        }
        
        mutating func reset() {
            currentLength = 0
            isExhausted = false
        }
    }
    
    struct SingleCharWildcard: OSCAddressPatternToken {
        func matches(string: any StringProtocol) -> Match {
            string.isEmpty ? .noMatch : .match(length: 1)
        }
        
        let isExhausted: Bool = true
        
        mutating func next(remainingLength: Int) { }
        
        mutating func reset() { }
    }
    
    struct SingleChar: OSCAddressPatternToken {
        let isExclusion: Bool
        
        let groups: Set<CharacterGroup>
        
        func matches(string: any StringProtocol) -> Match {
            guard !string.isEmpty else {
                return .noMatch
            }
            
            guard groups.contains(where: {
                switch $0 {
                case let .single(char):
                    return char == string.first
                case let .asciiRange(start: startChar, end: endChar):
                    guard let charVal = string.first?.asciiValue,
                          let startCharVal = startChar.asciiValue,
                          let endCharVal = endChar.asciiValue,
                          startCharVal <= endCharVal
                    else {
                        return false
                    }
                    let charRange = startCharVal ... endCharVal
                    return charRange.contains(charVal)
                }
            })
            else {
                return isExclusion ? .match(length: 1) : .noMatch
            }
            
            return isExclusion ? .noMatch : .match(length: 1)
        }
        
        let isExhausted: Bool = true
        
        mutating func next(remainingLength: Int) { }
        
        mutating func reset() { }
    }
    
    struct Strings: OSCAddressPatternToken {
        let strings: Set<String>
        
        func matches(string: any StringProtocol) -> Match {
            if strings.isEmpty {
                return .match(length: 0)
            }
            
            guard let match = strings.first(where: { string.starts(with: $0) })
            else {
                return .noMatch
            }
            
            return .match(length: match.count)
        }
        
        private(set) var isExhausted: Bool = true
        
        mutating func next(remainingLength: Int) { }
        
        mutating func reset() { }
    }
}
