//
//  Component Parse Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

@testable import OSCKitCore
import XCTest

final class OSCAddressPattern_Component_Parse_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testBasic() {
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "").tokens,
            []
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "1").tokens,
            [.literal("1")]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "123").tokens,
            [.literal("123")]
        )
    }
    
    func testWildcard() {
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "*").tokens,
            [.zeroOrMoreWildcard]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "**").tokens,
            [.zeroOrMoreWildcard]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "***").tokens,
            [.zeroOrMoreWildcard]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "*abc*").tokens,
            [
                .zeroOrMoreWildcard,
                .literal("abc"),
                .zeroOrMoreWildcard
            ]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "**ab**c**").tokens,
            [
                .zeroOrMoreWildcard,
                .literal("ab"),
                .zeroOrMoreWildcard,
                .literal("c"),
                .zeroOrMoreWildcard
            ]
        )
    }
    
    func testBrackets() {
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "[]").tokens,
            [.singleChar(
                isExclusion: false,
                groups: []
            )]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "[a-z]").tokens,
            [.singleChar(
                isExclusion: false,
                groups: [.asciiRange(start: "a", end: "z")]
            )]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "[a-z][A-Z][0-9]").tokens,
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
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "[a-zA-Z0-9]").tokens,
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
    
    func testBracketsExcluded() {
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "[!]").tokens,
            [.singleChar(
                isExclusion: true,
                groups: []
            )]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "[!a-z]").tokens,
            [.singleChar(
                isExclusion: true,
                groups: [.asciiRange(start: "a", end: "z")]
            )]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "[!a-z][A-Z][0-9]").tokens,
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
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "[!a-zA-Z0-9]").tokens,
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
    
    func testBraces() {
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "{}").tokens,
            [.strings(strings: [])]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "{,}").tokens,
            [.strings(strings: [])]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "{abc}").tokens,
            [.strings(strings: ["abc"])]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "{abc,def}").tokens,
            [.strings(strings: ["abc", "def"])]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "{abc,}").tokens,
            [.strings(strings: ["abc"])]
        )
        
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "{,abc}").tokens,
            [.strings(strings: ["abc"])]
        )
    }
    
    func testComplex() {
        XCTAssertEqual(
            OSCAddressPattern.Component(string: "abc*{def,xyz}?[0-9]").tokens,
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
