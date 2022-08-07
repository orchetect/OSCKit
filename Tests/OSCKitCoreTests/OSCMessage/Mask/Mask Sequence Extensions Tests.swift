//
//  Mask Sequence Extensions Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import OTCore
import SwiftASCII

final class OSCMessage_Value_Mask_SequenceExtensions_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - [].matches(mask:)
    
    func testMatchesValueMask1() {
        let mask: [OSCMessage.Value.Mask.Token] = [.int32]
        
        // success
        XCTAssertTrue(
            [OSCMessage.Value]([.int32(123)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            [OSCMessage.Value]()
                .matches(mask: mask)
        )
        
        // fail - wrong type
        XCTAssertFalse(
            [OSCMessage.Value]([.int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            [OSCMessage.Value]([.int32(123), .int32(123)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask2() {
        let mask: [OSCMessage.Value.Mask.Token] = [.int32Optional]
        
        // success
        XCTAssertTrue(
            [OSCMessage.Value]([.int32(123)])
                .matches(mask: mask)
        )
        
        // success - value was optional
        XCTAssertTrue(
            [OSCMessage.Value]()
                .matches(mask: mask)
        )
        
        // fail - wrong type
        XCTAssertFalse(
            [OSCMessage.Value]([.int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            [OSCMessage.Value]([.int32(123), .int32(123)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask3() {
        let mask: [OSCMessage.Value.Mask.Token] = [.number]
        
        // success
        XCTAssertTrue(
            [OSCMessage.Value]([.int32(123)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            [OSCMessage.Value]()
                .matches(mask: mask)
        )
        
        // success
        XCTAssertTrue(
            [OSCMessage.Value]([.int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            [OSCMessage.Value]([.int32(123), .int32(123)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask4() {
        let mask: [OSCMessage.Value.Mask.Token] = [.numberOptional]
        
        // success
        XCTAssertTrue(
            [OSCMessage.Value]([.int32(123)])
                .matches(mask: mask)
        )
        
        // success - value was optional
        XCTAssertTrue(
            [OSCMessage.Value]()
                .matches(mask: mask)
        )
        
        // success
        XCTAssertTrue(
            [OSCMessage.Value]([.int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            [OSCMessage.Value]([.int32(123), .int32(123)])
                .matches(mask: mask)
        )
    }
    
    // MARK: - [].matches(mask:) Types
    
    // MARK: ... Core types
    
    func testValuesFromValueMask_int32() throws {
        typealias type                     = Int32
        let value                          = 123 as type
        let msgValue:  OSCMessage.Value    = .int32(value)
        let valueType: OSCMessage.Value.Mask.Token = .int32
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_float32() throws {
        typealias type                     = Float32
        let value                          = 123.45 as type
        let msgValue:  OSCMessage.Value    = .float32(value)
        let valueType: OSCMessage.Value.Mask.Token = .float32
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_string() throws {
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCMessage.Value    = .string(value)
        let valueType: OSCMessage.Value.Mask.Token = .string
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_blob() throws {
        typealias type                     = Data
        let value                          = Data([1, 2, 3]) as type
        let msgValue:  OSCMessage.Value    = .blob(value)
        let valueType: OSCMessage.Value.Mask.Token = .blob
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    // MARK: ... Extended types
    
    func testValuesFromValueMask_int64() throws {
        typealias type                     = Int64
        let value                          = 123 as type
        let msgValue:  OSCMessage.Value    = .int64(value)
        let valueType: OSCMessage.Value.Mask.Token = .int64
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_timeTag() throws {
        typealias type                     = OSCTimeTag
        let value                          = .init(123) as type
        let msgValue:  OSCMessage.Value    = .timeTag(value)
        let valueType: OSCMessage.Value.Mask.Token = .timeTag
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_double() throws {
        typealias type                     = Double
        let value                          = 123.45 as type
        let msgValue:  OSCMessage.Value    = .double(value)
        let valueType: OSCMessage.Value.Mask.Token = .double
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_stringAlt() throws {
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCMessage.Value    = .stringAlt(value)
        let valueType: OSCMessage.Value.Mask.Token = .stringAlt
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_character() throws {
        typealias type                     = ASCIICharacter
        let value                          = "A" as type
        let msgValue:  OSCMessage.Value    = .character(value)
        let valueType: OSCMessage.Value.Mask.Token = .character
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_midi() throws {
        typealias type                     = OSCMessage.Value.MIDIMessage
        let value = OSCMessage.Value.MIDIMessage(
            portID: 0x00, status: 0x80, data1: 0x50, data2: 0x40
        ) as type
        let msgValue:  OSCMessage.Value    = .midi(value)
        let valueType: OSCMessage.Value.Mask.Token = .midi
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_bool() throws {
        typealias type                     = Bool
        let value                          = true as type
        let msgValue:  OSCMessage.Value    = .bool(value)
        let valueType: OSCMessage.Value.Mask.Token = .bool
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_null() throws {
        typealias type                     = NSObject
        let value                          = NSNull() as type
        let msgValue:  OSCMessage.Value    = .null
        let valueType: OSCMessage.Value.Mask.Token = .null
        
        let result = try [OSCMessage.Value]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
}

#endif
