//
//  ValueMask Sequence Extensions Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit
import OTCore
import SwiftASCII

final class OSCMessage_ValueMask_SequenceExtensions_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - [].matches(mask:)
    
    func testMatchesValueMask1() {
        
        let mask: [OSCMessage.ValueMask.Token] = [.int32]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
            .matches(mask: mask))
        
        // fail - empty values array
        XCTAssertFalse([OSCMessageValue]()
            .matches(mask: mask))
        
        // fail - wrong type
        XCTAssertFalse([OSCMessageValue]([.int64(123)])
            .matches(mask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
            .matches(mask: mask))
        
    }
    
    func testMatchesValueMask2() {
        
        let mask: [OSCMessage.ValueMask.Token] = [.int32Optional]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
            .matches(mask: mask))
        
        // success - value was optional
        XCTAssertTrue([OSCMessageValue]()
            .matches(mask: mask))
        
        // fail - wrong type
        XCTAssertFalse([OSCMessageValue]([.int64(123)])
            .matches(mask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
            .matches(mask: mask))
        
    }
    
    func testMatchesValueMask3() {
        
        let mask: [OSCMessage.ValueMask.Token] = [.number]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
            .matches(mask: mask))
        
        // fail - empty values array
        XCTAssertFalse([OSCMessageValue]()
            .matches(mask: mask))
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int64(123)])
            .matches(mask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
            .matches(mask: mask))
        
    }
    
    func testMatchesValueMask4() {
        
        let mask: [OSCMessage.ValueMask.Token] = [.numberOptional]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
            .matches(mask: mask))
        
        // success - value was optional
        XCTAssertTrue([OSCMessageValue]()
            .matches(mask: mask))
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int64(123)])
            .matches(mask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
            .matches(mask: mask))
        
    }
    
    
    // MARK: - [].matches(mask:) Types
    
    // MARK: ... Core types
    
    func testValuesFromValueMask_int32() throws {
        
        typealias type                     = Int32
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .int32(value)
        let valueType: OSCMessage.ValueMask.Token = .int32
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_float32() throws {
        
        typealias type                     = Float32
        let value                          = 123.45 as type
        let msgValue:  OSCMessageValue     = .float32(value)
        let valueType: OSCMessage.ValueMask.Token = .float32
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_string() throws {
        
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCMessageValue     = .string(value)
        let valueType: OSCMessage.ValueMask.Token = .string
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_blob() throws {
        
        typealias type                     = Data
        let value                          = Data([1,2,3]) as type
        let msgValue:  OSCMessageValue     = .blob(value)
        let valueType: OSCMessage.ValueMask.Token = .blob
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    // MARK: ... Extended types
    
    func testValuesFromValueMask_int64() throws {
        
        typealias type                     = Int64
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .int64(value)
        let valueType: OSCMessage.ValueMask.Token = .int64
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_timeTag() throws {
        
        typealias type                     = Int64
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .timeTag(value)
        let valueType: OSCMessage.ValueMask.Token = .timeTag
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_double() throws {
        
        typealias type                     = Double
        let value                          = 123.45 as type
        let msgValue:  OSCMessageValue     = .double(value)
        let valueType: OSCMessage.ValueMask.Token = .double
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_stringAlt() throws {
        
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCMessageValue     = .stringAlt(value)
        let valueType: OSCMessage.ValueMask.Token = .stringAlt
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_character() throws {
        
        typealias type                     = ASCIICharacter
        let value                          = "A" as type
        let msgValue:  OSCMessageValue     = .character(value)
        let valueType: OSCMessage.ValueMask.Token = .character
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_midi() throws {
        
        typealias type                     = OSCMessageValue.MIDIMessage
        let value = OSCMessageValue.MIDIMessage(
            portID: 0x00, status: 0x80, data1: 0x50, data2: 0x40
        ) as type
        let msgValue:  OSCMessageValue     = .midi(value)
        let valueType: OSCMessage.ValueMask.Token = .midi
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_bool() throws {
        
        typealias type                     = Bool
        let value                          = true as type
        let msgValue:  OSCMessageValue     = .bool(value)
        let valueType: OSCMessage.ValueMask.Token = .bool
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_null() throws {
        
        typealias type                     = NSObject
        let value                          = NSNull() as type
        let msgValue:  OSCMessageValue     = .null
        let valueType: OSCMessage.ValueMask.Token = .null
        
        let result = try [OSCMessageValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
}

#endif
