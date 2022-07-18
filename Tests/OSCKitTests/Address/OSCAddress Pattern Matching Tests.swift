//
//  OSCAddress Pattern Matching Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if !os(watchOS)

import XCTest
@testable import OSCKit

final class OSCAddressPatternMatchingTests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    #warning("> TODO: finish unit tests")
    
    func testPathComponent_Pattern_MatchesName_NoPattern() {
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "123", matches: "123")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "123", matches: "ABC")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "", matches: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "", matches: "")
        )
        
        // edge cases
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "12", matches: "123")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "1234", matches: "123")
        )
        
    }
    
    func testPathComponent_Pattern_MatchesName_VariableWildcard() {
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "*", matches: "1")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "*", matches: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "1*", matches: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "12*", matches: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "123*", matches: "123")
        )
        
        #warning("> TODO: uncomment once pattern parser is finished")
        
//        XCTAssertTrue(
//            OSCAddress.pathComponent(pattern: "*3", matches: "123")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.pathComponent(pattern: "*23", matches: "123")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.pathComponent(pattern: "*123", matches: "123")
//        )
        
        // edge cases
        
        #warning("> TODO: uncomment once pattern parser is finished")
        
//        XCTAssertTrue(
//            OSCAddress.pathComponent(pattern: "***", matches: "1")
//        )
        
//        XCTAssertTrue(
//            OSCAddress.pathComponent(pattern: "****", matches: "123")
//        )
        
    }
    
    func testPathComponent_Pattern_MatchesName_Complex() {
        
        #warning("> TODO: add complex pattern tests")
        
        // such as:
        
        // abc*
        // *abc
        // *abc*
        // *a*bc*
        // abc*{def,xyz}[0-9]
        // *abc{def,xyz}[0-9]
        // {def,xyz}*[0-9]
        // abc*{def,xyz}[A-F0-9][A-F0-9]
        
    }
    
    func testPathComponent_Pattern_MatchesName_SingleWildcard() {
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "?", matches: "1")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "?", matches: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "???", matches: "123")
        )
        
    }
    
    func testPathComponent_Pattern_MatchesName_Bracket() {
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "[abc]", matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "[abc]", matches: "c")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "[abc]", matches: "d")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "[a-z]", matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "[a-z]", matches: "z")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "[b-y]", matches: "z")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "[b-y]", matches: "bb")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "[b-y]", matches: "ab")
        )
        
    }
    
    func testPathComponent_Pattern_MatchesName_Brace() {
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "{abc}", matches: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "{abc,def}", matches: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "{def,abc}", matches: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "{def}", matches: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "{def,ghi}", matches: "abc")
        )
        
    }
    
    func testPathComponent_Pattern_MatchesName_BracketsAndBraces() {
        
        XCTAssertTrue(
            OSCAddress.pathComponent(pattern: "[0-9]{def,abc}", matches: "1abc")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "[0-9]{def,abc}", matches: "1ABC")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "[0-9]{def,abc}", matches: "zabc")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "[0-9]{def,abc}", matches: "1abcz")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(pattern: "[0-9]{def,abc}", matches: "1")
        )
        
    }
    
    func testPathComponent_BracketExpression_Basic() {
        
        // basic match
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "asdf",
                                     matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "asdf",
                                     matches: "s")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "asdf",
                                     matches: "f")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "asdf",
                                     matches: "A")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "asdf",
                                     matches: "S")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "asdf",
                                     matches: "F")
        )
        
        // basic mismatch
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "asdf",
                                     matches: "q")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "asdf",
                                     matches: "Q")
        )
        
    }
    
    func testPathComponent_BracketExpression_BasicRange() {
        
        // matches
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "c")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "x")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "y")
        )
        
        // mismatches
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "B")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "C")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "X")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "Y")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "b-y",
                                     matches: "z")
        )
        
    }
    
    func testPathComponent_BracketExpression_BasicRange_Malformed() {
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "y-b",
                                     matches: "b")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "y-b",
                                     matches: "c")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "y-b",
                                     matches: "x")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "y-b",
                                     matches: "y")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "y-b",
                                     matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "a-a",
                                     matches: "a")
        )
        
        // undefined, but lone hyphen can match itself
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "-",
                                     matches: "-")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "-",
                                     matches: "b")
        )
        
        // undefined, but incomplete range can simply match characters as-is
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "y-",
                                     matches: "b")
        )
        
        // undefined, but incomplete range can simply match characters as-is
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "-y",
                                     matches: "b")
        )
        
        // undefined, but incomplete range can simply match characters as-is
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "b-",
                                     matches: "b")
        )
        
        // undefined, but incomplete range can simply match characters as-is
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "-b",
                                     matches: "b")
        )
        
        // undefined, but incomplete range can simply match characters as-is
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "-b",
                                     matches: "b")
        )
        
    }
    
    func testPathComponent_BracketExpression_Complex() {
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "aBNz14",
                                     matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "aBNz14",
                                     matches: "B")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "a-zA-Z",
                                     matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "a-zA-Z",
                                     matches: "B")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "a-zA-Z0-9",
                                     matches: "4")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "a-zA-Z12345",
                                     matches: "4")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "12345a-zA-Z",
                                     matches: "4")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "a-z12345A-Z",
                                     matches: "4")
        )
        
    }
    
    func testPathComponent_BracketExpression_Exclusion() {
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "!b",
                                     matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "!B",
                                     matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "!aBNz14",
                                     matches: "b")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "!aBNz14",
                                     matches: "B")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "!a-z",
                                     matches: "B")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "!A-Z",
                                     matches: "B")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "!a-zA-Z",
                                     matches: "B")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "!a-zA-Z",
                                     matches: "b")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "!b-b",
                                     matches: "b")
        )
        
        // edge cases
        
        // undefined. but since it's an exclusion, technically no characters
        // after the ! could return true
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "!",
                                     matches: "b")
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(bracketExpression: "!!",
                                     matches: "!")
        )
        
        XCTAssertTrue(
            OSCAddress.pathComponent(bracketExpression: "!!",
                                     matches: "b")
        )
        
    }
    
    func testPathComponent_BraceExpression_Basic() {
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "a",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 1)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "ab",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 2)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "abcd",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "abcd,a",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "abcde,abcd",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "abcd,wxyz",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "wxyz,abcd",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: ",abcd",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "abcd,",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "abcd,,",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: ",abcd,",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: ",,abcd",
                                             prefixes: "abcd")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 4)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "abcd,abc",
                                             prefixes: "abc")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 3)
        }
        
        do {
            let r = OSCAddress.pathComponent(braceExpression: "abcd,abc",
                                             prefixes: "abcxyz")
            XCTAssertTrue(r.isMatch)
            XCTAssertEqual(r.length, 3)
        }
        
    }
    
    func testPathComponent_BraceExpression_EdgeCases() {
        
        XCTAssertFalse(
            OSCAddress.pathComponent(braceExpression: "",
                                     prefixes: "abcd").isMatch
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(braceExpression: "",
                                     prefixes: "").isMatch
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(braceExpression: ",",
                                     prefixes: "abcd").isMatch
        )
        
        XCTAssertFalse(
            OSCAddress.pathComponent(braceExpression: ",,",
                                     prefixes: "abcd").isMatch
        )
        
    }
    
}

#endif
