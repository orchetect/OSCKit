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

        XCTAssertTrue(
            OSCAddress.Pattern(string: "[abc]")!.evaluate(matches: "a")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "[abc]")!.evaluate(matches: "c")
        )

        XCTAssertFalse(
            OSCAddress.Pattern(string: "[abc]")!.evaluate(matches: "d")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z]")!.evaluate(matches: "a")
        )

        XCTAssertTrue(
            OSCAddress.Pattern(string: "[a-z]")!.evaluate(matches: "z")
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
