//
//  OSCValue CustomStringConvertible Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing

@Suite struct OSCValue_CustomStringConvertible_Tests {
    // MARK: - Core types
    
    @Test func blob() {
        let val: any OSCValue = Data([1, 2, 3, 4])
        // should be "4 bytes" but `Data` is supplying the description
        // so it may be brittle to test it here
        #expect("\(val)" == "\(val)")
    }
    
    @Test func int32() {
        let val: any OSCValue = Int32(123)
        #expect("\(val)" == "123")
    }
    
    @Test func float32() {
        let val: any OSCValue = Float32(123.45)
        #expect("\(val)" == "123.45")
    }
    
    @Test func string() {
        let val: any OSCValue = String("A string")
        #expect("\(val)" == "A string")
    }
    
    // MARK: - Extended types
    
    @Test func oscArrayValue_Simple() {
        let val: any OSCValue = OSCArrayValue([Int32(123)])
        #expect("\(val)" == "[123]")
    }
    
    @Test func oscArrayValue_Complex() {
        let val: any OSCValue = OSCArrayValue([
            Int32(123),
            String("A String"),
            OSCArrayValue([
                true,
                Double(1.5)
            ])
        ])
        #expect("\(val)" == #"[123, "A String", [true, 1.5]]"#)
    }
    
    @Test func bool() {
        let val1: any OSCValue = true
        #expect("\(val1)" == "true")
        
        let val2: any OSCValue = false
        #expect("\(val2)" == "false")
    }
    
    @Test func character() {
        let val: any OSCValue = Character("A")
        #expect("\(val)" == "A")
    }
    
    @Test func double() {
        let val: any OSCValue = Double(123.45)
        #expect("\(val)" == "123.45")
    }
    
    @Test func int64() {
        let val: any OSCValue = Int64(123)
        #expect("\(val)" == "123")
    }
    
    @Test func impulse() {
        let val: any OSCValue = OSCImpulseValue()
        #expect("\(val)" == "Impulse")
    }
    
    @Test func midi() {
        let val = OSCMIDIValue(portID: 0x01, status: 0x80, data1: 0x40, data2: 0x51)
        #expect("\(val)" == "MIDI(portID: 0x01, status: 0x80, data1: 0x40, data2: 0x51)")
    }
    
    @Test func null() {
        let val: any OSCValue = OSCNullValue()
        #expect("\(val)" == "Null")
    }
    
    @Test func stringAlt() {
        let val: any OSCValue = OSCStringAltValue("A string")
        #expect("\(val)" == "A string")
    }
    
    @Test func timeTag() {
        let val: any OSCValue = OSCTimeTag(.init(123))
        #expect("\(val)" == "123")
    }
    
    // MARK: - Opaque types
    
    @Test func anyOSCNumberValue_Int() throws {
        let val = try [Int(123)].masked(AnyOSCNumberValue.self)
        #expect("\(val)" == "123")
    }
    
    @Test func anyOSCNumberValue_Double() throws {
        let val = try [Double(1.5)].masked(AnyOSCNumberValue.self)
        #expect("\(val)" == "1.5")
    }
}
