//
//  Pattern Parse Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCAddress_Pattern_Parse_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testBasic() {
        
        XCTAssertEqual(OSCAddress.Pattern(string: "").tokens,
                       [])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "1").tokens,
                       [.literal("1")])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "123").tokens,
                       [.literal("123")])
        
    }
    
    func testWildcard() {
        
        XCTAssertEqual(OSCAddress.Pattern(string: "*").tokens,
                       [.zeroOrMoreWildcard])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "**").tokens,
                       [.zeroOrMoreWildcard])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "***").tokens,
                       [.zeroOrMoreWildcard])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "*abc*").tokens,
                       [.zeroOrMoreWildcard,
                        .literal("abc"),
                        .zeroOrMoreWildcard])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "**ab**c**").tokens,
                       [.zeroOrMoreWildcard,
                        .literal("ab"),
                        .zeroOrMoreWildcard,
                        .literal("c"),
                        .zeroOrMoreWildcard])
        
    }
    
    func testBrackets() {
        
        XCTAssertEqual(OSCAddress.Pattern(string: "[]").tokens,
                       [.singleChar(isExclusion: false,
                                    groups: [])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "[a-z]").tokens,
                       [.singleChar(isExclusion: false,
                                    groups: [.asciiRange(start: "a", end: "z")])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "[a-z][A-Z][0-9]").tokens,
                       [.singleChar(isExclusion: false,
                                    groups: [.asciiRange(start: "a", end: "z")]),
                        .singleChar(isExclusion: false,
                                    groups: [.asciiRange(start: "A", end: "Z")]),
                        .singleChar(isExclusion: false,
                                    groups: [.asciiRange(start: "0", end: "9")])
                       ])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "[a-zA-Z0-9]").tokens,
                       [.singleChar(isExclusion: false,
                                    groups: [.asciiRange(start: "a", end: "z"),
                                             .asciiRange(start: "A", end: "Z"),
                                             .asciiRange(start: "0", end: "9")])
                       ])
        
    }
    
    func testBracketsExcluded() {
        
        XCTAssertEqual(OSCAddress.Pattern(string: "[!]").tokens,
                       [.singleChar(isExclusion: true,
                                    groups: [])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "[!a-z]").tokens,
                       [.singleChar(isExclusion: true,
                                    groups: [.asciiRange(start: "a", end: "z")])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "[!a-z][A-Z][0-9]").tokens,
                       [.singleChar(isExclusion: true,
                                    groups: [.asciiRange(start: "a", end: "z")]),
                        .singleChar(isExclusion: false,
                                    groups: [.asciiRange(start: "A", end: "Z")]),
                        .singleChar(isExclusion: false,
                                    groups: [.asciiRange(start: "0", end: "9")])
                       ])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "[!a-zA-Z0-9]").tokens,
                       [.singleChar(isExclusion: true,
                                    groups: [.asciiRange(start: "a", end: "z"),
                                             .asciiRange(start: "A", end: "Z"),
                                             .asciiRange(start: "0", end: "9")])
                       ])
        
    }
    
    func testBraces() {
        
        XCTAssertEqual(OSCAddress.Pattern(string: "{}").tokens,
                       [.strings(strings: [])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "{,}").tokens,
                       [.strings(strings: [])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "{abc}").tokens,
                       [.strings(strings: ["abc"])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "{abc,def}").tokens,
                       [.strings(strings: ["abc", "def"])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "{abc,}").tokens,
                       [.strings(strings: ["abc"])])
        
        XCTAssertEqual(OSCAddress.Pattern(string: "{,abc}").tokens,
                       [.strings(strings: ["abc"])])
        
    }
    
    func testComplex() {
        
        XCTAssertEqual(OSCAddress.Pattern(string: "abc*{def,xyz}?[0-9]").tokens,
                       [
                        .literal("abc"),
                        .zeroOrMoreWildcard,
                        .strings(strings: ["def", "xyz"]),
                        .singleCharWildcard,
                        .singleChar(isExclusion: false,
                                    groups: [.asciiRange(start: "0", end: "9")])
                       ])
        
    }
    
}

#endif
