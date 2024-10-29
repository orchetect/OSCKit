//
//  OSCMessage Codable Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing

@Suite struct OSCMessage_Codable_Tests {
    fileprivate let encoder = JSONEncoder()
    fileprivate let decoder = JSONDecoder()
    
    // TODO: uncomment these tests once `OSCMessage.Codable` conformance is fixed
    // TODO: these need reordering and new types added (ie: OSCImpulseValue)
    
    // @Test func addressOnly() throws {
    //     let msg = OSCMessage("/test/address")
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // // MARK: - Core Types
    //
    // @Test func int32() throws {
    //     let msg = OSCMessage("/test/address", values: [Int32(123)])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func float32() throws {
    //     let msg = OSCMessage("/test/address", values: [Float32(123)])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func string() throws {
    //     let msg = OSCMessage("/test/address", values: [String("A string.")])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func blob() throws {
    //     let msg = OSCMessage("/test/address", values: [Data([0x01, 0x02])])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // // MARK: - Extended Types
    //
    // @Test func int64() throws {
    //     let msg = OSCMessage("/test/address", values: [Int64(123)])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func timeTag() throws {
    //     let msg = OSCMessage("/test/address", values: [OSCTimeTag(.init(123))])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func double() throws {
    //     let msg = OSCMessage("/test/address", values: [Double(123.45)])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func stringAlt() throws {
    //     let msg = OSCMessage("/test/address", values: [OSCStringAltValue("A string.")])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func character() throws {
    //     let msg = OSCMessage("/test/address", values: [Character("A")])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func midiMessage() throws {
    //     let msg = OSCMessage("/test/address", values: [
    //         OSCMIDIValue(portID: 0x01, status: 0xB0, data1: 0x01, data2: 0x60)
    //     ])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func bool() throws {
    //     let msg = OSCMessage("/test/address", values: [true])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // @Test func null() throws {
    //     let msg = OSCMessage("/test/address", values: [OSCNullValue()])
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
    //
    // // MARK: - Multiple values
    //
    // @Test func multipleValues() throws {
    //     let msg = OSCMessage(
    //         "/test/address",
    //         values: [
    //             Int32(123),
    //             String("A string."),
    //             Bool(true),
    //             Float32(123.45),
    //             Data([0x01, 0x02])
    //         ]
    //     )
    //
    //     let encoded = try encoder.encode(msg)
    //     let decoded = try decoder.decode(OSCMessage.self, from: encoded)
    //
    //     #expect(msg == decoded)
    // }
}
