//
//  OSCValueToken Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OSCKitCore
import SwiftASCII

final class OSCValueToken_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - [].matches(mask:) Types
    
    // MARK: ... Core types
    
    func testMatchesValueMask_blob() {
        let mask: [OSCValueToken] = [.blob]
        
        // success
        XCTAssertTrue(
            OSCValues([Data([1, 2, 3])])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([
                OSCMIDIValue(
                    portID: 1,
                    status: 2,
                    data1: 3
                )
            ])
            .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Data([1, 2, 3]), Data([1, 2, 3])])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_int32() {
        let mask: [OSCValueToken] = [.int32]
        
        // success
        XCTAssertTrue(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Int32(1), Int32(1)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_float32() {
        let mask: [OSCValueToken] = [.float32]
        
        // success
        XCTAssertTrue(
            OSCValues([Float32(123.45)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Double(123.45)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCTimeTag(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Int32(123.45), Int32(123.45)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_string() {
        let mask: [OSCValueToken] = [.string]
        
        // success
        XCTAssertTrue(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([String("1"), String("1")])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Extended types
    
    func testMatchesValueMask_array() {
        let mask: [OSCValueToken] = [.array]
        
        let array = OSCArrayValue([Int32(1)])
        
        // success - match the fact that it's an array regardless of contents
        XCTAssertTrue(
            OSCValues([array])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([OSCArrayValue([])])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([OSCArrayValue([Int64(1)])])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([array, array])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_bool() {
        let mask: [OSCValueToken] = [.bool]
        
        // success
        XCTAssertTrue(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([true, true])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_character() {
        let mask: [OSCValueToken] = [.character]
        
        // success
        XCTAssertTrue(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Character("1"), Character("1")])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_double() {
        let mask: [OSCValueToken] = [.double]
        
        // success
        XCTAssertTrue(
            OSCValues([Double(123.45)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Float32(123.45)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Double(123.45), Double(123.45)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_int64() {
        let mask: [OSCValueToken] = [.int64]
        
        // success
        XCTAssertTrue(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Int64(1), Int64(1)])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_impulse() {
        let mask: [OSCValueToken] = [.impulse]
        
        // success
        XCTAssertTrue(
            OSCValues([OSCImpulseValue()])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([OSCNullValue()])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([OSCImpulseValue(), OSCImpulseValue()])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_midi() {
        let mask: [OSCValueToken] = [.midi]
        
        let value: AnyOSCValue = OSCMIDIValue(
            portID: 1,
            status: 2,
            data1: 3
        )
        
        // success
        XCTAssertTrue(
            OSCValues([value])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Data([1, 2, 3])])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([value, value])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_null() {
        let mask: [OSCValueToken] = [.null]
        
        // success
        XCTAssertTrue(
            OSCValues([OSCNullValue()])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Int(0)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Int32(0)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Data([0x00])])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([String("\n")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("\n")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Character("\n")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCImpulseValue()])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([false])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([OSCNullValue(), OSCNullValue()])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_stringAlt() {
        let mask: [OSCValueToken] = [.stringAlt]
        
        // success
        XCTAssertTrue(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("1"), OSCStringAltValue("1")])
                .matches(mask: mask)
        )
    }
    
    func testMatchesValueMask_timeTag() {
        let mask: [OSCValueToken] = [.timeTag]
        
        // success
        XCTAssertTrue(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Float32(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Double(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([OSCTimeTag(1), OSCTimeTag(1)])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Opaque types
    
    func testMatchesValueMask_number() {
        let mask: [OSCValueToken] = [.number]
        
        // success
        XCTAssertTrue(
            OSCValues([Int(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([Int8(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([Int16(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([UInt8(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([UInt(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([UInt16(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([Float32(1)])
                .matches(mask: mask)
        )
        XCTAssertTrue(
            OSCValues([Double(1)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        XCTAssertFalse(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        XCTAssertFalse(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Int32(1), Int32(1)])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Interpolated types
    
    func testMatchesValueMask_int() {
        // Int is an interpolated value and therefore should
        // never match against any core OSC types
        
        let value = OSCValues([Int(1)])
        
        // -- core types
        XCTAssertFalse(value.matches(mask: [.blob]))
        XCTAssertFalse(value.matches(mask: [.float32]))
        XCTAssertFalse(value.matches(mask: [.int32]))
        XCTAssertFalse(value.matches(mask: [.string]))
        
        // -- extended types
        XCTAssertFalse(value.matches(mask: [.array]))
        XCTAssertFalse(value.matches(mask: [.bool]))
        XCTAssertFalse(value.matches(mask: [.character]))
        XCTAssertFalse(value.matches(mask: [.double]))
        XCTAssertFalse(value.matches(mask: [.int64]))
        XCTAssertFalse(value.matches(mask: [.impulse]))
        XCTAssertFalse(value.matches(mask: [.midi]))
        XCTAssertFalse(value.matches(mask: [.midi]))
        XCTAssertFalse(value.matches(mask: [.stringAlt]))
        XCTAssertFalse(value.matches(mask: [.timeTag]))
        
        // -- opaque types
        XCTAssertTrue(value.matches(mask: [.number]))
    }
    
    // MARK: - Optional Variants
    // we won't do exhaustive tests on the optional variants;
    // just cover some key functionality since the
    // non-optional tokens should cover most of the basis
    
    // MARK: ... Core types
    
    func testMatchesValueMask_int32Optional() {
        let mask: [OSCValueToken] = [.int32Optional]
        
        // success
        XCTAssertTrue(
            OSCValues([Int32(123)])
                .matches(mask: mask)
        )
        
        // success - value was optional
        XCTAssertTrue(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        XCTAssertFalse(
            OSCValues([Int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Int32(123), Int32(123)])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Extended types
    
    // MARK: ... Opaque types
    
    func testMatchesValueMask_numberOptional() {
        let mask: [OSCValueToken] = [.numberOptional]
        
        // success
        XCTAssertTrue(
            OSCValues([Int32(123)])
                .matches(mask: mask)
        )
        
        // success - value was optional
        XCTAssertTrue(
            OSCValues()
                .matches(mask: mask)
        )
        
        // success
        XCTAssertTrue(
            OSCValues([Int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        XCTAssertFalse(
            OSCValues([Int32(123), Int32(123)])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Interpolated types
    
    func testMatchesValueMask_int_OptionalTokens() {
        // Int is an interpolated value and therefore should
        // never match against any core OSC types
        
        let value = OSCValues([Int(1)])
        
        // -- core types
        XCTAssertFalse(value.matches(mask: [.blobOptional]))
        XCTAssertFalse(value.matches(mask: [.float32Optional]))
        XCTAssertFalse(value.matches(mask: [.int32Optional]))
        XCTAssertFalse(value.matches(mask: [.stringOptional]))
        
        // -- extended types
        XCTAssertFalse(value.matches(mask: [.arrayOptional]))
        XCTAssertFalse(value.matches(mask: [.boolOptional]))
        XCTAssertFalse(value.matches(mask: [.characterOptional]))
        XCTAssertFalse(value.matches(mask: [.doubleOptional]))
        XCTAssertFalse(value.matches(mask: [.int64Optional]))
        XCTAssertFalse(value.matches(mask: [.impulseOptional]))
        XCTAssertFalse(value.matches(mask: [.midiOptional]))
        XCTAssertFalse(value.matches(mask: [.midiOptional]))
        XCTAssertFalse(value.matches(mask: [.stringAltOptional]))
        XCTAssertFalse(value.matches(mask: [.timeTagOptional]))
        
        // -- opaque types
        XCTAssertTrue(value.matches(mask: [.numberOptional]))
    }
}
