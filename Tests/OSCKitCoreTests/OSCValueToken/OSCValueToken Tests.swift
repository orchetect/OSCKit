//
//  OSCValueToken Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCValueToken_Tests {
    // MARK: - [].matches(mask:) Types
    
    // MARK: ... Core types
    
    @Test
    func matchesValueMask_blob() {
        let mask: [OSCValueToken] = [.blob]
        
        // success
        #expect(
            OSCValues([Data([1, 2, 3])])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([
                OSCMIDIValue(
                    portID: 1,
                    status: 2,
                    data1: 3
                )
            ])
            .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Data([1, 2, 3]), Data([1, 2, 3])])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_int32() {
        let mask: [OSCValueToken] = [.int32]
        
        // success
        #expect(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([String("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Character("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Int32(1), Int32(1)])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_float32() {
        let mask: [OSCValueToken] = [.float32]
        
        // success
        #expect(
            OSCValues([Float32(123.45)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Double(123.45)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCTimeTag(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Int32(123.45), Int32(123.45)])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_string() {
        let mask: [OSCValueToken] = [.string]
        
        // success
        #expect(
            OSCValues([String("1")])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Character("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([String("1"), String("1")])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Extended types
    
    @Test
    func matchesValueMask_array() {
        let mask: [OSCValueToken] = [.array]
        
        let array = OSCArrayValue([Int32(1)])
        
        // success - match the fact that it's an array regardless of contents
        #expect(
            OSCValues([array])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([OSCArrayValue([])])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([OSCArrayValue([Int64(1)])])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([array, array])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_bool() {
        let mask: [OSCValueToken] = [.bool]
        
        // success
        #expect(
            OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([String("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Character("1")])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([true, true])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_character() {
        let mask: [OSCValueToken] = [.character]
        
        // success
        #expect(
            OSCValues([Character("1")])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([String("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Character("1"), Character("1")])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_double() {
        let mask: [OSCValueToken] = [.double]
        
        // success
        #expect(
            OSCValues([Double(123.45)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Float32(123.45)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Double(123.45), Double(123.45)])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_int64() {
        let mask: [OSCValueToken] = [.int64]
        
        // success
        #expect(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([String("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Character("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Int64(1), Int64(1)])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_impulse() {
        let mask: [OSCValueToken] = [.impulse]
        
        // success
        #expect(
            OSCValues([OSCImpulseValue()])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([OSCNullValue()])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([OSCImpulseValue(), OSCImpulseValue()])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_midi() {
        let mask: [OSCValueToken] = [.midi]
        
        let value: any OSCValue = OSCMIDIValue(
            portID: 1,
            status: 2,
            data1: 3
        )
        
        // success
        #expect(
            OSCValues([value])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Data([1, 2, 3])])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([value, value])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_null() {
        let mask: [OSCValueToken] = [.null]
        
        // success
        #expect(
            OSCValues([OSCNullValue()])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Int(0)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Int32(0)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Data([0x00])])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([String("\n")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCStringAltValue("\n")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Character("\n")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCImpulseValue()])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([false])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([OSCNullValue(), OSCNullValue()])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_stringAlt() {
        let mask: [OSCValueToken] = [.stringAlt]
        
        // success
        #expect(
            OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([String("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Character("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([OSCStringAltValue("1"), OSCStringAltValue("1")])
                .matches(mask: mask)
        )
    }
    
    @Test
    func matchesValueMask_timeTag() {
        let mask: [OSCValueToken] = [.timeTag]
        
        // success
        #expect(
            OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Float32(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Double(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([String("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Character("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([OSCTimeTag(1), OSCTimeTag(1)])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Opaque types
    
    @Test
    func matchesValueMask_number() {
        let mask: [OSCValueToken] = [.number]
        
        // success
        #expect(
            OSCValues([Int(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([Int8(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([Int16(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([Int32(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([Int64(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([UInt8(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([UInt(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([UInt16(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([UInt32(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([UInt64(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([Float32(1)])
                .matches(mask: mask)
        )
        #expect(
            OSCValues([Double(1)])
                .matches(mask: mask)
        )
        
        // fail - empty values array
        #expect(
            !OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([String("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCStringAltValue("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([Character("1")])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([OSCTimeTag(1)])
                .matches(mask: mask)
        )
        #expect(
            !OSCValues([true])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Int32(1), Int32(1)])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Interpolated types
    
    @Test
    func matchesValueMask_int() {
        // Int is an interpolated value and therefore should
        // never match against any core OSC types
        
        let value = OSCValues([Int(1)])
        
        // -- core types
        #expect(!value.matches(mask: [.blob]))
        #expect(!value.matches(mask: [.float32]))
        #expect(!value.matches(mask: [.int32]))
        #expect(!value.matches(mask: [.string]))
        
        // -- extended types
        #expect(!value.matches(mask: [.array]))
        #expect(!value.matches(mask: [.bool]))
        #expect(!value.matches(mask: [.character]))
        #expect(!value.matches(mask: [.double]))
        #expect(!value.matches(mask: [.int64]))
        #expect(!value.matches(mask: [.impulse]))
        #expect(!value.matches(mask: [.midi]))
        #expect(!value.matches(mask: [.midi]))
        #expect(!value.matches(mask: [.stringAlt]))
        #expect(!value.matches(mask: [.timeTag]))
        
        // -- opaque types
        #expect(value.matches(mask: [.number]))
    }
    
    // MARK: - Optional Variants
    // we won't do exhaustive tests on the optional variants;
    // just cover some key functionality since the
    // non-optional tokens should cover most of the basis
    
    // MARK: ... Core types
    
    @Test
    func matchesValueMask_int32Optional() {
        let mask: [OSCValueToken] = [.int32Optional]
        
        // success
        #expect(
            OSCValues([Int32(123)])
                .matches(mask: mask)
        )
        
        // success - value was optional
        #expect(
            OSCValues()
                .matches(mask: mask)
        )
        
        // fail - related (but wrong) type
        #expect(
            !OSCValues([Int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Int32(123), Int32(123)])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Extended types
    
    // MARK: ... Opaque types
    
    @Test
    func matchesValueMask_numberOptional() {
        let mask: [OSCValueToken] = [.numberOptional]
        
        // success
        #expect(
            OSCValues([Int32(123)])
                .matches(mask: mask)
        )
        
        // success - value was optional
        #expect(
            OSCValues()
                .matches(mask: mask)
        )
        
        // success
        #expect(
            OSCValues([Int64(123)])
                .matches(mask: mask)
        )
        
        // fail - matches but too many values
        #expect(
            !OSCValues([Int32(123), Int32(123)])
                .matches(mask: mask)
        )
    }
    
    // MARK: ... Interpolated types
    
    @Test
    func matchesValueMask_int_OptionalTokens() {
        // Int is an interpolated value and therefore should
        // never match against any core OSC types
        
        let value = OSCValues([Int(1)])
        
        // -- core types
        #expect(!value.matches(mask: [.blobOptional]))
        #expect(!value.matches(mask: [.float32Optional]))
        #expect(!value.matches(mask: [.int32Optional]))
        #expect(!value.matches(mask: [.stringOptional]))
        
        // -- extended types
        #expect(!value.matches(mask: [.arrayOptional]))
        #expect(!value.matches(mask: [.boolOptional]))
        #expect(!value.matches(mask: [.characterOptional]))
        #expect(!value.matches(mask: [.doubleOptional]))
        #expect(!value.matches(mask: [.int64Optional]))
        #expect(!value.matches(mask: [.impulseOptional]))
        #expect(!value.matches(mask: [.midiOptional]))
        #expect(!value.matches(mask: [.midiOptional]))
        #expect(!value.matches(mask: [.stringAltOptional]))
        #expect(!value.matches(mask: [.timeTagOptional]))
        
        // -- opaque types
        #expect(value.matches(mask: [.numberOptional]))
    }
}
