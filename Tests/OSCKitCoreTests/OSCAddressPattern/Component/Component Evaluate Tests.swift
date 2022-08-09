//
//  Component Evaluate Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore

final class OSCAddressPattern_Component_Evaluate_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Individual pattern types
    
    func testEmptyPattern() {
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "").evaluate(matching: "")
        )
    }
    
    func testBasicLiterals() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "123").evaluate(matching: "123")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "123").evaluate(matching: "ABC")
        )
        
        // edge cases
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "12").evaluate(matching: "123")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "1234").evaluate(matching: "123")
        )
    }
    
    func testVariableWildcard() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*").evaluate(matching: "1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "1*").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "12*").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "123*").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*3").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*23").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*123").evaluate(matching: "123")
        )
    }
    
    func testVariableWildcard_EdgeCases() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "***").evaluate(matching: "1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "****").evaluate(matching: "123")
        )
    }
    
    func testSingleWildcard() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "?").evaluate(matching: "1")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "?").evaluate(matching: "123")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "???").evaluate(matching: "123")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "????").evaluate(matching: "123")
        )
    }
    
    func testBracket() {
        // single chars
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[abc]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[abc]").evaluate(matching: "c")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[abc]").evaluate(matching: "d")
        )
        
        // range
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-z]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-z]").evaluate(matching: "z")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "C")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "z")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "bb")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "ab")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[b-y]").evaluate(matching: "-")
        )
        
        // single-member range
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[b-b]").evaluate(matching: "b")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[b-b]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[b-b]").evaluate(matching: "c")
        )
        
        // invalid range
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[y-b]").evaluate(matching: "c")
        )
        
        // mixed ranges
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-z0-9]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-z0-9]").evaluate(matching: "1")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[a-z0-9]").evaluate(matching: "Z")
        )
        
        // mixed singles and ranges
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-z0-9XY]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-z0-9XY]").evaluate(matching: "1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-z0-9XY]").evaluate(matching: "X")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "X")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "Y")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "Z")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "A")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[Xa-z0-9YZ]").evaluate(matching: "-")
        )
        
        // edge cases
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[-z]").evaluate(matching: "-")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[-z]").evaluate(matching: "z")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[-z]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-]").evaluate(matching: "-")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[a-]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[a-]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[b-y-]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[b-y-]").evaluate(matching: "y")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[b-y-]").evaluate(matching: "-")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[-b-y]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[-b-y]").evaluate(matching: "y")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[-b-y]").evaluate(matching: "-")
        )
    }
    
    func testBracket_isExcluded_SingleChars() {
        // single chars
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!abc]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!abc]").evaluate(matching: "c")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!abc]").evaluate(matching: "d")
        )
    }
    
    func testBracket_isExcluded_Range() {
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "b")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "y")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "z")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!b-y]").evaluate(matching: "B")
        )
    }
    
    func testBracket_SingleMemberRange() {
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!b-b]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!b-b]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!b-b]").evaluate(matching: "c")
        )
    }
    
    func testBracket_MixedRanges() {
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!a-z0-9]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!a-z0-9]").evaluate(matching: "1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!a-z0-9]").evaluate(matching: "A")
        )
    }
    
    func testBracket_EdgeCases() {
        // invalid range
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!y-b]").evaluate(matching: "c")
        )
        
        // edge cases
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!]").evaluate(matching: "")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!!]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!!]").evaluate(matching: "!")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!!a]").evaluate(matching: "a")
        )
    }
    
    func testBracket_MixedSinglesAndRanges() {
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "1")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "x")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "X")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "A")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[!a-z0-9XY]").evaluate(matching: "Z")
        )
    }
    
    func testBrace() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{abc}").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{abc,def}").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{def,abc}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{def}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{def,ghi}").evaluate(matching: "abc")
        )
    }
    
    func testBrace_EdgeCases() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{,abc}").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{abc,}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{,abc}").evaluate(matching: "")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{abc,}").evaluate(matching: "")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{}").evaluate(matching: "")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{,}").evaluate(matching: "")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{}abc").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{,}abc").evaluate(matching: "abc")
        )
    }
    
    func testBrace_Malformed_A() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{abc,def").evaluate(matching: "{abc,def")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{abc,def").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{abc,def").evaluate(matching: "def")
        )
    }
    
    func testBrace_Malformed_B() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "}abc,def").evaluate(matching: "}abc,def")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "}abc,def").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "}abc,def").evaluate(matching: "def")
        )
    }
    
    func testBrace_Malformed_C() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{{abc,def").evaluate(matching: "{{abc,def")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{{abc,def").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{{abc,def").evaluate(matching: "def")
        )
    }
    
    func testBrace_Malformed_D() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "abc,def}").evaluate(matching: "abc,def}")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "abc,def}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "abc,def}").evaluate(matching: "def")
        )
    }
    
    func testBracketsAndBraces() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "1abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "1ABC")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "zabc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "1abcz")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "1")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[0-9]{def,abc}").evaluate(matching: "abc")
        )
    }
    
    // MARK: - Complex patterns
    
    func testComplex_A() {
        // abc*
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "abc*").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "abc*").evaluate(matching: "abcd")
        )
    }
    
    func testComplex_B() {
        // *abc
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "xabc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "xyabc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "abc1")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "xyabc1")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*abc").evaluate(matching: "xyABC")
        )
    }
    
    func testComplex_C() {
        // *abc*
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "abcd")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "xabc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "xabcd")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "xyabcde")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*abc*").evaluate(matching: "xyABCde")
        )
    }
    
    func testComplex_D() {
        // *a*bc*
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "a1bc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "1abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "abc1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "1a1bc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "a1bc1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "1a1bc1")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "a")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "bc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "bca")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*a*bc*").evaluate(matching: "ABC")
        )
    }
    
    func testComplex_E() {
        // abc*{def,xyz}[0-9]
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcdef1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcXxyz2")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcXXxyz2")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]").evaluate(matching: "abcxyzX")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[0-9]").evaluate(matching: "dummyName123")
        )
    }
    
    func testComplex_F() {
        // *abc{def,xyz}[0-9]
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdef1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "Xabcdef1")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "XXabcdef1")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdefX")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "*abc{def,xyz}[0-9]").evaluate(matching: "abcdef1X")
        )
    }
    
    func testComplex_G() {
        // abc*{def,xyz}[A-F0-9][A-F0-9]
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")
                .evaluate(matching: "abcdef7F")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")
                .evaluate(matching: "abcXdefF7")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")
                .evaluate(matching: "abcdefFG")
        )
    }
    
    func testComplex_EdgeCases_WildcardInBrackets() {
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "*")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "c")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[*abc]").evaluate(matching: "x")
        )
    }
    
    func testComplex_EdgeCases_SingleWildcardInBrackets() {
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "?")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "a")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "b")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "c")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "[?abc]").evaluate(matching: "x")
        )
    }
    
    func testComplex_EdgeCases_WildcardInBraces() {
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "*abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "def")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "xabc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{*abc,def}").evaluate(matching: "xxabc")
        )
    }
    
    func testComplex_EdgeCases_SingleWildcardInBraces() {
        // test the use of wildcards within brackets.
        // according to the OSC 1.0 spec, wildcards are not special characters within brackets,
        // so we treat them as literal characters for sake of matching.
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{?abc,def}").evaluate(matching: "?abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{?abc,def}").evaluate(matching: "def")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{?abc,def}").evaluate(matching: "abc")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{?abc,def}").evaluate(matching: "xabc")
        )
    }
    
    func testComplex_EdgeCases_ExclamationPointInBraces() {
        // test the use of ! within brackets.
        // according to the OSC 1.0 spec, ! is only valid if used as the first
        // character within a [] bracketed expression, not within braces {}
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{!abc,def}").evaluate(matching: "!abc")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "{!abc,def}").evaluate(matching: "def")
        )
        
        XCTAssertFalse(
            OSCAddressPattern.Component(string: "{!abc,def}").evaluate(matching: "abc")
        )
    }
    
    func testEdgeCases_CommonSymbols() {
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "vol-").evaluate(matching: "vol-")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: "vol+").evaluate(matching: "vol+")
        )
        
        XCTAssertTrue(
            OSCAddressPattern.Component(string: ##"`!@#$%^&()-_=+,./<>;':"\|"##)
                .evaluate(matching: ##"`!@#$%^&()-_=+,./<>;':"\|"##)
        )
    }
}

#endif
