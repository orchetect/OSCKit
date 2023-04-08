//
//  OSCValueDecoder Read Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore
import SwiftASCII

final class OSCValueDecoder_Read_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Data methods
    
    func testReadInt32() throws {
        // positive
        let data1 = Data([0x00, 0x00, 0x00, 0xFF])
        var decoder1 = OSCValueDecoder(data: data1)
        XCTAssertEqual(try decoder1.readInt32(), 255)
        XCTAssertEqual(decoder1.pos, 4)
        
        // negative
        let data2 = Data([0b11111111, 0b10111000, 0b10000100, 0b10010010])
        var decoder2 = OSCValueDecoder(data: data2)
        XCTAssertEqual(try decoder2.readInt32(), -4_684_654)
        XCTAssertEqual(decoder2.pos, 4)
        
        // malformed
        let data3 = Data([0x00, 0xFF])
        var decoder3 = OSCValueDecoder(data: data3)
        XCTAssertThrowsError(try decoder3.readInt32())
    }
    
    func testReadInt64() throws {
        // positive
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        var decoder1 = OSCValueDecoder(data: data1)
        XCTAssertEqual(try decoder1.readInt64(), 255)
        XCTAssertEqual(decoder1.pos, 8)
        
        // negative
        let data2 = Data([0b11111111, 0b11111111, 0b11111111, 0b11111111,
                          0b11111111, 0b10111000, 0b10000100, 0b10010010])
        var decoder2 = OSCValueDecoder(data: data2)
        XCTAssertEqual(try decoder2.readInt64(), -4_684_654)
        XCTAssertEqual(decoder2.pos, 8)
        
        // malformed
        let data3 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        var decoder3 = OSCValueDecoder(data: data3)
        XCTAssertThrowsError(try decoder3.readInt64())
    }
    
    func testReadUInt64() throws {
        // value
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        var decoder1 = OSCValueDecoder(data: data1)
        XCTAssertEqual(try decoder1.readUInt64(), 255)
        XCTAssertEqual(decoder1.pos, 8)
        
        // malformed
        let data2 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        var decoder2 = OSCValueDecoder(data: data2)
        XCTAssertThrowsError(try decoder2.readUInt64())
    }
    
    func testReadFloat32() throws {
        // value
        let data1 = Data([0x42, 0xF6, 0xE6, 0x66]) // 123.45, big-endian
        var decoder1 = OSCValueDecoder(data: data1)
        XCTAssertEqual(try decoder1.readFloat32(), 123.45)
        XCTAssertEqual(decoder1.pos, 4)
        
        // malformed
        let data2 = Data([0x00, 0x00, 0xFF])
        var decoder2 = OSCValueDecoder(data: data2)
        XCTAssertThrowsError(try decoder2.readFloat32())
    }
    
    func testReadDouble() throws {
        // value
        let data1 = Data([0x40, 0x5E, 0xDC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCD]) // 123.45, big-endian
        var decoder1 = OSCValueDecoder(data: data1)
        XCTAssertEqual(try decoder1.readDouble(), 123.45)
        XCTAssertEqual(decoder1.pos, 8)
        
        // malformed
        let data2 = Data([0x5E, 0xDC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCD])
        var decoder2 = OSCValueDecoder(data: data2)
        XCTAssertThrowsError(try decoder2.readDouble())
    }
    
    func testRead4ByteAlignedNullTerminatedASCIIString() throws {
        // empty string
        
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        var decoder1 = OSCValueDecoder(data: data1)
        XCTAssertEqual(try decoder1.read4ByteAlignedNullTerminatedASCIIString(), "")
        XCTAssertEqual(decoder1.pos, 4)
        
        // string
        
        let data2 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x00]) // "String" null null
        var decoder2 = OSCValueDecoder(data: data2)
        XCTAssertEqual(try decoder2.read4ByteAlignedNullTerminatedASCIIString(), "String")
        XCTAssertEqual(decoder2.pos, 8)
        
        // malformed (valid ascii string data, multiple of 4 bytes, but pad is not all nulls)
        let data3 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x01]) // "String" null 1
        var decoder3 = OSCValueDecoder(data: data3)
        XCTAssertThrowsError(try decoder3.read4ByteAlignedNullTerminatedASCIIString())
        
        // malformed (valid ascii string data, but not multiple of 4 bytes and no null pad)
        let data4 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]) // "String"
        var decoder4 = OSCValueDecoder(data: data4)
        XCTAssertThrowsError(try decoder4.read4ByteAlignedNullTerminatedASCIIString())
        
        // malformed (valid ascii string data, null terminated, but not multiple of 4 bytes)
        let data5 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00]) // "String" null
        var decoder5 = OSCValueDecoder(data: data5)
        XCTAssertThrowsError(try decoder5.read4ByteAlignedNullTerminatedASCIIString())
        
        // malformed (valid ascii string data, null terminated, but less than 4 bytes)
        let data6 = Data([0x53, 0x74, 0x00]) // "St" null
        var decoder6 = OSCValueDecoder(data: data6)
        XCTAssertThrowsError(try decoder6.read4ByteAlignedNullTerminatedASCIIString())
    }
    
    func testRead4ByteAlignedNullTerminatedData() throws {
        // empty string
        
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        var decoder1 = OSCValueDecoder(data: data1)
        XCTAssertEqual(try decoder1.read4ByteAlignedNullTerminatedData(), Data())
        XCTAssertEqual(decoder1.pos, 4)
        
        // string
        
        let data2 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x00]) // "String" null null
        var decoder2 = OSCValueDecoder(data: data2)
        XCTAssertEqual(
            try decoder2.read4ByteAlignedNullTerminatedData(),
            Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67])
        )
        XCTAssertEqual(decoder2.pos, 8)
        
        // malformed (multiple of 4 bytes, but pad is not all nulls)
        let data3 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x01]) // "String" null 1
        var decoder3 = OSCValueDecoder(data: data3)
        XCTAssertThrowsError(try decoder3.read4ByteAlignedNullTerminatedData())
        
        // malformed (not multiple of 4 bytes and no null pad)
        let data4 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]) // "String"
        var decoder4 = OSCValueDecoder(data: data4)
        XCTAssertThrowsError(try decoder4.read4ByteAlignedNullTerminatedData())
        
        // malformed (null terminated, but not multiple of 4 bytes)
        let data5 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00]) // "String" null
        var decoder5 = OSCValueDecoder(data: data5)
        XCTAssertThrowsError(try decoder5.read4ByteAlignedNullTerminatedData())
        
        // malformed (valid ascii string data, null terminated, but less than 4 bytes)
        let data6 = Data([0x53, 0x74, 0x00]) // "St" null
        var decoder6 = OSCValueDecoder(data: data6)
        XCTAssertThrowsError(try decoder6.read4ByteAlignedNullTerminatedData())
    }
    
    func testReadBlob_Padding_ExactMultipleOf4Bytes() throws {
        var data = Data()
        data += [0x00, 0x00, 0x00, 8] // int32 data length
        
        // no 4-null byte pad needed if blob is a multiple of 4 bytes
        data += [
            1, 2, 3, 4, 5, 6, 7, 8
        ]
        
        var decoder = OSCValueDecoder(data: data)
        let blob = try decoder.readBlob()
        XCTAssertEqual(blob, Data([1, 2, 3, 4, 5, 6, 7, 8]))
    }
    
    func testReadBlob2_Padding_ExpectedNullByteAlignment() throws {
        var data = Data()
        data += [0x00, 0x00, 0x00, 9] // int32 data length
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 0x00, 0x00, 0x00 // correct null 4-byte alignment
        ]
        
        var decoder = OSCValueDecoder(data: data)
        let blob = try decoder.readBlob()
        XCTAssertEqual(blob, Data([1, 2, 3, 4, 5, 6, 7, 8, 9]))
    }
    
    func testReadBlob_Padding_Malformed_NotEnoughBytes1() throws {
        var data = Data()
        data += [0x00, 0x00, 0x00, 9] // int32 data length
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 0x00 // not enough null bytes (4 byte-alignment)
        ]
        
        var decoder = OSCValueDecoder(data: data)
        XCTAssertThrowsError(try decoder.readBlob())
    }
    
    func testReadBlob_Padding_Malformed_NotEnoughBytes2() throws {
        var data = Data()
        data += [0x00, 0x00, 0x00, 9] // int32 data length
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9 // missing null bytes (4 byte-alignment)
        ]
        
        var decoder = OSCValueDecoder(data: data)
        XCTAssertThrowsError(try decoder.readBlob())
    }
    
    func testReadBlob_Padding_Malformed_NullBytesNotNull() {
        var data = Data()
        data += [0x00, 0x00, 0x00, 9] // int32 data length
        data += [
            1, 2, 3, 4,
            5, 6, 7, 8,
            9, 0x00, 0x00, 0x01 // not all expected null bytes are null
        ]
        
        var decoder = OSCValueDecoder(data: data)
        XCTAssertThrowsError(try decoder.readBlob())
    }
    
    func testReadBytesCount() {
        // (test harness)
        func newDecoder(readByteLength: Int) throws -> Data {
            let data = Data([0x01, 0x02, 0x03, 0x04])
            var decoder = OSCValueDecoder(data: data)
            return try decoder.read(byteLength: readByteLength)
        }
        
        // success
        XCTAssertEqual(
            try newDecoder(readByteLength: 1),
            Data([0x01])
        )
        XCTAssertEqual(
            try newDecoder(readByteLength: 2),
            Data([0x01, 0x02])
        )
        XCTAssertEqual(
            try newDecoder(readByteLength: 3),
            Data([0x01, 0x02, 0x03])
        )
        XCTAssertEqual(
            try newDecoder(readByteLength: 4),
            Data([0x01, 0x02, 0x03, 0x04])
        )
        
        // failure - not enough bytes remaining
        XCTAssertThrowsError(
            try newDecoder(readByteLength: 5)
        )
        XCTAssertThrowsError(
            try newDecoder(readByteLength: 6)
        )
        
        // edge cases
        
        // can't test byteLength of 0 because it causes an assert and we can't catch that in a unit
        // test. it is however not an error condition, just a warning.
        // XCTAssertEqual(try newDecoder { try $0.read(byteLength: 0) }, Data([]))
        
        // negative read count throws error
        XCTAssertThrowsError(
            try newDecoder(readByteLength: -1)
        )
    }
}

#endif
