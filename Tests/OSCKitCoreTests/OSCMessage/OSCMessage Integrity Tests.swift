//
//  OSCMessage Integrity Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCMessage_Integrity_Tests {
    @Test func initAddress() {
        // check that address and path components inits successfully create
        // correct OSCAddressPattern
        
        #expect(
            OSCMessage("/container1/container2")
                .addressPattern.stringValue ==
            "/container1/container2"
        )
        
        #expect(
            OSCMessage(String("/container1/container2"))
                .addressPattern.stringValue ==
            "/container1/container2"
        )
        
        #expect(
            OSCMessage(asciiAddressPattern: ASCIIString("/container1/container2"))
                .addressPattern.stringValue ==
            "/container1/container2"
        )
        
        #expect(
            OSCMessage(OSCAddressPattern("/container1/container2"))
                .addressPattern.stringValue ==
            "/container1/container2"
        )
        
        #expect(
            OSCMessage(addressPattern: ["container1", "container2"])
                .addressPattern.stringValue ==
            "/container1/container2"
        )
        
        #expect(
            OSCMessage(asciiAddressPattern: [ASCIIString("container1"), ASCIIString("container2")])
                .addressPattern.stringValue ==
            "/container1/container2"
        )
        
        #expect(
            OSCMessage(addressPattern: [String]())
                .addressPattern.stringValue ==
            "/"
        )
    }
    
    @Test func constructors() async throws {
        // this does not necessarily prove that encoding or decoding actually matches OSC spec, it
        // simply ensures that a message that OSCMessage generates can also be decoded
        
        // encode
        
        let msg = try OSCMessage(
            "/test",
            values: [
                Int32(123),
                Float32(123.45),
                String("A test string."),
                Data([0, 1, 2])
            ]
        )
        .rawData()
        
        // decode
        
        let decoded = try OSCMessage(from: msg)
        
        // just for debug log analysis, if needed
        
        print("Address:", decoded.addressPattern.stringValue.quoted)
        print("Values:", decoded.values)
        
        print("All values decoded:")
        for val in decoded.values {
            switch val {
            case let blob as Data:
                print("blob bytes:", blob.hexStringArrayLiteral())
            default:
                print(val)
            }
        }
        
        // check values
        
        #expect(decoded.values.count == 4)
        
        let val1 = try #require(decoded.values[0] as? Int32)
        #expect(val1 == 123)
        
        let val2 = try #require(decoded.values[1] as? Float32)
        #expect(val2 == 123.45)
        
        let val3 = try #require(decoded.values[2] as? String)
        #expect(val3 == "A test string.")
        
        let val4 = try #require(decoded.values[3] as? Data)
        #expect(val4 == Data([0, 1, 2]))
    }
}
