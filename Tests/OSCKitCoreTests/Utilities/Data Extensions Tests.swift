//
//  Data Extensions Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore
import SwiftASCII

final class DataExtensions_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Data methods
    
    func testExtractInt32() {
        // value
        
        let data1 = Data([0x00, 0x00, 0x00, 0xFF])
        XCTAssertEqual(data1.readInt32()?.int32Value, 255)
        XCTAssertEqual(data1.readInt32()?.byteLength, 4)
        
        // malformed
        
        let data2 = Data([0x00, 0xFF])
        XCTAssertNil(data2.readInt32())
    }
    
    func testExtractInt64() {
        // value
        
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        XCTAssertEqual(data1.readInt64()?.int64Value, 255)
        XCTAssertEqual(data1.readInt64()?.byteLength, 8)
        
        // malformed
        
        let data2 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        XCTAssertNil(data2.readInt64())
    }
    
    func testExtractFloat32() {
        // value
        
        let data1 = Data([0x42, 0xF6, 0xE6, 0x66]) // 123.45, big-endian
        XCTAssertEqual(data1.readFloat32()?.float32Value, 123.45)
        XCTAssertEqual(data1.readFloat32()?.byteLength, 4)
        
        // malformed
        
        let data2 = Data([0x00, 0x00, 0xFF])
        XCTAssertNil(data2.readFloat32())
    }
    
    func testExtractDouble() {
        // value
        
        let data1 = Data([0x40, 0x5E, 0xDC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCD]) // 123.45, big-endian
        XCTAssertEqual(data1.readDouble()?.doubleValue, 123.45)
        XCTAssertEqual(data1.readDouble()?.byteLength, 8)
        
        // malformed
        
        let data2 = Data([0x5E, 0xDC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCD])
        XCTAssertNil(data2.readDouble())
    }
    
    func testExtractNull4ByteTerminatedString() {
        // empty string
        
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        XCTAssertEqual(data1.read4ByteAlignedNullTerminatedASCIIString()?.asciiStringValue, "")
        XCTAssertEqual(data1.read4ByteAlignedNullTerminatedASCIIString()?.byteLength, 4)
        
        // string
        
        let data2 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x00]) // "String" null null
        XCTAssertEqual(
            data2.read4ByteAlignedNullTerminatedASCIIString()?.asciiStringValue,
            "String"
        )
        XCTAssertEqual(data2.read4ByteAlignedNullTerminatedASCIIString()?.byteLength, 8)
        
        // malformed (valid ascii string data, multiple of 4 bytes, but pad is not all nulls)
        let data3 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x01]) // "String" null 1
        XCTAssertNil(data3.read4ByteAlignedNullTerminatedASCIIString())
        
        // malformed (valid ascii string data, but not multiple of 4 bytes and no null pad)
        let data4 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]) // "String"
        XCTAssertNil(data4.read4ByteAlignedNullTerminatedASCIIString())
        
        // malformed (valid ascii string data, null terminated, but not multiple of 4 bytes)
        let data5 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00]) // "String" null
        XCTAssertNil(data5.read4ByteAlignedNullTerminatedASCIIString())
        
        // malformed (valid ascii string data, null terminated, but less than 4 bytes)
        let data6 = Data([0x53, 0x74, 0x00]) // "St" null
        XCTAssertNil(data6.read4ByteAlignedNullTerminatedASCIIString())
    }
    
    func testExtractNull4ByteTerminatedData() {
        // empty string
        
        let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
        XCTAssertEqual(data1.read4ByteAlignedNullTerminatedData()?.remainingData, Data())
        XCTAssertEqual(data1.read4ByteAlignedNullTerminatedData()?.byteLength, 4)
        
        // string
        
        let data2 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x00]) // "String" null null
        XCTAssertEqual(
            data2.read4ByteAlignedNullTerminatedData()?.remainingData,
            Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67])
        )
        XCTAssertEqual(data2.read4ByteAlignedNullTerminatedData()?.byteLength, 8)
        
        // malformed (multiple of 4 bytes, but pad is not all nulls)
        let data3 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x01]) // "String" null 1
        XCTAssertNil(data3.read4ByteAlignedNullTerminatedData())
        
        // malformed (not multiple of 4 bytes and no null pad)
        let data4 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]) // "String"
        XCTAssertNil(data4.read4ByteAlignedNullTerminatedData())
        
        // malformed (null terminated, but not multiple of 4 bytes)
        let data5 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00]) // "String" null
        XCTAssertNil(data5.read4ByteAlignedNullTerminatedData())
        
        // malformed (valid ascii string data, null terminated, but less than 4 bytes)
        let data6 = Data([0x53, 0x74, 0x00]) // "St" null
        XCTAssertNil(data6.read4ByteAlignedNullTerminatedData())
    }
    
    func testExtractBlob1() {
        // success
        
        var remainingData = Data()
        
        remainingData += [0x00, 0x00, 0x00,    8] // int32 data length
        
        remainingData += [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8
        ] // no 4-null byte pad needed if blob is a multiple of 4 bytes
        
        guard let blob = remainingData.readBlob() else {
            XCTFail("Could not extract blob from data. Can't continue test.")
            return
        }
        
        XCTAssertEqual(blob.blobValue, Data([1, 2, 3, 4, 5, 6, 7, 8]))
        XCTAssertEqual(blob.byteLength, 8)
    }
    
    func testExtractBlob2() {
        // success
        
        var remainingData = Data()
        
        remainingData += [0x00, 0x00, 0x00,    9] // int32 data length
        
        remainingData += [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            0x00,
            0x00,
            0x00
        ]
        
        guard let blob = remainingData.readBlob() else {
            XCTFail("Could not extract blob from data. Can't continue test.")
            return
        }
        
        XCTAssertEqual(blob.blobValue, Data([1, 2, 3, 4, 5, 6, 7, 8, 9]))
        XCTAssertEqual(blob.byteLength, 12)
    }
    
    func testExtractBlob3() {
        // malformed
        
        var remainingData = Data()
        
        remainingData += [0x00, 0x00, 0x00,    9] // int32 data length
        
        remainingData += [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            0x00
        ]
        
        // null terminated but not null padded to multiples of 4 bytes
        XCTAssertNil(remainingData.readBlob())
    }
    
    func testExtractBlob4() {
        // malformed
        
        var remainingData = Data()
        
        remainingData += [0x00, 0x00, 0x00,    9] // int32 data length
        
        remainingData += [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9
        ]
        
        // not null padded to multiples of 4 bytes
        XCTAssertNil(remainingData.readBlob())
    }
    
    func testExtractBlob5() {
        // malformed
        
        var remainingData = Data()
        
        remainingData += [0x00, 0x00, 0x00,    9] // int32 data length
        
        remainingData += [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            0x00,
            0x00,
            0x01
        ]
        
        // null terminated but pad is not all nulls
        XCTAssertNil(remainingData.readBlob())
    }
    
    func testExtractBytesCount() {
        var remainingData = Data()
        
        remainingData += [0x01, 0x02, 0x03, 0x04] // arbitrary bytes
        
        // success
        
        // malformed
        
        // not null padded to multiples of 4 bytes
        XCTAssertNil(remainingData.read(byteLength: -1))
        XCTAssertEqual(remainingData.read(byteLength: 0), Data([]))
        XCTAssertEqual(remainingData.read(byteLength: 1), Data([0x01]))
        XCTAssertEqual(remainingData.read(byteLength: 2), Data([0x01, 0x02]))
        XCTAssertEqual(remainingData.read(byteLength: 3), Data([0x01, 0x02, 0x03]))
        XCTAssertEqual(remainingData.read(byteLength: 4), Data([0x01, 0x02, 0x03, 0x04]))
        XCTAssertNil(remainingData.read(byteLength: 5))
        XCTAssertNil(remainingData.read(byteLength: 6))
    }
}

#endif
