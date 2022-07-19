//
//  Pattern Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCAddress_Pattern_Tests: XCTestCase {

    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }

    // MARK: - Individual pattern types
    
    func testEvaluate_NoPattern() {

        XCTAssertTrue(
            OSCAddress.Pattern(string: "123")!.evaluate(matches: "123")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "123")!.evaluate(matches: "ABC")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "")!.evaluate(matches: "123")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "")!.evaluate(matches: "")
        )

        // edge cases

        XCTAssertFalse(
            OSCAddress.Pattern(string: "12")!.evaluate(matches: "123")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "1234")!.evaluate(matches: "123")
        )

    }

    func testEvaluate_VariableWildcard() {

        XCTAssertTrue(
            OSCAddress.Pattern(string: "*")!.evaluate(matches: "1")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "*")!.evaluate(matches: "123")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "1*")!.evaluate(matches: "123")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "12*")!.evaluate(matches: "123")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "123*")!.evaluate(matches: "123")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "*3")!.evaluate(matches: "123")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "*23")!.evaluate(matches: "123")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "*123")!.evaluate(matches: "123")
        )

        // edge cases

        XCTAssertTrue(
            OSCAddress.Pattern(string: "***")!.evaluate(matches: "1")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "****")!.evaluate(matches: "123")
        )

    }
    
    func testEvaluate_SingleWildcard() {

        XCTAssertTrue(
            OSCAddress.Pattern(string: "?")!.evaluate(matches: "1")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "?")!.evaluate(matches: "123")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "???")!.evaluate(matches: "123")
        )

    }

    func testEvaluate_Bracket() {
        
        // single chars
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[abc]")!.evaluate(matches: "a")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "[abc]")!.evaluate(matches: "c")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "[abc]")!.evaluate(matches: "d")
        )

        // range
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z]")!.evaluate(matches: "a")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z]")!.evaluate(matches: "z")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]")!.evaluate(matches: "C")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]")!.evaluate(matches: "z")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]")!.evaluate(matches: "bb")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]")!.evaluate(matches: "ab")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-y]")!.evaluate(matches: "-")
        )
        
        // single-member range
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[b-b]")!.evaluate(matches: "b")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-b]")!.evaluate(matches: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[b-b]")!.evaluate(matches: "c")
        )
        
        // invalid range
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[y-b]")!.evaluate(matches: "c")
        )
        
        // mixed ranges
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9]")!.evaluate(matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9]")!.evaluate(matches: "1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[a-z0-9]")!.evaluate(matches: "Z")
        )
        
        // mixed singles and ranges
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9XY]")!.evaluate(matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9XY]")!.evaluate(matches: "1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z0-9XY]")!.evaluate(matches: "X")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]")!.evaluate(matches: "X")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]")!.evaluate(matches: "Y")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]")!.evaluate(matches: "Z")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]")!.evaluate(matches: "A")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[Xa-z0-9YZ]")!.evaluate(matches: "-")
        )
        
        // edge cases
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-z]")!.evaluate(matches: "-")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-z]")!.evaluate(matches: "z")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[-z]")!.evaluate(matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-]")!.evaluate(matches: "-")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-]")!.evaluate(matches: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[a-]")!.evaluate(matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[b-y-]")!.evaluate(matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[b-y-]")!.evaluate(matches: "y")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[b-y-]")!.evaluate(matches: "-")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-b-y]")!.evaluate(matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-b-y]")!.evaluate(matches: "y")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[-b-y]")!.evaluate(matches: "-")
        )
        
    }
    
    func testEvaluate_Bracket_isExcluded() {
        
        // single chars
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!abc]")!.evaluate(matches: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!abc]")!.evaluate(matches: "c")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!abc]")!.evaluate(matches: "d")
        )
        
        // range
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!b-y]")!.evaluate(matches: "b")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!b-y]")!.evaluate(matches: "y")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-y]")!.evaluate(matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-y]")!.evaluate(matches: "z")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-y]")!.evaluate(matches: "B")
        )
        
        // single-member range
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!b-b]")!.evaluate(matches: "b")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-b]")!.evaluate(matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!b-b]")!.evaluate(matches: "c")
        )
        
        // invalid range
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!y-b]")!.evaluate(matches: "c")
        )
        
        // mixed ranges
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9]")!.evaluate(matches: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9]")!.evaluate(matches: "1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!a-z0-9]")!.evaluate(matches: "A")
        )
        
        // edge cases
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!]")!.evaluate(matches: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!]")!.evaluate(matches: "a")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!!]")!.evaluate(matches: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!!]")!.evaluate(matches: "!")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!!a]")!.evaluate(matches: "a")
        )
        
        // mixed singles and ranges
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9XY]")!.evaluate(matches: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9XY]")!.evaluate(matches: "1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9XY]")!.evaluate(matches: "x")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[!a-z0-9XY]")!.evaluate(matches: "X")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!a-z0-9XY]")!.evaluate(matches: "A")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "[!a-z0-9XY]")!.evaluate(matches: "Z")
        )
        
    }

    func testEvaluate_Brace() {

        XCTAssertTrue(
            OSCAddress.Pattern(string: "{abc}")!.evaluate(matches: "abc")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "{abc,def}")!.evaluate(matches: "abc")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "{def,abc}")!.evaluate(matches: "abc")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "{def}")!.evaluate(matches: "abc")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "{def,ghi}")!.evaluate(matches: "abc")
        )
        
        // edge cases
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{,abc}")!.evaluate(matches: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{abc,}")!.evaluate(matches: "abc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{,abc}")!.evaluate(matches: "")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "{abc,}")!.evaluate(matches: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{}")!.evaluate(matches: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{,}")!.evaluate(matches: "")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{}abc")!.evaluate(matches: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "{,}abc")!.evaluate(matches: "abc")
        )

    }

    func testEvaluate_BracketsAndBraces() {

        XCTAssertTrue(
            OSCAddress.Pattern(string: "[0-9]{def,abc}")!.evaluate(matches: "1abc")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}")!.evaluate(matches: "1ABC")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}")!.evaluate(matches: "zabc")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}")!.evaluate(matches: "1abcz")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}")!.evaluate(matches: "1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "[0-9]{def,abc}")!.evaluate(matches: "abc")
        )
        
    }
    
    // MARK: - Complex patterns
    
    func testEvaluate_Complex_A() {
        
        // abc*
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*")!.evaluate(matches: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*")!.evaluate(matches: "abcd")
        )
        
    }
    
    func testEvaluate_Complex_B() {
        
        // *abc
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc")!.evaluate(matches: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc")!.evaluate(matches: "xabc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc")!.evaluate(matches: "xyabc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc")!.evaluate(matches: "abc1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc")!.evaluate(matches: "xyabc1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc")!.evaluate(matches: "xyABC")
        )
        
    }
    
    func testEvaluate_Complex_C() {
        
        // *abc*
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*")!.evaluate(matches: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*")!.evaluate(matches: "abcd")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*")!.evaluate(matches: "xabc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*")!.evaluate(matches: "xabcd")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc*")!.evaluate(matches: "xyabcde")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc*")!.evaluate(matches: "xyABCde")
        )
        
    }
    
    func testEvaluate_Complex_D() {
        
        // *a*bc*
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "a1bc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "1abc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "abc1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "1a1bc")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "a1bc1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "1a1bc1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "a")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "bc")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "bca")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*a*bc*")!.evaluate(matches: "ABC")
        )
        
    }
    
    func testEvaluate_Complex_E() {
        
        // abc*{def,xyz}[0-9]
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]")!.evaluate(matches: "abcdef1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]")!.evaluate(matches: "abcXxyz2")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]")!.evaluate(matches: "abcXXxyz2")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]")!.evaluate(matches: "abcxyzX")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "abc*{def,xyz}[0-9]")!.evaluate(matches: "dummyName123")
        )
        
    }
    
    func testEvaluate_Complex_F() {
        
        // *abc{def,xyz}[0-9]
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]")!.evaluate(matches: "abcdef1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]")!.evaluate(matches: "Xabcdef1")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]")!.evaluate(matches: "XXabcdef1")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]")!.evaluate(matches: "abcdefX")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "*abc{def,xyz}[0-9]")!.evaluate(matches: "abcdef1X")
        )
        
    }
    
    func testEvaluate_Complex_G() {
        
        // abc*{def,xyz}[A-F0-9][A-F0-9]
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")!.evaluate(matches: "abcdef7F")
        )
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")!.evaluate(matches: "abcXdefF7")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "abc*{def,xyz}[A-F0-9][A-F0-9]")!.evaluate(matches: "abcdefFG")
        )
        
    }
    
}

#endif
