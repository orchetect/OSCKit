//
//  OSCAddressPattern Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCAddressPattern_Tests {
    @Test
    func init_String() {
        let addr = OSCAddressPattern("/methodname")
        #expect(addr.stringValue == "/methodname")
    }
    
    @Test
    func init_ASCIIString() {
        let addr = OSCAddressPattern(ascii: ASCIIString("/methodname"))
        #expect(addr.stringValue == "/methodname")
    }
    
    @Test
    func init_PathComponents_String() {
        let addr = OSCAddressPattern(pathComponents: ["container1", "methodname"])
        #expect(addr.stringValue == "/container1/methodname")
    }
    
    @Test
    func init_PathComponents_ASCIIString() {
        let addr =
            OSCAddressPattern(asciiPathComponents: [
                ASCIIString("container1"),
                ASCIIString("methodname")
            ])
        #expect(addr.stringValue == "/container1/methodname")
    }
    
    @Test
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let str = OSCAddressPattern("/test/address")
        
        let encoded = try encoder.encode(str)
        let decoded = try decoder.decode(OSCAddressPattern.self, from: encoded)
        
        #expect(str == decoded)
    }
    
    @Test
    func pathComponents() {
        // empty address
        #expect(
            OSCAddressPattern("").pathComponents ==
                []
        )
        
        // base methodname of " " -- unconventional, but legal
        #expect(
            OSCAddressPattern(" ").pathComponents ==
                [" "]
        )
        
        // undefined / invalid
        #expect(
            OSCAddressPattern("/").pathComponents ==
                []
        )
        
        // undefined / invalid
        #expect(
            OSCAddressPattern("//").pathComponents ==
                []
        )
        
        // valid
        #expect(
            OSCAddressPattern("/methodname").pathComponents ==
                ["methodname"]
        )
        
        // strip trailing /
        #expect(
            OSCAddressPattern("/container1/").pathComponents ==
                ["container1"]
        )
        
        // having trailing // is not valid -- basically malformed
        #expect(
            OSCAddressPattern("/container1//").pathComponents ==
                ["container1", ""]
        )
        
        // valid
        // In OSC 1.1 Spec, the // character sequence has special meaning
        #expect(
            OSCAddressPattern("//methodname").pathComponents ==
                ["", "methodname"]
        )
        
        // valid
        #expect(
            OSCAddressPattern("/container1/container2/methodname").pathComponents ==
                ["container1", "container2", "methodname"]
        )
        
        // valid
        #expect(
            OSCAddressPattern("/container?/container2/methodname").pathComponents ==
                ["container?", "container2", "methodname"]
        )
        
        // valid
        #expect(
            OSCAddressPattern("/container*/container2/methodname").pathComponents ==
                ["container*", "container2", "methodname"]
        )
        
        // valid
        #expect(
            OSCAddressPattern(
                "/container*/container2*abc{X,Y,Z}??[0-9A-F]/methodname*abc{X,Y,Z}??[0-9A-F]"
            )
            .pathComponents ==
            ["container*", "container2*abc{X,Y,Z}??[0-9A-F]", "methodname*abc{X,Y,Z}??[0-9A-F]"]
        )
        
        // valid
        // In OSC 1.1 Spec, the // character sequence has special meaning
        #expect(
            OSCAddressPattern("/container1//methodname").pathComponents ==
                ["container1", "", "methodname"]
        )
        
        // leading /// is malformed, but possible to parse
        #expect(
            OSCAddressPattern("///methodname").pathComponents ==
                ["", "", "methodname"]
        )
    }
    
    @Test
    func patternMatches() {
        // verbatim matches
        
        #expect(
            OSCAddressPattern("/test1/test3/methodA")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        #expect(
            OSCAddressPattern("/test1/test3/methodA/")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        // wildcard matches
        
        #expect(
            OSCAddressPattern("/test?/test?/method?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        #expect(
            OSCAddressPattern("/*/test?/method?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        #expect(
            OSCAddressPattern("/test?/*/method?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        #expect(
            OSCAddressPattern("/*/*/method?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        #expect(
            OSCAddressPattern("/*/*/*")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        // wildcard mismatches
        
        #expect(
            !OSCAddressPattern("/test?/test?/method?")
                .matches(localAddress: "/test1/test3/methodAA")
        )
        
        #expect(
            !OSCAddressPattern("/test?/test?")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        // name mismatches
        
        #expect(
            !OSCAddressPattern("/test1/test3/methodA")
                .matches(localAddress: "/test1/test3/methodB")
        )
        
        #expect(
            !OSCAddressPattern("/test1/test3/methodA")
                .matches(localAddress: "/test1/test3")
        )
        
        // path component count mismatches
        
        #expect(
            !OSCAddressPattern("/test1/test3")
                .matches(localAddress: "/test1/test3/methodA")
        )
        
        #expect(
            !OSCAddressPattern("/test1")
                .matches(localAddress: "/test1/test3/methodA")
        )
    }
}
