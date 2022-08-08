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
        let mask: [OSCValueMask.Token] = [.int32]
        
        // success
        XCTAssertTrue(
            [OSCValue]([.int32(123)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            [OSCValue]()
                .matches(mask: mask)
        )
        
        // fail - wrong type
        XCTAssertFalse(
            [OSCValue]([.int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            [OSCValue]([.int32(123), .int32(123)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask2() {
        let mask: [OSCValueMask.Token] = [.int32Optional]
        
        // success
        XCTAssertTrue(
            [OSCValue]([.int32(123)])
                .matches(mask: mask)
        )
        
        // success - value was optional
        XCTAssertTrue(
            [OSCValue]()
                .matches(mask: mask)
        )
        
        // fail - wrong type
        XCTAssertFalse(
            [OSCValue]([.int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            [OSCValue]([.int32(123), .int32(123)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask3() {
        let mask: [OSCValueMask.Token] = [.number]
        
        // success
        XCTAssertTrue(
            [OSCValue]([.int32(123)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            [OSCValue]()
                .matches(mask: mask)
        )
        
        // success
        XCTAssertTrue(
            [OSCValue]([.int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            [OSCValue]([.int32(123), .int32(123)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask4() {
        let mask: [OSCValueMask.Token] = [.numberOptional]
        
        // success
        XCTAssertTrue(
            [OSCValue]([.int32(123)])
                .matches(mask: mask)
        )
        
        // success - value was optional
        XCTAssertTrue(
            [OSCValue]()
                .matches(mask: mask)
        )
        
        // success
        XCTAssertTrue(
            [OSCValue]([.int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            [OSCValue]([.int32(123), .int32(123)])
                .matches(mask: mask)
        )
    }
    
    // MARK: - [].matches(mask:) Types
    
    // MARK: ... Core types
    
    func testValuesFromValueMask_int32() throws {
        typealias type                     = Int32
        let value                          = 123 as type
        let msgValue:  OSCValue    = .int32(value)
        let valueType: OSCValueMask.Token = .int32
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_float32() throws {
        typealias type                     = Float32
        let value                          = 123.45 as type
        let msgValue:  OSCValue    = .float32(value)
        let valueType: OSCValueMask.Token = .float32
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_string() throws {
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCValue    = .string(value)
        let valueType: OSCValueMask.Token = .string
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_blob() throws {
        typealias type                     = Data
        let value                          = Data([1, 2, 3]) as type
        let msgValue:  OSCValue    = .blob(value)
        let valueType: OSCValueMask.Token = .blob
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    // MARK: ... Extended types
    
    func testValuesFromValueMask_int64() throws {
        typealias type                     = Int64
        let value                          = 123 as type
        let msgValue:  OSCValue    = .int64(value)
        let valueType: OSCValueMask.Token = .int64
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_timeTag() throws {
        typealias type                     = OSCTimeTag
        let value                          = .init(123) as type
        let msgValue:  OSCValue    = .timeTag(value)
        let valueType: OSCValueMask.Token = .timeTag
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_double() throws {
        typealias type                     = Double
        let value                          = 123.45 as type
        let msgValue:  OSCValue    = .double(value)
        let valueType: OSCValueMask.Token = .double
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_stringAlt() throws {
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCValue    = .stringAlt(value)
        let valueType: OSCValueMask.Token = .stringAlt
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_character() throws {
        typealias type                     = ASCIICharacter
        let value                          = "A" as type
        let msgValue:  OSCValue    = .character(value)
        let valueType: OSCValueMask.Token = .character
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_midi() throws {
        typealias type                     = OSCValue.MIDIMessage
        let value = OSCValue.MIDIMessage(
            portID: 0x00, status: 0x80, data1: 0x50, data2: 0x40
        ) as type
        let msgValue:  OSCValue    = .midi(value)
        let valueType: OSCValueMask.Token = .midi
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_bool() throws {
        typealias type                     = Bool
        let value                          = true as type
        let msgValue:  OSCValue    = .bool(value)
        let valueType: OSCValueMask.Token = .bool
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
    
    func testValuesFromValueMask_null() throws {
        typealias type                     = NSObject
        let value                          = NSNull() as type
        let msgValue:  OSCValue    = .null
        let valueType: OSCValueMask.Token = .null
        
        let result = try [OSCValue]([msgValue])
            .masked([valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
    }
}

#endif
