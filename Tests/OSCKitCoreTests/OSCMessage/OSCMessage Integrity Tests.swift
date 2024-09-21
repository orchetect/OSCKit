//
//  OSCMessage Integrity Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import XCTest
@testable import OSCKitCore
import SwiftASCII

final class OSCMessage_Integrity_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInitAddress() {
        // check that address and path components inits successfully create
        // correct OSCAddressPattern
        
        XCTAssertEqual(
            OSCMessage("/container1/container2").addressPattern.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(String("/container1/container2")).addressPattern.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(asciiAddressPattern: ASCIIString("/container1/container2")).addressPattern
                .stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(OSCAddressPattern("/container1/container2")).addressPattern.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(addressPattern: ["container1", "container2"]).addressPattern.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(asciiAddressPattern: [ASCIIString("container1"), ASCIIString("container2")])
                .addressPattern
                .stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(addressPattern: [String]()).addressPattern.stringValue,
            "/"
        )
    }
    
    func testConstructors() throws {
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
        decoded.values.forEach { val in
            switch val {
            case let blob as Data:
                print("blob bytes:", blob.hexStringArrayLiteral())
            default:
                print(val)
            }
        }
        
        // check values
        
        XCTAssertEqual(decoded.values.count, 4)
        
        let val1 = try XCTUnwrap(decoded.values[0] as? Int32)
        XCTAssertEqual(val1, 123)
        
        let val2 = try XCTUnwrap(decoded.values[1] as? Float32)
        XCTAssertEqual(val2, 123.45)
        
        let val3 = try XCTUnwrap(decoded.values[2] as? String)
        XCTAssertEqual(val3, "A test string.")
        
        let val4 = try XCTUnwrap(decoded.values[3] as? Data)
        XCTAssertEqual(val4, Data([0, 1, 2]))
    }
}
