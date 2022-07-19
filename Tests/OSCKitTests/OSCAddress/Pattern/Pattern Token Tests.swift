//
//  Pattern Token Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#warning("> TODO: refactor these unit tests to use new API")

//#if shouldTestCurrentPlatform
//
//import XCTest
//@testable import OSCKit
//
//final class OSCAddress_PatternToken_Tests: XCTestCase {
//
//    override func setUp() { super.setUp() }
//    override func tearDown() { super.tearDown() }
//
//    func testEvaluateBracketExpression_Basic() {
//
//        // basic match
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "asdf",
//                                             matches: "a")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "asdf",
//                                             matches: "s")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "asdf",
//                                             matches: "f")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "asdf",
//                                             matches: "A")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "asdf",
//                                             matches: "S")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "asdf",
//                                             matches: "F")
//        )
//
//        // basic mismatch
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "asdf",
//                                             matches: "q")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "asdf",
//                                             matches: "Q")
//        )
//
//    }
//
//    func testEvaluateBracketExpression_BasicRange() {
//
//        // matches
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "b")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "c")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "x")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "y")
//        )
//
//        // mismatches
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "B")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "C")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "X")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "Y")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "a")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-y",
//                                             matches: "z")
//        )
//
//    }
//
//    func testEvaluateBracketExpression_BasicRange_Malformed() {
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "y-b",
//                                             matches: "b")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "y-b",
//                                             matches: "c")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "y-b",
//                                             matches: "x")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "y-b",
//                                             matches: "y")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "y-b",
//                                             matches: "a")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "a-a",
//                                             matches: "a")
//        )
//
//        // undefined, but lone hyphen can match itself
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "-",
//                                             matches: "-")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "-",
//                                             matches: "b")
//        )
//
//        // undefined, but incomplete range can simply match characters as-is
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "y-",
//                                             matches: "b")
//        )
//
//        // undefined, but incomplete range can simply match characters as-is
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "-y",
//                                             matches: "b")
//        )
//
//        // undefined, but incomplete range can simply match characters as-is
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "b-",
//                                             matches: "b")
//        )
//
//        // undefined, but incomplete range can simply match characters as-is
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "-b",
//                                             matches: "b")
//        )
//
//        // undefined, but incomplete range can simply match characters as-is
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "-b",
//                                             matches: "b")
//        )
//
//    }
//
//    func testEvaluateBracketExpression_Complex() {
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "aBNz14",
//                                             matches: "b")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "aBNz14",
//                                             matches: "B")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "a-zA-Z",
//                                             matches: "b")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "a-zA-Z",
//                                             matches: "B")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "a-zA-Z0-9",
//                                             matches: "4")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "a-zA-Z12345",
//                                             matches: "4")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "12345a-zA-Z",
//                                             matches: "4")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "a-z12345A-Z",
//                                             matches: "4")
//        )
//
//    }
//
//    func testEvaluateBracketExpression_Exclusion() {
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!b",
//                                             matches: "b")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!B",
//                                             matches: "b")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!aBNz14",
//                                             matches: "b")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!aBNz14",
//                                             matches: "B")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!a-z",
//                                             matches: "B")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!A-Z",
//                                             matches: "B")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!a-zA-Z",
//                                             matches: "B")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!a-zA-Z",
//                                             matches: "b")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!b-b",
//                                             matches: "b")
//        )
//
//        // edge cases
//
//        // undefined. but since it's an exclusion, technically no characters
//        // after the ! could return true
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!",
//                                             matches: "b")
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!!",
//                                             matches: "!")
//        )
//
//        XCTAssertTrue(
//            OSCAddress.Pattern.pathComponent(bracketExpression: "!!",
//                                             matches: "b")
//        )
//
//    }
//
//    func testEvaluateBraceExpression_Basic() {
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "a",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 1)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "ab",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 2)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "abcd",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "abcd,a",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "abcde,abcd",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "abcd,wxyz",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "wxyz,abcd",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: ",abcd",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "abcd,",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "abcd,,",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: ",abcd,",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: ",,abcd",
//                                                     prefixes: "abcd")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 4)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "abcd,abc",
//                                                     prefixes: "abc")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 3)
//        }
//
//        do {
//            let r = OSCAddress.Pattern.pathComponent(braceExpression: "abcd,abc",
//                                                     prefixes: "abcxyz")
//            XCTAssertTrue(r.isMatch)
//            XCTAssertEqual(r.length, 3)
//        }
//
//    }
//
//    func testEvaluateBraceExpression_EdgeCases() {
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(braceExpression: "",
//                                             prefixes: "abcd").isMatch
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(braceExpression: "",
//                                             prefixes: "").isMatch
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(braceExpression: ",",
//                                             prefixes: "abcd").isMatch
//        )
//
//        XCTAssertFalse(
//            OSCAddress.Pattern.pathComponent(braceExpression: ",,",
//                                             prefixes: "abcd").isMatch
//        )
//
//    }
//
//}
//
//#endif
