//
//  OSCAddressPattern Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore
import SwiftASCII

final class OSCAddressPattern_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit_String() {
        let addr = OSCAddressPattern("/methodname")
        XCTAssertEqual(addr.stringValue, "/methodname")
    }
    
    func testInit_ASCIIString() {
        let addr = OSCAddressPattern(ascii: ASCIIString("/methodname"))
        XCTAssertEqual(addr.stringValue, "/methodname")
    }
    
    func testInit_PathComponents_String() {
        let addr = OSCAddressPattern(pathComponents: ["container1", "methodname"])
        XCTAssertEqual(addr.stringValue, "/container1/methodname")
    }
    
    func testInit_PathComponents_ASCIIString() {
        let addr =
            OSCAddressPattern(asciiPathComponents: [
                ASCIIString("container1"),
                ASCIIString("methodname")
            ])
        XCTAssertEqual(addr.stringValue, "/container1/methodname")
    }
    
    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let str = OSCAddressPattern("/test/address")
        
        let encoded = try encoder.encode(str)
        let decoded = try decoder.decode(OSCAddressPattern.self, from: encoded)
        
        XCTAssertEqual(str, decoded)
    }
    
    func testPathComponents() {
        // empty address
        XCTAssertEqual(
            OSCAddressPattern("").pathComponents,
            []
        )
        
        // base methodname of " " -- unconventional, but legal
        XCTAssertEqual(
            OSCAddressPattern(" ").pathComponents,
            [" "]
        )
        
        // undefined / invalid
        XCTAssertEqual(
            OSCAddressPattern("/").pathComponents,
            []
        )
        
        // undefined / invalid
        XCTAssertEqual(
            OSCAddressPattern("//").pathComponents,
            []
        )
        
        // valid
        XCTAssertEqual(
            OSCAddressPattern("/methodname").pathComponents,
            ["methodname"]
        )
        
        // strip trailing /
        XCTAssertEqual(
            OSCAddressPattern("/container1/").pathComponents,
            ["container1"]
        )
        
        // having trailing // is not valid -- basically malformed
        XCTAssertEqual(
            OSCAddressPattern("/container1//").pathComponents,
            ["container1", ""]
        )
        
        // valid
        // In OSC 1.1 Spec, the // character sequence has special meaning
        XCTAssertEqual(
            OSCAddressPattern("//methodname").pathComponents,
            ["", "methodname"]
        )
        
        // valid
        XCTAssertEqual(
            OSCAddressPattern("/container1/container2/methodname").pathComponents,
            ["container1", "container2", "methodname"]
        )
        
        // valid
        XCTAssertEqual(
            OSCAddressPattern("/container?/container2/methodname").pathComponents,
            ["container?", "container2", "methodname"]
        )
        
        // valid
        XCTAssertEqual(
            OSCAddressPattern("/container*/container2/methodname").pathComponents,
            ["container*", "container2", "methodname"]
        )
        
        // valid
        XCTAssertEqual(
            OSCAddressPattern(
                "/container*/container2*abc{X,Y,Z}??[0-9A-F]/methodname*abc{X,Y,Z}??[0-9A-F]"
            )
            .pathComponents,
            ["container*", "container2*abc{X,Y,Z}??[0-9A-F]", "methodname*abc{X,Y,Z}??[0-9A-F]"]
        )
        
        // valid
        // In OSC 1.1 Spec, the // character sequence has special meaning
        XCTAssertEqual(
            OSCAddressPattern("/container1//methodname").pathComponents,
            ["container1", "", "methodname"]
        )
        
        // leading /// is malformed, but possible to parse
        XCTAssertEqual(
            OSCAddressPattern("///methodname").pathComponents,
            ["", "", "methodname"]
        )
    }
    
    func testPatternMatches() {
        // verbatim matches
        
        XCTAssertTrue(
            OSCAddressPattern("/test1/test3/methodA")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddressPattern("/test1/test3/methodA/")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        // wildcard matches
        
        XCTAssertTrue(
            OSCAddressPattern("/test?/test?/method?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddressPattern("/*/test?/method?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddressPattern("/test?/*/method?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddressPattern("/*/*/method?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddressPattern("/*/*/*")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        // wildcard mismatches
        
        XCTAssertFalse(
            OSCAddressPattern("/test?/test?/method?")
                .matches(localAddress: "/test1/test3/methodAA")
        )
        
        XCTAssertFalse(
            OSCAddressPattern("/test?/test?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        // name mismatches
        
        XCTAssertFalse(
            OSCAddressPattern("/test1/test3/methodA")
                .matches(localAddress: "/test1/test3/methodB")
        )
        
        XCTAssertFalse(
            OSCAddressPattern("/test1/test3/methodA")
                .matches(localAddress: "/test1/test3")
        )
        
        // path component count mismatches
        
        XCTAssertFalse(
            OSCAddressPattern("/test1/test3")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        XCTAssertFalse(
            OSCAddressPattern("/test1")
                .matches(localAddress: "/test1/test3/methodA")
        )
    }
}

#endif
