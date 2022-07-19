//
//  OSCObject Parse Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit

final class OSCObjectParseTests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Model UDP data receiver pattern
    
    func testParseOSC_Model() {
        
        // (Raw data taken from testOSCMessage_int32() of "OSCMessage Tests.swift")
        
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
        
        func handleOSCPayload(_ oscPayload: OSCPayload) {
            switch oscPayload {
            case .bundle(let bundle):
                // recursively handle nested bundles and messages
                bundle.elements.forEach { handleOSCPayload($0) }
            case .message(let message):
                // handle message
                _ = message
            }
        }
        
        let data = Data(knownGoodOSCRawBytes)
        
        do {
            guard let oscPayload = try data.parseOSC() else {
                XCTFail()
                return
            }
            
            handleOSCPayload(oscPayload)
        } catch let error as OSCBundle.DecodeError {
            // handle bundle errors
            _ = error
            XCTFail()
        } catch let error as OSCMessage.DecodeError {
            // handle message errors
            _ = error
            XCTFail()
        } catch {
            // handle other errors
            XCTFail()
        }
        
    }
    
    
    // MARK: - Variations
    
    func testParseOSC_Message() {
        
        // (Raw data taken from testOSCMessage_int32() of "OSCMessage Tests.swift")
        
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
        
        let data = Data(knownGoodOSCRawBytes)
        
        do {
            guard let oscObject = try data.parseOSC() else {
                XCTFail()
                return
            }
            
            switch oscObject {
            case .message(let message):
                // handle message
                XCTAssertEqual(message.address, "/testaddress")
                XCTAssertEqual(message.values, [.int32(255)])
                
            case .bundle(let bundle):
                // handle bundle
                _ = bundle
                XCTFail()
                
            }
        } catch let error as OSCBundle.DecodeError {
            // handle bundle errors
            _ = error
            XCTFail()
        } catch let error as OSCMessage.DecodeError {
            // handle message errors
            _ = error
            XCTFail()
        } catch {
            // handle other errors
            XCTFail()
        }
        
    }
    
    func testParseOSC_Bundle() {
        
        // (Raw data taken from testOSCBundle_OSCMessage() of "OSCBundle Tests.swift")
        
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
        
        let data = Data(knownGoodOSCRawBytes)
        
        do {
            guard let oscObject = try data.parseOSC() else {
                XCTFail()
                return
            }
            
            switch oscObject {
            case .message(let message):
                // handle message
                _ = message
                XCTFail()
                
            case .bundle(let bundle):
                // handle bundle
                XCTAssertEqual(bundle.timeTag, 1)
                XCTAssertEqual(bundle.elements.count, 1)
                
                guard case .message(let msg) = bundle.elements.first
                else { XCTFail() ; return }
                
                XCTAssertEqual(msg.address, "/testaddress")
                XCTAssertEqual(msg.values.count, 1)
                
                guard case .int32(let val) = msg.values.first
                else { XCTFail() ; return }
                
                XCTAssertEqual(val, 255)
                
            }
        } catch let error as OSCBundle.DecodeError {
            // handle bundle errors
            _ = error
            XCTFail()
        } catch let error as OSCMessage.DecodeError {
            // handle message errors
            _ = error
            XCTFail()
        } catch {
            // handle other errors
            XCTFail()
        }
        
    }
    
    func testParseOSC_Message_Error() {
        
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
        
        let data = Data(knownBadOSCRawBytes)
        
        do {
            guard let oscObject = try data.parseOSC() else {
                XCTFail()
                return
            }
            
            switch oscObject {
            case .message(let message):
                // handle message
                _ = message
                XCTFail()
                
            case .bundle(let bundle):
                // handle bundle
                _ = bundle
                XCTFail()
                
            }
        } catch let error as OSCBundle.DecodeError {
            // handle bundle errors
            _ = error
            XCTFail()
        } catch let error as OSCMessage.DecodeError {
            // handle message errors
            
            switch error {
            case .malformed(let verboseError):
                _ = verboseError
                XCTAssert(true)
            default:
                XCTFail()
            }
        } catch {
            // handle other errors
            XCTFail()
        }
        
    }
    
    func testParseOSC_Bundle_Error() {
        
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
        
        let data = Data(knownGoodOSCRawBytes)
        
        do {
            guard let oscObject = try data.parseOSC() else {
                XCTFail()
                return
            }
            
            switch oscObject {
            case .message(let message):
                // handle message
                _ = message
                XCTFail()
                
            case .bundle(let bundle):
                // handle bundle
                _ = bundle
                XCTFail()
                
            }
        } catch let error as OSCBundle.DecodeError {
            // handle bundle errors
            
            switch error {
            case .malformed(let verboseError):
                _ = verboseError
                XCTAssert(true)
            }
        } catch let error as OSCMessage.DecodeError {
            // handle message errors
            _ = error
            XCTFail()
        } catch {
            // handle other errors
            XCTFail()
        }
        
    }
    
    func testParseOSC_Bundle_ErrorInContainedMessage() {
        
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
        
        let data = Data(knownGoodOSCRawBytes)
        
        do {
            guard let oscObject = try data.parseOSC() else {
                XCTFail()
                return
            }
            
            switch oscObject {
            case .message(let message):
                // handle message
                _ = message
                XCTFail()
                
            case .bundle(let bundle):
                // handle bundle
                _ = bundle
                XCTFail()
                
            }
        } catch let error as OSCBundle.DecodeError {
            // handle bundle errors
            _ = error
            XCTFail()
        } catch let error as OSCMessage.DecodeError {
            // handle message errors
            
            switch error {
            case .malformed(let verboseError):
                _ = verboseError
                XCTAssert(true)
            default:
                XCTFail()
            }
        } catch {
            // handle other errors
            XCTFail()
        }
        
    }
    
}

#endif
