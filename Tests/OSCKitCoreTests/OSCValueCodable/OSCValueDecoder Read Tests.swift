//
//  OSCValueDecoder Read Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCValueDecoder_Read_Tests {
    // swiftformat:options --wrapcollections preserve
    
    // MARK: - Data methods
    
    @Test
    func readOSCInt32() throws {
        // positive
        let data1 = Data([0x00, 0x00, 0x00, 0xFF])
        try data1.withPointerDataParser { parser in
            try #expect(parser.readOSCInt32() == 255)
            #expect(parser.readOffset == 4)
        }
        
        // negative
        let data2 = Data([0b11111111, 0b10111000, 0b10000100, 0b10010010])
        try data2.withPointerDataParser { parser in
            try #expect(parser.readOSCInt32() == -4_684_654)
            #expect(parser.readOffset == 4)
        }
        
        // malformed
        let data3 = Data([0x00, 0xFF])
        data3.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCInt32() }
        }
    }
    
    @Test
    func readOSCInt64() throws {
        // positive
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        try data1.withPointerDataParser { parser in
            try #expect(parser.readOSCInt64() == 255)
            #expect(parser.readOffset == 8)
        }
        
        // negative
        let data2 = Data([0b11111111, 0b11111111, 0b11111111, 0b11111111,
                          0b11111111, 0b10111000, 0b10000100, 0b10010010])
        try data2.withPointerDataParser { parser in
            try #expect(parser.readOSCInt64() == -4_684_654)
            #expect(parser.readOffset == 8)
        }
        
        // malformed
        let data3 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        data3.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCInt64() }
        }
    }
    
    @Test
    func readOSCUInt64() throws {
        // value
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        try data1.withPointerDataParser { parser in
            try #expect(parser.readOSCUInt64() == 255)
            #expect(parser.readOffset == 8)
        }
        
        // malformed
        let data2 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        data2.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCUInt64() }
        }
    }
    
    @Test
    func readOSCFloat32() throws {
        // value
        let data1 = Data([0x42, 0xF6, 0xE6, 0x66]) // 123.45, big-endian
        try data1.withPointerDataParser { parser in
            try #expect(parser.readOSCFloat32() == 123.45)
            #expect(parser.readOffset == 4)
        }
        
        // malformed
        let data2 = Data([0x00, 0x00, 0xFF])
        data2.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCFloat32() }
        }
    }
    
    @Test
    func readOSCDouble() throws {
        // value
        let data1 = Data([0x40, 0x5E, 0xDC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCD]) // 123.45, big-endian
        try data1.withPointerDataParser { parser in
            try #expect(parser.readOSCDouble() == 123.45)
            #expect(parser.readOffset == 8)
        }
        
        // malformed
        let data2 = Data([0x5E, 0xDC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCD])
        data2.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCDouble() }
        }
    }
    
    @Test
    func readOSC4ByteAlignedNullTerminatedASCIIString() throws {
        // empty string
        
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        try data1.withPointerDataParser { parser in
            try #expect(parser.readOSC4ByteAlignedNullTerminatedASCIIString() == "")
            #expect(parser.readOffset == 4)
        }
        
        // string
        
        let data2 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x00]) // "String" null null
        try data2.withPointerDataParser { parser in
            try #expect(parser.readOSC4ByteAlignedNullTerminatedASCIIString() == "String")
            #expect(parser.readOffset == 8)
        }
        
        // malformed (valid ascii string data, multiple of 4 bytes, but pad is not all nulls)
        let data3 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x01]) // "String" null 1
        data3.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSC4ByteAlignedNullTerminatedASCIIString() }
        }
        
        // malformed (valid ascii string data, but not multiple of 4 bytes and no null pad)
        let data4 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]) // "String"
        data4.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSC4ByteAlignedNullTerminatedASCIIString() }
        }
        
        // malformed (valid ascii string data, null terminated, but not multiple of 4 bytes)
        let data5 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00]) // "String" null
        data5.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSC4ByteAlignedNullTerminatedASCIIString() }
        }
        
        // malformed (valid ascii string data, null terminated, but less than 4 bytes)
        let data6 = Data([0x53, 0x74, 0x00]) // "St" null
        data6.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSC4ByteAlignedNullTerminatedASCIIString() }
        }
    }
    
    @Test
    func readOSC4ByteAlignedNullTerminatedData() throws {
        // empty string
        
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        try data1.withPointerDataParser { parser in
            try #expect(parser.readOSC4ByteAlignedNullTerminatedData().toData() == Data())
            #expect(parser.readOffset == 4)
        }
        
        // string
        
        let data2 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x00]) // "String" null null
        try data2.withPointerDataParser { parser in
            try #expect(
                parser.readOSC4ByteAlignedNullTerminatedData().toData()
                    == Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67])
            )
            #expect(parser.readOffset == 8)
        }
        
        // malformed (multiple of 4 bytes, but pad is not all nulls)
        let data3 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x01]) // "String" null 1
        data3.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSC4ByteAlignedNullTerminatedData() }
        }
        
        // malformed (not multiple of 4 bytes and no null pad)
        let data4 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]) // "String"
        data4.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSC4ByteAlignedNullTerminatedData() }
        }
        
        // malformed (null terminated, but not multiple of 4 bytes)
        let data5 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00]) // "String" null
        data5.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSC4ByteAlignedNullTerminatedData() }
        }
        
        // malformed (valid ascii string data, null terminated, but less than 4 bytes)
        let data6 = Data([0x53, 0x74, 0x00]) // "St" null
        data6.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSC4ByteAlignedNullTerminatedData() }
        }
    }
    
    @Test
    func readOSCBlob_Padding_ExactMultipleOf4Bytes() throws {
        var data = Data()
        data += [0x00, 0x00, 0x00, 8] // int32 data length
        
        // no 4-null byte pad needed if blob is a multiple of 4 bytes
        data += [
            1, 2, 3, 4, 5, 6, 7, 8
        ]
        
        try data.withPointerDataParser { parser in
            let blob = try parser.readOSCBlob().toData()
            #expect(blob == Data([1, 2, 3, 4, 5, 6, 7, 8]))
        }
    }
    
    @Test
    func readOSCBlob2_Padding_ExpectedNullByteAlignment() throws {
        var data = Data()
        data += [0x00, 0x00, 0x00, 9] // int32 data length
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 0x00, 0x00, 0x00 // correct null 4-byte alignment
        ]
        
        try data.withPointerDataParser { parser in
            let blob = try parser.readOSCBlob().toData()
            #expect(blob == Data([1, 2, 3, 4, 5, 6, 7, 8, 9]))
        }
    }
    
    @Test
    func readOSCBlob_Padding_Malformed_NotEnoughBytes1() throws {
        var data = Data()
        data += [0x00, 0x00, 0x00, 9] // int32 data length
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 0x00 // not enough null bytes (4 byte-alignment)
        ]
        
        data.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCBlob() }
        }
    }
    
    @Test
    func readOSCBlob_Padding_Malformed_NotEnoughBytes2() throws {
        var data = Data()
        data += [0x00, 0x00, 0x00, 9] // int32 data length
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9 // missing null bytes (4 byte-alignment)
        ]
        
        data.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCBlob() }
        }
    }
    
    @Test
    func readOSCBlob_Padding_Malformed_NullBytesNotNull() {
        var data = Data()
        data += [0x00, 0x00, 0x00, 9] // int32 data length
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 0x00, 0x00, 0x01 // not all expected null bytes are null
        ]
        
        data.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCBlob() }
        }
    }
    
    @Test
    func readOSCBlob_Padding_Malformed_LengthTooLarge() {
        var data = Data()
        data += [0x7F, 0x9F, 0xEF, 0xAE] // int32 data length value is way too large
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 0x00, 0x00, 0x00
        ] // valid data
        
        data.withPointerDataParser { parser in
            #expect(throws: OSCDecodeError.self) { _ = try parser.readOSCBlob() }
        }
    }
}
