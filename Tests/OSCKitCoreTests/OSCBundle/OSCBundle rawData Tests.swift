//
//  OSCBundle rawData Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

// swiftformat:disable all
final class OSCBundle_rawData_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testEmpty() {
        // tests an empty OSC bundle
        
        // manually build a raw OSC bundle
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // #bundle header
        knownGoodOSCRawBytes += [0x23, 0x62, 0x75, 0x6E, // "#bun"
                                 0x64, 0x6C, 0x65, 0x00] // "dle" null
        // timetag
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x01] // 1, int64 big-endian
        
        // decode
        
        let bundle = try! OSCBundle(from: knownGoodOSCRawBytes.remainingData)
        
        XCTAssertEqual(bundle.timeTag.rawValue, 1)
        XCTAssertEqual(bundle.elements.count, 0)
        
        // re-encode
        
        XCTAssertEqual(bundle.rawData, knownGoodOSCRawBytes.remainingData)
    }
    
    func testSingleOSCMessage() {
        // tests an OSC bundle, with one message containing an int32 value
        
        // manually build a raw OSC bundle
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // #bundle header
        knownGoodOSCRawBytes += [0x23, 0x62, 0x75, 0x6E, // "#bun"
                                 0x64, 0x6C, 0x65, 0x00] // "dle" null
        // timetag
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x01] // 1, int64 big-endian
        // size of first bundle element
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x18] // 24, int32 big-endian
        
        // first bundle element: OSC Message
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x69, 0x00, 0x00] // ",i" null null
        // int32
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // decode
        
        let bundle = try! OSCBundle(from: knownGoodOSCRawBytes.remainingData)
        
        XCTAssertEqual(bundle.timeTag.rawValue, 1)
        XCTAssertEqual(bundle.elements.count, 1)
        
        guard case .message(let msg) = bundle.elements.first else { XCTFail() ; return }
        XCTAssertEqual(msg.address, "/testaddress")
        XCTAssertEqual(msg.values.count, 1)
        guard case .int32(let val) = msg.values.first else { XCTFail() ; return }
        XCTAssertEqual(val, 255)
        
        // re-encode
        
        XCTAssertEqual(bundle.rawData, knownGoodOSCRawBytes.remainingData)
    }
}
// swiftformat:enable all

#endif
