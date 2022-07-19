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
    
    func testEvaluate_NoPattern() {
        
        XCTAssertTrue(
            OSCAddress.Pattern(string: "123")!.evaluate(matches: "123")
        )
        
        XCTAssertFalse(
            OSCAddress.Pattern(string: "123")!.evaluate(matches: "ABC")
        )
        
        XCTAssertTrue(
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
        
        #warning("> TODO: uncomment once pattern parser is finished")
        
//        XCTAssertTrue(
//            OSCAddress.Pattern(string: "*3")!.evaluate(matches: "123")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern(string: "*23")!.evaluate(matches: "123")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern(string: "*123")!.evaluate(matches: "123")
//        )
        
        // edge cases
        
        #warning("> TODO: uncomment once pattern parser is finished")
        
        //        XCTAssertTrue(
//            OSCAddress.Pattern(string: "***")!.evaluate(matches: "1")
//        )

//        XCTAssertTrue(
//            OSCAddress.Pattern(string: "****")!.evaluate(matches: "123")
//        )
        
    }
    
    func testEvaluate_Complex() {
        
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
    
}

#endif
