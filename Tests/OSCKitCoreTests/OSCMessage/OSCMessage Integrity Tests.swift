//
//  OSCMessage Integrity Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import SwiftRadix
import SwiftASCII

final class OSCMessage_Integrity_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testInitAddress() {
        // check that address and path components inits successfully create
        // correct OSCAddress
        
        XCTAssertEqual(
            OSCMessage(address: "/container1/container2").address.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(address: String("/container1/container2")).address.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(address: ASCIIString("/container1/container2")).address.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(address: OSCAddress("/container1/container2")).address.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(address: ["container1", "container2"]).address.stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(address: [ASCIIString("container1"), ASCIIString("container2")]).address
                .stringValue,
            "/container1/container2"
        )
        
        XCTAssertEqual(
            OSCMessage(address: []).address.stringValue,
            "/"
        )
    }
    
    func testConstructors() throws {
        // this does not necessarily prove that encoding or decoding actually matches OSC spec, it simply ensures that a message that OSCMessage generates can also be decoded
        
        // encode
        
        let msg = OSCMessage(
            address: "/test",
            values: [
                .int32(123),
                .float32(123.45),
                .string("A test string."),
                .blob(Data([0, 1, 2]))
            ]
        )
        .rawData
        
        // decode
        
        let decoded = try OSCMessage(from: msg)
        
        // just for debug log analysis, if needed
        
        print("Address:", decoded.address.stringValue.quoted)
        print("Values:", decoded.values.mapDebugString())
        
        print("All values decoded:")
        decoded.values.forEach { val in
            switch val {
            case let .blob(remainingData):
                print("blob bytes:", remainingData.hex.stringValueArrayLiteral)
            default:
                print(val)
            }
        }
        
        // check values
        
        XCTAssertEqual(decoded.values.count, 4)
        
        guard case let .int32(val1) = decoded.values[safe: 0] else { XCTFail(); return }
        XCTAssertEqual(val1, 123)
        
        guard case let .float32(val2) = decoded.values[safe: 1] else { XCTFail(); return }
        XCTAssertEqual(val2, 123.45)
        
        guard case let .string(val3) = decoded.values[safe: 2] else { XCTFail(); return }
        XCTAssertEqual(val3, "A test string.")
        
        guard case let .blob(val4) = decoded.values[safe: 3] else { XCTFail(); return }
        XCTAssertEqual(val4, Data([0, 1, 2]))
    }
}

#endif
