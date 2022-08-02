//
//  Pattern Token Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore

final class OSCAddress_Pattern_Token_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testLiteral_Empty() {
        let t = OSCAddress.Pattern.Token.Literal(literal: "")
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .match(length: 0))
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 0))
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testLiteral_Basic() {
        let t = OSCAddress.Pattern.Token.Literal(literal: "abc")
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 3))
        XCTAssertEqual(t.matches(string: "abcdef"), .match(length: 3))
        XCTAssertEqual(t.matches(string: "xyz"), .noMatch)
        XCTAssertEqual(t.matches(string: "xyzabc"), .noMatch)
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testZeroOrMoreWildcard() {
        var t = OSCAddress.Pattern.Token.ZeroOrMoreWildcard()
        
        XCTAssertFalse(t.isExhausted)
        XCTAssertEqual(t.matches(string: ""), .match(length: 0))
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 0))
        XCTAssertEqual(t.matches(string: "abcdef"), .match(length: 0))
        
        t.next(remainingLength: 3)
        XCTAssertFalse(t.isExhausted)
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "abcdef"), .match(length: 1))
        
        t.next(remainingLength: 3)
        XCTAssertFalse(t.isExhausted)
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 2))
        XCTAssertEqual(t.matches(string: "abcdef"), .match(length: 2))
        
        t.next(remainingLength: 3)
        XCTAssertFalse(t.isExhausted)
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 3))
        XCTAssertEqual(t.matches(string: "abcdef"), .match(length: 3))
        
        t.next(remainingLength: 3)
        XCTAssertTrue(t.isExhausted)
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .noMatch)
        XCTAssertEqual(t.matches(string: "abcdef"), .match(length: 4))
        
        t.next(remainingLength: 3)
        XCTAssertTrue(t.isExhausted)
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .noMatch)
        XCTAssertEqual(t.matches(string: "abcdef"), .match(length: 5))
        
        t.next(remainingLength: 3)
        XCTAssertTrue(t.isExhausted)
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .noMatch)
        XCTAssertEqual(t.matches(string: "abcdef"), .match(length: 6))
        
        t.next(remainingLength: 3)
        XCTAssertTrue(t.isExhausted)
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .noMatch)
        XCTAssertEqual(t.matches(string: "abcdef"), .noMatch)
        
        t.reset()
        XCTAssertFalse(t.isExhausted)
    }
    
    func testSingleCharWildcard() {
        let t = OSCAddress.Pattern.Token.SingleCharWildcard()
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "ab"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 1))
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testSingleChar_Empty() {
        let t = OSCAddress.Pattern.Token.SingleChar(
            isExclusion: false,
            groups: []
        )
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .noMatch)
        XCTAssertEqual(t.matches(string: "ab"), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .noMatch)
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testSingleChar_Single() {
        let t = OSCAddress.Pattern.Token.SingleChar(
            isExclusion: false,
            groups: [.single("a")]
        )
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "ab"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "x"), .noMatch)
        XCTAssertEqual(t.matches(string: "xy"), .noMatch)
        
        XCTAssertEqual(t.matches(string: "A"), .noMatch)
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testSingleChar_Range() {
        let t = OSCAddress.Pattern.Token.SingleChar(
            isExclusion: false,
            groups: [.asciiRange(start: "b", end: "y")]
        )
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .noMatch)
        XCTAssertEqual(t.matches(string: "ab"), .noMatch)
        XCTAssertEqual(t.matches(string: "b"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "bc"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "y"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "yz"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "z"), .noMatch)
        
        XCTAssertEqual(t.matches(string: "B"), .noMatch)
        XCTAssertEqual(t.matches(string: "Y"), .noMatch)
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testSingleChar_SingleAndRange() {
        let t = OSCAddress.Pattern.Token.SingleChar(
            isExclusion: false,
            groups: [
                .single("a"),
                .asciiRange(start: "b", end: "y")
            ]
        )
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "b"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "c"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "y"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "z"), .noMatch)
        
        XCTAssertEqual(t.matches(string: "ac"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "bc"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "cc"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "yc"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "zc"), .noMatch)
        
        XCTAssertEqual(t.matches(string: "A"), .noMatch)
        XCTAssertEqual(t.matches(string: "B"), .noMatch)
        XCTAssertEqual(t.matches(string: "Y"), .noMatch)
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testSingleChar_Empty_isExclusion() {
        let t = OSCAddress.Pattern.Token.SingleChar(
            isExclusion: true,
            groups: []
        )
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "ab"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 1))
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testSingleChar_Single_isExclusion() {
        let t = OSCAddress.Pattern.Token.SingleChar(
            isExclusion: true,
            groups: [.single("a")]
        )
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .noMatch)
        XCTAssertEqual(t.matches(string: "ab"), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .noMatch)
        XCTAssertEqual(t.matches(string: "x"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "xy"), .match(length: 1))
        
        XCTAssertEqual(t.matches(string: "A"), .match(length: 1))
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testSingleChar_Range_isExclusion() {
        let t = OSCAddress.Pattern.Token.SingleChar(
            isExclusion: true,
            groups: [.asciiRange(start: "b", end: "y")]
        )
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "ab"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "b"), .noMatch)
        XCTAssertEqual(t.matches(string: "bc"), .noMatch)
        XCTAssertEqual(t.matches(string: "y"), .noMatch)
        XCTAssertEqual(t.matches(string: "yz"), .noMatch)
        XCTAssertEqual(t.matches(string: "z"), .match(length: 1))
        
        XCTAssertEqual(t.matches(string: "B"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "Y"), .match(length: 1))
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testSingleChar_SingleAndRange_isExclusion() {
        let t = OSCAddress.Pattern.Token.SingleChar(
            isExclusion: true,
            groups: [
                .single("a"),
                .asciiRange(start: "b", end: "y")
            ]
        )
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .noMatch)
        XCTAssertEqual(t.matches(string: "b"), .noMatch)
        XCTAssertEqual(t.matches(string: "c"), .noMatch)
        XCTAssertEqual(t.matches(string: "y"), .noMatch)
        XCTAssertEqual(t.matches(string: "z"), .match(length: 1))
        
        XCTAssertEqual(t.matches(string: "ac"), .noMatch)
        XCTAssertEqual(t.matches(string: "bc"), .noMatch)
        XCTAssertEqual(t.matches(string: "cc"), .noMatch)
        XCTAssertEqual(t.matches(string: "yc"), .noMatch)
        XCTAssertEqual(t.matches(string: "zc"), .match(length: 1))
        
        XCTAssertEqual(t.matches(string: "A"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "B"), .match(length: 1))
        XCTAssertEqual(t.matches(string: "Y"), .match(length: 1))
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testStrings_Empty() {
        let t = OSCAddress.Pattern.Token.Strings(strings: [])
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .match(length: 0))
        XCTAssertEqual(t.matches(string: "a"), .match(length: 0))
        XCTAssertEqual(t.matches(string: "ab"), .match(length: 0))
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testStrings_Single() {
        let t = OSCAddress.Pattern.Token.Strings(strings: ["abc"])
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .noMatch)
        XCTAssertEqual(t.matches(string: "ab"), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 3))
        XCTAssertEqual(t.matches(string: "abcd"), .match(length: 3))
        XCTAssertEqual(t.matches(string: "ABC"), .noMatch)
        
        XCTAssertTrue(t.isExhausted)
    }
    
    func testStrings_Multiple() {
        let t = OSCAddress.Pattern.Token.Strings(strings: ["wxyz", "abc"])
        
        XCTAssertTrue(t.isExhausted)
        
        XCTAssertEqual(t.matches(string: ""), .noMatch)
        XCTAssertEqual(t.matches(string: "a"), .noMatch)
        XCTAssertEqual(t.matches(string: "ab"), .noMatch)
        XCTAssertEqual(t.matches(string: "abc"), .match(length: 3))
        XCTAssertEqual(t.matches(string: "abcd"), .match(length: 3))
        XCTAssertEqual(t.matches(string: "ABC"), .noMatch)
        XCTAssertEqual(t.matches(string: "awxyz"), .noMatch)
        
        XCTAssertTrue(t.isExhausted)
    }
}

#endif
