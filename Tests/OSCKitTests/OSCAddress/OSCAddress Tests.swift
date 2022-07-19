//
//  OSCAddress Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if !os(watchOS)

import XCTest
import OSCKit

final class OSCAddressTests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit() {
        
        let addr1 = OSCAddress("/address")
        XCTAssertEqual(addr1.stringValue, "/address")
        
        let addr2 = OSCAddress(ASCIIString("/address"))
        XCTAssertEqual(addr2.stringValue, "/address")
        
        let addr3 = OSCAddress(pathComponents: ["path1", "path2"])
        XCTAssertEqual(addr3.stringValue, "/path1/path2")
        
        let addr4 = OSCAddress(pathComponents: [ASCIIString("path1"), ASCIIString("path2")])
        XCTAssertEqual(addr4.stringValue, "/path1/path2")
        
    }
    
    func testPathComponents() {
        
        // empty address
        XCTAssertEqual(OSCAddress("").pathComponents,
                       nil)
        
        // empty address
        XCTAssertEqual(OSCAddress(" ").pathComponents,
                       nil)
        
        // undefined / invalid
        XCTAssertEqual(OSCAddress("/").pathComponents,
                       nil)
        
        // undefined / invalid
        XCTAssertEqual(OSCAddress("//").pathComponents,
                       nil)
        
        // valid
        XCTAssertEqual(OSCAddress("/methodname").pathComponents,
                       ["methodname"])
        
        // invalid
        XCTAssertEqual(OSCAddress("/path1/").pathComponents,
                       nil)
        
        // invalid
        XCTAssertEqual(OSCAddress("/path1//").pathComponents,
                       nil)
        
        // valid
        XCTAssertEqual(OSCAddress("//methodname").pathComponents,
                       ["", "methodname"])
        
        // valid
        XCTAssertEqual(OSCAddress("/path1/path2/methodname").pathComponents,
                       ["path1", "path2", "methodname"])
        
        // valid
        XCTAssertEqual(OSCAddress("/path?/path2/methodname").pathComponents,
                       ["path?", "path2", "methodname"])
        
        // valid
        XCTAssertEqual(OSCAddress("/path*/path2/methodname").pathComponents,
                       ["path*", "path2", "methodname"])
        
        // valid
        XCTAssertEqual(OSCAddress("/path1//methodname").pathComponents,
                       ["path1", "", "methodname"])
        
    }
    
}

#endif
