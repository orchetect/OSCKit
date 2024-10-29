//
//  Component Parse Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

@testable import OSCKitCore
import Testing

@Suite struct OSCAddressPattern_Component_Parse_Tests {
    @Test func basic() {
        #expect(
            OSCAddressPattern.Component(string: "").tokens ==
            []
        )
        
        #expect(
            OSCAddressPattern.Component(string: "1").tokens ==
            [.literal("1")]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "123").tokens ==
            [.literal("123")]
        )
    }
    
    @Test func wildcard() {
        #expect(
            OSCAddressPattern.Component(string: "*").tokens ==
            [.zeroOrMoreWildcard]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "**").tokens ==
            [.zeroOrMoreWildcard]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "***").tokens ==
            [.zeroOrMoreWildcard]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "*abc*").tokens ==
            [
                .zeroOrMoreWildcard,
                .literal("abc"),
                .zeroOrMoreWildcard
            ]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "**ab**c**").tokens ==
            [
                .zeroOrMoreWildcard,
                .literal("ab"),
                .zeroOrMoreWildcard,
                .literal("c"),
                .zeroOrMoreWildcard
            ]
        )
    }
    
    @Test func brackets() {
        #expect(
            OSCAddressPattern.Component(string: "[]").tokens ==
            [.singleChar(
                isExclusion: false,
                groups: []
            )]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z]").tokens ==
            [.singleChar(
                isExclusion: false,
                groups: [.asciiRange(start: "a", end: "z")]
            )]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-z][A-Z][0-9]").tokens ==
            [
                .singleChar(
                    isExclusion: false,
                    groups: [.asciiRange(start: "a", end: "z")]
                ),
                .singleChar(
                    isExclusion: false,
                    groups: [.asciiRange(start: "A", end: "Z")]
                ),
                .singleChar(
                    isExclusion: false,
                    groups: [.asciiRange(start: "0", end: "9")]
                )
            ]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[a-zA-Z0-9]").tokens ==
            [
                .singleChar(
                    isExclusion: false,
                    groups: [
                        .asciiRange(start: "a", end: "z"),
                        .asciiRange(start: "A", end: "Z"),
                        .asciiRange(start: "0", end: "9")
                    ]
                )
            ]
        )
    }
    
    @Test func bracketsExcluded() {
        #expect(
            OSCAddressPattern.Component(string: "[!]").tokens ==
            [.singleChar(
                isExclusion: true,
                groups: []
            )]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!a-z]").tokens ==
            [.singleChar(
                isExclusion: true,
                groups: [.asciiRange(start: "a", end: "z")]
            )]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!a-z][A-Z][0-9]").tokens ==
            [
                .singleChar(
                    isExclusion: true,
                    groups: [.asciiRange(start: "a", end: "z")]
                ),
                .singleChar(
                    isExclusion: false,
                    groups: [.asciiRange(start: "A", end: "Z")]
                ),
                .singleChar(
                    isExclusion: false,
                    groups: [.asciiRange(start: "0", end: "9")]
                )
            ]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "[!a-zA-Z0-9]").tokens ==
            [
                .singleChar(
                    isExclusion: true,
                    groups: [
                        .asciiRange(start: "a", end: "z"),
                        .asciiRange(start: "A", end: "Z"),
                        .asciiRange(start: "0", end: "9")
                    ]
                )
            ]
        )
    }
    
    @Test func braces() {
        #expect(
            OSCAddressPattern.Component(string: "{}").tokens ==
            [.strings(strings: [])]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{,}").tokens ==
            [.strings(strings: [])]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{abc}").tokens ==
            [.strings(strings: ["abc"])]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{abc,def}").tokens ==
            [.strings(strings: ["abc", "def"])]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{abc,}").tokens ==
            [.strings(strings: ["abc"])]
        )
        
        #expect(
            OSCAddressPattern.Component(string: "{,abc}").tokens ==
            [.strings(strings: ["abc"])]
        )
    }
    
    @Test func complex() {
        #expect(
            OSCAddressPattern.Component(string: "abc*{def,xyz}?[0-9]").tokens ==
            [
                .literal("abc"),
                .zeroOrMoreWildcard,
                .strings(strings: ["def", "xyz"]),
                .singleCharWildcard,
                .singleChar(
                    isExclusion: false,
                    groups: [.asciiRange(start: "0", end: "9")]
                )
            ]
        )
    }
}
