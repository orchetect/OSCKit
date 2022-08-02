//
//  OSCAddress Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCAddress_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit() {
        let addr1 = OSCAddress("/methodname")
        XCTAssertEqual(addr1.stringValue, "/methodname")
        
        let addr2 = OSCAddress(ASCIIString("/methodname"))
        XCTAssertEqual(addr2.stringValue, "/methodname")
        
        let addr3 = OSCAddress(pathComponents: ["container1", "methodname"])
        XCTAssertEqual(addr3.stringValue, "/container1/methodname")
        
        let addr4 =
            OSCAddress(pathComponents: [ASCIIString("container1"), ASCIIString("methodname")])
        XCTAssertEqual(addr4.stringValue, "/container1/methodname")
    }
    
    func testCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let str = OSCAddress("/test/address")
        
        let encoded = try encoder.encode(str)
        let decoded = try decoder.decode(OSCAddress.self, from: encoded)
        
        XCTAssertEqual(str, decoded)
    }
    
    func testPathComponents() {
        // empty address
        XCTAssertEqual(
            OSCAddress("").pathComponents,
            []
        )
        
        // base methodname of " " -- unconventional, but legal
        XCTAssertEqual(
            OSCAddress(" ").pathComponents,
            [" "]
        )
        
        // undefined / invalid
        XCTAssertEqual(
            OSCAddress("/").pathComponents,
            []
        )
        
        // undefined / invalid
        XCTAssertEqual(
            OSCAddress("//").pathComponents,
            []
        )
        
        // valid
        XCTAssertEqual(
            OSCAddress("/methodname").pathComponents,
            ["methodname"]
        )
        
        // strip trailing /
        XCTAssertEqual(
            OSCAddress("/container1/").pathComponents,
            ["container1"]
        )
        
        // having trailing // is not valid -- basically malformed
        XCTAssertEqual(
            OSCAddress("/container1//").pathComponents,
            ["container1", ""]
        )
        
        // valid
        // In OSC 1.1 Spec, the // character sequence has special meaning
        XCTAssertEqual(
            OSCAddress("//methodname").pathComponents,
            ["", "methodname"]
        )
        
        // valid
        XCTAssertEqual(
            OSCAddress("/container1/container2/methodname").pathComponents,
            ["container1", "container2", "methodname"]
        )
        
        // valid
        XCTAssertEqual(
            OSCAddress("/container?/container2/methodname").pathComponents,
            ["container?", "container2", "methodname"]
        )
        
        // valid
        XCTAssertEqual(
            OSCAddress("/container*/container2/methodname").pathComponents,
            ["container*", "container2", "methodname"]
        )
        
        // valid
        XCTAssertEqual(
            OSCAddress(
                "/container*/container2*abc{X,Y,Z}??[0-9A-F]/methodname*abc{X,Y,Z}??[0-9A-F]"
            )
            .pathComponents,
            ["container*", "container2*abc{X,Y,Z}??[0-9A-F]", "methodname*abc{X,Y,Z}??[0-9A-F]"]
        )
        
        // valid
        // In OSC 1.1 Spec, the // character sequence has special meaning
        XCTAssertEqual(
            OSCAddress("/container1//methodname").pathComponents,
            ["container1", "", "methodname"]
        )
        
        // leading /// is malformed, but possible to parse
        XCTAssertEqual(
            OSCAddress("///methodname").pathComponents,
            ["", "", "methodname"]
        )
    }
    
    func testPatternMatches() {
        // verbatim matches
        
        XCTAssertTrue(
            OSCAddress("/test1/test3/methodA")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddress("/test1/test3/methodA/")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        // wildcard matches
        
        XCTAssertTrue(
            OSCAddress("/test?/test?/method?")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddress("/*/test?/method?")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddress("/test?/*/method?")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddress("/*/*/method?")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        XCTAssertTrue(
            OSCAddress("/*/*/*")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        // wildcard mismatches
        
        XCTAssertFalse(
            OSCAddress("/test?/test?/method?")
                .pattern(matches: "/test1/test3/methodAA")
        )
        
        XCTAssertFalse(
            OSCAddress("/test?/test?")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        // name mismatches
        
        XCTAssertFalse(
            OSCAddress("/test1/test3/methodA")
                .pattern(matches: "/test1/test3/methodB")
        )
        
        XCTAssertFalse(
            OSCAddress("/test1/test3/methodA")
                .pattern(matches: "/test1/test3")
        )
        
        // path component count mismatches
        
        XCTAssertFalse(
            OSCAddress("/test1/test3")
                .pattern(matches: "/test1/test3/methodA")
        )
        
        XCTAssertFalse(
            OSCAddress("/test1")
                .pattern(matches: "/test1/test3/methodA")
        )
    }
}

#endif
