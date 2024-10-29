//
//  Component Token Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

@testable import OSCKitCore
import Testing

@Suite struct OSCAddressPattern_Component_Token_Tests {
    @Test func literal_Empty() {
        let t = OSCAddressPattern.Component.Token.Literal(literal: "")
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .match(length: 0))
        #expect(t.matches(string: "abc") == .match(length: 0))
        
        #expect(t.isExhausted)
    }
    
    @Test func literal_Basic() {
        let t = OSCAddressPattern.Component.Token.Literal(literal: "abc")
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "abc") == .match(length: 3))
        #expect(t.matches(string: "abcdef") == .match(length: 3))
        #expect(t.matches(string: "xyz") == .noMatch)
        #expect(t.matches(string: "xyzabc") == .noMatch)
        
        #expect(t.isExhausted)
    }
    
    @Test func zeroOrMoreWildcard() {
        var t = OSCAddressPattern.Component.Token.ZeroOrMoreWildcard()
        
        #expect(!t.isExhausted)
        #expect(t.matches(string: "") == .match(length: 0))
        #expect(t.matches(string: "abc") == .match(length: 0))
        #expect(t.matches(string: "abcdef") == .match(length: 0))
        
        t.next(remainingLength: 3)
        #expect(!t.isExhausted)
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "abc") == .match(length: 1))
        #expect(t.matches(string: "abcdef") == .match(length: 1))
        
        t.next(remainingLength: 3)
        #expect(!t.isExhausted)
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "abc") == .match(length: 2))
        #expect(t.matches(string: "abcdef") == .match(length: 2))
        
        t.next(remainingLength: 3)
        #expect(!t.isExhausted)
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "abc") == .match(length: 3))
        #expect(t.matches(string: "abcdef") == .match(length: 3))
        
        t.next(remainingLength: 3)
        #expect(t.isExhausted)
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "abc") == .noMatch)
        #expect(t.matches(string: "abcdef") == .match(length: 4))
        
        t.next(remainingLength: 3)
        #expect(t.isExhausted)
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "abc") == .noMatch)
        #expect(t.matches(string: "abcdef") == .match(length: 5))
        
        t.next(remainingLength: 3)
        #expect(t.isExhausted)
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "abc") == .noMatch)
        #expect(t.matches(string: "abcdef") == .match(length: 6))
        
        t.next(remainingLength: 3)
        #expect(t.isExhausted)
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "abc") == .noMatch)
        #expect(t.matches(string: "abcdef") == .noMatch)
        
        t.reset()
        #expect(!t.isExhausted)
    }
    
    @Test func singleCharWildcard() {
        let t = OSCAddressPattern.Component.Token.SingleCharWildcard()
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .match(length: 1))
        #expect(t.matches(string: "ab") == .match(length: 1))
        #expect(t.matches(string: "abc") == .match(length: 1))
        
        #expect(t.isExhausted)
    }
    
    @Test func singleChar_Empty() {
        let t = OSCAddressPattern.Component.Token.SingleChar(
            isExclusion: false,
            groups: []
        )
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .noMatch)
        #expect(t.matches(string: "ab") == .noMatch)
        #expect(t.matches(string: "abc") == .noMatch)
        
        #expect(t.isExhausted)
    }
    
    @Test func singleChar_Single() {
        let t = OSCAddressPattern.Component.Token.SingleChar(
            isExclusion: false,
            groups: [.single("a")]
        )
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .match(length: 1))
        #expect(t.matches(string: "ab") == .match(length: 1))
        #expect(t.matches(string: "abc") == .match(length: 1))
        #expect(t.matches(string: "x") == .noMatch)
        #expect(t.matches(string: "xy") == .noMatch)
        
        #expect(t.matches(string: "A") == .noMatch)
        
        #expect(t.isExhausted)
    }
    
    @Test func singleChar_Range() {
        let t = OSCAddressPattern.Component.Token.SingleChar(
            isExclusion: false,
            groups: [.asciiRange(start: "b", end: "y")]
        )
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .noMatch)
        #expect(t.matches(string: "ab") == .noMatch)
        #expect(t.matches(string: "b") == .match(length: 1))
        #expect(t.matches(string: "bc") == .match(length: 1))
        #expect(t.matches(string: "y") == .match(length: 1))
        #expect(t.matches(string: "yz") == .match(length: 1))
        #expect(t.matches(string: "z") == .noMatch)
        
        #expect(t.matches(string: "B") == .noMatch)
        #expect(t.matches(string: "Y") == .noMatch)
        
        #expect(t.isExhausted)
    }
    
    @Test func singleChar_SingleAndRange() {
        let t = OSCAddressPattern.Component.Token.SingleChar(
            isExclusion: false,
            groups: [
                .single("a"),
                .asciiRange(start: "b", end: "y")
            ]
        )
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .match(length: 1))
        #expect(t.matches(string: "b") == .match(length: 1))
        #expect(t.matches(string: "c") == .match(length: 1))
        #expect(t.matches(string: "y") == .match(length: 1))
        #expect(t.matches(string: "z") == .noMatch)
        
        #expect(t.matches(string: "ac") == .match(length: 1))
        #expect(t.matches(string: "bc") == .match(length: 1))
        #expect(t.matches(string: "cc") == .match(length: 1))
        #expect(t.matches(string: "yc") == .match(length: 1))
        #expect(t.matches(string: "zc") == .noMatch)
        
        #expect(t.matches(string: "A") == .noMatch)
        #expect(t.matches(string: "B") == .noMatch)
        #expect(t.matches(string: "Y") == .noMatch)
        
        #expect(t.isExhausted)
    }
    
    @Test func singleChar_Empty_isExclusion() {
        let t = OSCAddressPattern.Component.Token.SingleChar(
            isExclusion: true,
            groups: []
        )
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .match(length: 1))
        #expect(t.matches(string: "ab") == .match(length: 1))
        #expect(t.matches(string: "abc") == .match(length: 1))
        
        #expect(t.isExhausted)
    }
    
    @Test func singleChar_Single_isExclusion() {
        let t = OSCAddressPattern.Component.Token.SingleChar(
            isExclusion: true,
            groups: [.single("a")]
        )
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .noMatch)
        #expect(t.matches(string: "ab") == .noMatch)
        #expect(t.matches(string: "abc") == .noMatch)
        #expect(t.matches(string: "x") == .match(length: 1))
        #expect(t.matches(string: "xy") == .match(length: 1))
        
        #expect(t.matches(string: "A") == .match(length: 1))
        
        #expect(t.isExhausted)
    }
    
    @Test func singleChar_Range_isExclusion() {
        let t = OSCAddressPattern.Component.Token.SingleChar(
            isExclusion: true,
            groups: [.asciiRange(start: "b", end: "y")]
        )
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .match(length: 1))
        #expect(t.matches(string: "ab") == .match(length: 1))
        #expect(t.matches(string: "b") == .noMatch)
        #expect(t.matches(string: "bc") == .noMatch)
        #expect(t.matches(string: "y") == .noMatch)
        #expect(t.matches(string: "yz") == .noMatch)
        #expect(t.matches(string: "z") == .match(length: 1))
        
        #expect(t.matches(string: "B") == .match(length: 1))
        #expect(t.matches(string: "Y") == .match(length: 1))
        
        #expect(t.isExhausted)
    }
    
    @Test func singleChar_SingleAndRange_isExclusion() {
        let t = OSCAddressPattern.Component.Token.SingleChar(
            isExclusion: true,
            groups: [
                .single("a"),
                .asciiRange(start: "b", end: "y")
            ]
        )
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .noMatch)
        #expect(t.matches(string: "b") == .noMatch)
        #expect(t.matches(string: "c") == .noMatch)
        #expect(t.matches(string: "y") == .noMatch)
        #expect(t.matches(string: "z") == .match(length: 1))
        
        #expect(t.matches(string: "ac") == .noMatch)
        #expect(t.matches(string: "bc") == .noMatch)
        #expect(t.matches(string: "cc") == .noMatch)
        #expect(t.matches(string: "yc") == .noMatch)
        #expect(t.matches(string: "zc") == .match(length: 1))
        
        #expect(t.matches(string: "A") == .match(length: 1))
        #expect(t.matches(string: "B") == .match(length: 1))
        #expect(t.matches(string: "Y") == .match(length: 1))
        
        #expect(t.isExhausted)
    }
    
    @Test func strings_Empty() {
        let t = OSCAddressPattern.Component.Token.Strings(strings: [])
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .match(length: 0))
        #expect(t.matches(string: "a") == .match(length: 0))
        #expect(t.matches(string: "ab") == .match(length: 0))
        
        #expect(t.isExhausted)
    }
    
    @Test func strings_Single() {
        let t = OSCAddressPattern.Component.Token.Strings(strings: ["abc"])
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .noMatch)
        #expect(t.matches(string: "ab") == .noMatch)
        #expect(t.matches(string: "abc") == .match(length: 3))
        #expect(t.matches(string: "abcd") == .match(length: 3))
        #expect(t.matches(string: "ABC") == .noMatch)
        
        #expect(t.isExhausted)
    }
    
    @Test func strings_Multiple() {
        let t = OSCAddressPattern.Component.Token.Strings(strings: ["wxyz", "abc"])
        
        #expect(t.isExhausted)
        
        #expect(t.matches(string: "") == .noMatch)
        #expect(t.matches(string: "a") == .noMatch)
        #expect(t.matches(string: "ab") == .noMatch)
        #expect(t.matches(string: "abc") == .match(length: 3))
        #expect(t.matches(string: "abcd") == .match(length: 3))
        #expect(t.matches(string: "ABC") == .noMatch)
        #expect(t.matches(string: "awxyz") == .noMatch)
        
        #expect(t.isExhausted)
    }
}
