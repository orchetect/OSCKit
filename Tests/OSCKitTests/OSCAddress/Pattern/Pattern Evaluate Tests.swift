//
//  Pattern Evaluate Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCAddress_Pattern_Evaluate_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Individual pattern types
    
    func testEmptyPattern() {
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "").evaluate(matching: "")
        )
        
    }
    
    func testBasicLiterals() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "123").evaluate(matching: "123")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "123").evaluate(matching: "ABC")
        )
        
        // edge cases
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "12").evaluate(matching: "123")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "1234").evaluate(matching: "123")
        )
        
    }
    
    func testVariableWildcard() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*").evaluate(matching: "1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "1*").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "12*").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "123*").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*3").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*23").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*123").evaluate(matching: "123")
        )
        
    }
    
    func testVariableWildcard_EdgeCases() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "***").evaluate(matching: "1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "****").evaluate(matching: "123")
        )
        
    }
    
    func testSingleWildcard() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "?").evaluate(matching: "1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "?").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "???").evaluate(matching: "123")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "????").evaluate(matching: "123")
        )
        
    }
    
    func testBracket() {
        
        // single chars
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[abc]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[abc]").evaluate(matching: "c")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[abc]").evaluate(matching: "d")
        )
        
        // range
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z]").evaluate(matching: "z")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]").evaluate(matching: "C")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]").evaluate(matching: "z")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]").evaluate(matching: "bb")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]").evaluate(matching: "ab")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]").evaluate(matching: "-")
        )
        
        // single-member range
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[b-b]").evaluate(matching: "b")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-b]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-b]").evaluate(matching: "c")
        )
        
        // invalid range
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[y-b]").evaluate(matching: "c")
        )
        
        // mixed ranges
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9]").evaluate(matching: "1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[a-z0-9]").evaluate(matching: "Z")
        )
        
        // mixed singles and ranges
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9XY]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9XY]").evaluate(matching: "1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9XY]").evaluate(matching: "X")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]").evaluate(matching: "X")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]").evaluate(matching: "Y")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]").evaluate(matching: "Z")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]").evaluate(matching: "A")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]").evaluate(matching: "-")
        )
        
        // edge cases
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-z]").evaluate(matching: "-")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-z]").evaluate(matching: "z")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[-z]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-]").evaluate(matching: "-")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[a-]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[b-y-]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[b-y-]").evaluate(matching: "y")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[b-y-]").evaluate(matching: "-")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-b-y]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-b-y]").evaluate(matching: "y")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-b-y]").evaluate(matching: "-")
        )
        
    }
    
    func testBracket_isExcluded_SingleChars() {
        
        // single chars
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!abc]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!abc]").evaluate(matching: "c")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!abc]").evaluate(matching: "d")
        )
        
    }
    
    func testBracket_isExcluded_Range() {
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!b-y]").evaluate(matching: "b")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!b-y]").evaluate(matching: "y")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-y]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-y]").evaluate(matching: "z")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-y]").evaluate(matching: "B")
        )
        
    }
    
    func testBracket_SingleMemberRange() {
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!b-b]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-b]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-b]").evaluate(matching: "c")
        )
        
    }
    
    func testBracket_MixedRanges() {
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9]").evaluate(matching: "1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!a-z0-9]").evaluate(matching: "A")
        )
        
    }
    
    func testBracket_EdgeCases() {
        
        // invalid range
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!y-b]").evaluate(matching: "c")
        )
        
        // edge cases
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!]").evaluate(matching: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!!]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!!]").evaluate(matching: "!")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!!a]").evaluate(matching: "a")
        )
        
    }
    
    func testBracket_MixedSinglesAndRanges() {
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9XY]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9XY]").evaluate(matching: "1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9XY]").evaluate(matching: "x")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9XY]").evaluate(matching: "X")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!a-z0-9XY]").evaluate(matching: "A")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!a-z0-9XY]").evaluate(matching: "Z")
        )
        
    }
    
    func testBrace() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{abc}").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{abc,def}").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{def,abc}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{def}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{def,ghi}").evaluate(matching: "abc")
        )
        
    }
    
    func testBrace_EdgeCases() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{,abc}").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{abc,}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{,abc}").evaluate(matching: "")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{abc,}").evaluate(matching: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{}").evaluate(matching: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{,}").evaluate(matching: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{}abc").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{,}abc").evaluate(matching: "abc")
        )
        
    }
    
    func testBrace_Malformed_A() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{abc,def").evaluate(matching: "{abc,def")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{abc,def").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{abc,def").evaluate(matching: "def")
        )
        
    }
    
    func testBrace_Malformed_B() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "}abc,def").evaluate(matching: "}abc,def")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "}abc,def").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "}abc,def").evaluate(matching: "def")
        )
        
    }
    
    func testBrace_Malformed_C() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{{abc,def").evaluate(matching: "{{abc,def")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{{abc,def").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{{abc,def").evaluate(matching: "def")
        )
        
    }
    
    func testBrace_Malformed_D() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc,def}").evaluate(matching: "abc,def}")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "abc,def}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "abc,def}").evaluate(matching: "def")
        )
        
    }
    
    func testBracketsAndBraces() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[0-9]{def,abc}").evaluate(matching: "1abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}").evaluate(matching: "1ABC")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}").evaluate(matching: "zabc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}").evaluate(matching: "1abcz")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}").evaluate(matching: "1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}").evaluate(matching: "abc")
        )
        
    }
    
    // MARK: - Complex patterns
    
    func testComplex_A() {
        
        // abc*
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*").evaluate(matching: "abcd")
        )
        
    }
    
    func testComplex_B() {
        
        // *abc
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc").evaluate(matching: "xabc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc").evaluate(matching: "xyabc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc").evaluate(matching: "abc1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc").evaluate(matching: "xyabc1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc").evaluate(matching: "xyABC")
        )
        
    }
    
    func testComplex_C() {
        
        // *abc*
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*").evaluate(matching: "abcd")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*").evaluate(matching: "xabc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*").evaluate(matching: "xabcd")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*").evaluate(matching: "xyabcde")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc*").evaluate(matching: "xyABCde")
        )
        
    }
    
    func testComplex_D() {
        
        // *a*bc*
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "a1bc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "1abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "abc1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "1a1bc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "a1bc1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "1a1bc1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "bc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "bca")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*a*bc*").evaluate(matching: "ABC")
        )
        
    }
    
    func testComplex_E() {
        
        // abc*{def,xyz}[0-9]
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcdef1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcXxyz2")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcXXxyz2")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcxyzX")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]").evaluate(matching: "dummyName123")
        )
        
    }
    
    func testComplex_F() {
        
        // *abc{def,xyz}[0-9]
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdef1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]").evaluate(matching: "Xabcdef1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]").evaluate(matching: "XXabcdef1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdefX")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdef1X")
        )
        
    }
    
    func testComplex_G() {
        
        // abc*{def,xyz}[A-F0-9][A-F0-9]
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[A-F0-9][A-F0-9]").evaluate(matching: "abcdef7F")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[A-F0-9][A-F0-9]").evaluate(matching: "abcXdefF7")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "abc*{def,xyz}[A-F0-9][A-F0-9]").evaluate(matching: "abcdefFG")
        )
        
    }
    
    func testComplex_EdgeCases_WildcardInBrackets() {
        
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[*abc]").evaluate(matching: "*")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[*abc]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[*abc]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[*abc]").evaluate(matching: "c")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[*abc]").evaluate(matching: "x")
        )
        
    }
    
    func testComplex_EdgeCases_SingleWildcardInBrackets() {
        
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[?abc]").evaluate(matching: "?")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[?abc]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[?abc]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[?abc]").evaluate(matching: "c")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[?abc]").evaluate(matching: "x")
        )
        
    }
    
    func testComplex_EdgeCases_WildcardInBraces() {
        
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{*abc,def}").evaluate(matching: "*abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{*abc,def}").evaluate(matching: "def")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{*abc,def}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{*abc,def}").evaluate(matching: "xabc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{*abc,def}").evaluate(matching: "xxabc")
        )
        
    }
    
    func testComplex_EdgeCases_SingleWildcardInBraces() {
        
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{?abc,def}").evaluate(matching: "?abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{?abc,def}").evaluate(matching: "def")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{?abc,def}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{?abc,def}").evaluate(matching: "xabc")
        )
        
    }
    
    func testComplex_EdgeCases_ExclamationPointInBraces() {
        
        // test the use of ! within brackets.
        // according to the OSC 1.0 spec, ! is only valid if used as the first
        // character within a [] bracketed expression, not within braces {}
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{!abc,def}").evaluate(matching: "!abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{!abc,def}").evaluate(matching: "def")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{!abc,def}").evaluate(matching: "abc")
        )
        
    }
    
}

#endif
