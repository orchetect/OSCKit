//
//  OSCAddress Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit

final class OSCAddressTests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInit() {
        
        let addr1 = OSCAddress("/methodname")
        XCTAssertEqual(addr1.stringValue, "/methodname")
        
        let addr2 = OSCAddress(ASCIIString("/methodname"))
        XCTAssertEqual(addr2.stringValue, "/methodname")
        
        let addr3 = OSCAddress(pathComponents: ["container1", "methodname"])
        XCTAssertEqual(addr3.stringValue, "/container1/methodname")
        
        let addr4 = OSCAddress(pathComponents: [ASCIIString("container1"), ASCIIString("methodname")])
        XCTAssertEqual(addr4.stringValue, "/container1/methodname")
        
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
        XCTAssertEqual(OSCAddress("/container1/").pathComponents,
                       nil)
        
        // invalid
        XCTAssertEqual(OSCAddress("/container1//").pathComponents,
                       nil)
        
        // valid
        // In OSC 1.1 Spec, the // character sequence has special meaning
        XCTAssertEqual(OSCAddress("//methodname").pathComponents,
                       ["", "methodname"])
        
        // valid
        XCTAssertEqual(OSCAddress("/container1/container2/methodname").pathComponents,
                       ["container1", "container2", "methodname"])
        
        // valid
        XCTAssertEqual(OSCAddress("/container?/container2/methodname").pathComponents,
                       ["container?", "container2", "methodname"])
        
        // valid
        XCTAssertEqual(OSCAddress("/container*/container2/methodname").pathComponents,
                       ["container*", "container2", "methodname"])
        
        // valid
        // In OSC 1.1 Spec, the // character sequence has special meaning
        XCTAssertEqual(OSCAddress("/container1//methodname").pathComponents,
                       ["container1", "", "methodname"])
        
    }
    
}

#endif
