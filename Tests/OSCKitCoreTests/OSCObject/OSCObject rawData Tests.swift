//
//  OSCObject rawData Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import XCTest

final class OSCObject_rawData_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Model UDP data receiver pattern
    
    func testParseOSC_Model() async throws {
        // (Raw data taken from testInt32() of "OSCMessage rawData Tests.swift")
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x69, 0x00, 0x00] // ",i" null null
        // int32
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // parse block
        
        func handleOSCObject(_ oscObject: any OSCObject) {
            switch oscObject {
            case let message as OSCMessage:
                // handle message
                _ = message
            default:
                XCTFail()
            }
        }
        
        let remainingData = Data(knownGoodOSCRawBytes)
        let _oscObject = try await remainingData.parseOSC()
        let oscObject = try XCTUnwrap(_oscObject)
        handleOSCObject(oscObject)
    }
    
    // MARK: - Variations
    
    func testParseOSC_Message() async throws {
        // (Raw data taken from testInt32() of "OSCMessage rawData Tests.swift")
        
        // manually build a raw OSC message
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00, 0x00] // null null null null
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x69, 0x00, 0x00] // ",i" null null
        // int32
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // parse block
        
        let remainingData = Data(knownGoodOSCRawBytes)
        
        let _oscObject = try await remainingData.parseOSC()
        let oscObject = try XCTUnwrap(_oscObject)
            
        switch oscObject {
        case let message as OSCMessage:
            // handle message
            XCTAssertEqual(message.addressPattern.stringValue, "/testaddress")
            XCTAssertEqual(message.values[0] as? Int32, Int32(255))
                
        default:
            XCTFail()
        }
    }
    
    func testParseOSC_Bundle() async throws {
        // (Raw data taken from testSingleOSCMessage() of "OSCBundle rawData Tests.swift")
        
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
        
        // parse block
        
        let remainingData = Data(knownGoodOSCRawBytes)
        let oscObject = try await remainingData.parseOSC()
            
        switch oscObject {
        case let bundle as OSCBundle:
            // handle bundle
            XCTAssertEqual(bundle.timeTag.rawValue, 1)
            XCTAssertEqual(bundle.elements.count, 1)
                
            let msg = try XCTUnwrap(bundle.elements.first as? OSCMessage)
                
            XCTAssertEqual(msg.addressPattern.stringValue, "/testaddress")
            XCTAssertEqual(msg.values.count, 1)
            
            XCTAssertEqual(msg.values[0] as? Int32, Int32(255))
                
        case let message as OSCMessage:
            // handle message
            _ = message
            XCTFail()
                
        default:
            XCTFail()
        }
    }
    
    func testParseOSC_Message_Error() async {
        // manually build a MALFORMED raw OSC message
        
        var knownBadOSCRawBytes: [UInt8] = []
        
        // address
        knownBadOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                0x74, 0x61, 0x64, 0x64,
                                0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                0x00, 0x00, 0x00] // null null null - PURPOSELY WRONG
        // value type(s)
        knownBadOSCRawBytes += [0x2C, 0x69, 0x00, 0x00] // ",i" null null
        // int32
        knownBadOSCRawBytes += [0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // parse block
        
        let remainingData = Data(knownBadOSCRawBytes)
        
        do {
            _ = try await remainingData.parseOSC()
            XCTFail("Should throw an error.")
        } catch _ as OSCDecodeError {
            // handle decode errors
            XCTAssert(true)
        } catch {
            // handle other errors
            XCTFail("Wrong error thrown.")
        }
    }
    
    func testParseOSC_Bundle_Error() async {
        // manually build a MALFORMED raw OSC bundle
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // #bundle header
        knownGoodOSCRawBytes += [0x23, 0x62, 0x75, 0x6E, // "#bun"
                                 0x64, 0x6C, 0x65] // "dle" null - PURPOSELY WRONG
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
        
        // parse block
        
        let remainingData = Data(knownGoodOSCRawBytes)
        
        do {
            _ = try await remainingData.parseOSC()
            XCTFail("Should throw an error.")
        } catch _ as OSCDecodeError {
            // handle decode errors
            XCTAssert(true)
        } catch {
            // handle other errors
            XCTFail("Wrong error thrown.")
        }
    }
    
    func testParseOSC_Bundle_ErrorInContainedMessage() async {
        // manually build a MALFORMED raw OSC bundle
        
        var knownGoodOSCRawBytes: [UInt8] = []
        
        // #bundle header
        knownGoodOSCRawBytes += [0x23, 0x62, 0x75, 0x6E, // "#bun"
                                 0x64, 0x6C, 0x65, 0x00] // "dle" null
        // timetag
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x01] // 1, int64 big-endian
        // size of first bundle element
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0x17] // 23, int32 big-endian
        
        // first bundle element: OSC Message
        
        // address
        knownGoodOSCRawBytes += [0x2F, 0x74, 0x65, 0x73,
                                 0x74, 0x61, 0x64, 0x64,
                                 0x72, 0x65, 0x73, 0x73, // "/testaddress"
                                 0x00, 0x00, 0x00] // null null null - PURPOSELY WRONG
        // value type(s)
        knownGoodOSCRawBytes += [0x2C, 0x69, 0x00, 0x00] // ",i" null null
        // int32
        knownGoodOSCRawBytes += [0x00, 0x00, 0x00, 0xFF] // 255, big-endian
        
        // parse block
        
        let remainingData = Data(knownGoodOSCRawBytes)
        
        do {
            _ = try await remainingData.parseOSC()
            XCTFail("Should throw an error.")
        } catch _ as OSCDecodeError {
            // handle decode errors
            XCTAssert(true)
        } catch {
            // handle other errors
            XCTFail("Wrong error thrown.")
        }
    }
}
