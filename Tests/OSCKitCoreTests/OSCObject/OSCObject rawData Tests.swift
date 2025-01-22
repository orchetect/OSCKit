//
//  OSCObject rawData Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing

@Suite struct OSCObject_rawData_Tests {
    // swiftformat:options --wrapcollections preserve
    
    // MARK: - Model UDP data receiver pattern
    
    @Test
    func parseOSC_Model() async throws {
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
                Issue.record()
            }
        }
        
        let remainingData = Data(knownGoodOSCRawBytes)
        let _oscObject = try remainingData.parseOSC()
        let oscObject = try #require(_oscObject)
        handleOSCObject(oscObject)
    }
    
    // MARK: - Variations
    
    @Test
    func parseOSC_Message() async throws {
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
        
        let _oscObject = try remainingData.parseOSC()
        let oscObject = try #require(_oscObject)
            
        switch oscObject {
        case let message as OSCMessage:
            // handle message
            #expect(message.addressPattern.stringValue == "/testaddress")
            #expect(message.values[0] as? Int32 == Int32(255))
                
        default:
            Issue.record()
        }
    }
    
    @Test
    func parseOSC_Bundle() async throws {
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
        let oscObject = try remainingData.parseOSC()
            
        switch oscObject {
        case let bundle as OSCBundle:
            // handle bundle
            #expect(bundle.timeTag.rawValue == 1)
            #expect(bundle.elements.count == 1)
                
            let msg = try #require(bundle.elements.first as? OSCMessage)
                
            #expect(msg.addressPattern.stringValue == "/testaddress")
            #expect(msg.values.count == 1)
            
            #expect(msg.values[0] as? Int32 == Int32(255))
                
        case let message as OSCMessage:
            // handle message
            _ = message
            Issue.record()
                
        default:
            Issue.record()
        }
    }
    
    @Test
    func parseOSC_Message_Error() async {
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
            _ = try remainingData.parseOSC()
            Issue.record("Should throw an error.")
        } catch _ as OSCDecodeError {
            // handle decode errors
            // ✅
        } catch {
            // handle other errors
            Issue.record("Wrong error thrown.")
        }
    }
    
    @Test
    func parseOSC_Bundle_Error() async {
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
            _ = try remainingData.parseOSC()
            Issue.record("Should throw an error.")
        } catch _ as OSCDecodeError {
            // handle decode errors
            // ✅
        } catch {
            // handle other errors
            Issue.record("Wrong error thrown.")
        }
    }
    
    @Test
    func parseOSC_Bundle_ErrorInContainedMessage() async {
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
            _ = try remainingData.parseOSC()
            Issue.record("Should throw an error.")
        } catch _ as OSCDecodeError {
            // handle decode errors
            // ✅
        } catch {
            // handle other errors
            Issue.record("Wrong error thrown.")
        }
    }
}
