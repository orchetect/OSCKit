//
//  Utilities Tests.swift
//  OSCKitTests
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import OSCKit

class UtilitiesTests: XCTestCase {
	
	override func setUp() { super.setUp() }
	override func tearDown() { super.tearDown() }
	
	
	// MARK: - Data methods
	
	func test_extractInt32() {
		
		// value
		
		let data1 = Data([0x00, 0x00, 0x00, 0xFF])
		XCTAssertEqual(data1.extractInt32()?.int32Value	, 255)
		XCTAssertEqual(data1.extractInt32()?.byteCount	, 4)
		
		// malformed
		
		let data2 = Data([0x00, 0xFF])
		XCTAssertNil(data2.extractInt32())
		
	}
	
	func test_extractInt64() {
		
		// value
		
		let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
		XCTAssertEqual(data1.extractInt64()?.int64Value	, 255)
		XCTAssertEqual(data1.extractInt64()?.byteCount	, 8)
		
		// malformed
		
		let data2 = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
		XCTAssertNil(data2.extractInt64())
		
	}
	
	func test_extractFloat32() {
		
		// value
		
		let data1 = Data([0x42, 0xF6, 0xE6, 0x66]) // 123.45, big-endian
		XCTAssertEqual(data1.extractFloat32()?.float32Value	, 123.45)
		XCTAssertEqual(data1.extractFloat32()?.byteCount	, 4)
		
		// malformed
		
		let data2 = Data([0x00, 0x00, 0xFF])
		XCTAssertNil(data2.extractFloat32())
		
	}
	
	func test_extractDouble() {
		
		// value
		
		let data1 = Data([0x40, 0x5E, 0xDC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCD]) // 123.45, big-endian
		XCTAssertEqual(data1.extractDouble()?.doubleValue	, 123.45)
		XCTAssertEqual(data1.extractDouble()?.byteCount		, 8)
		
		// malformed
		
		let data2 = Data([0x5E, 0xDC, 0xCC, 0xCC, 0xCC, 0xCC, 0xCD])
		XCTAssertNil(data2.extractDouble())
		
	}
	
	func test_extractNull4ByteTerminatedString() {
		
		// empty string
		
		let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
		XCTAssertEqual(data1.extractNull4ByteTerminatedString()?.stringValue	, "")
		XCTAssertEqual(data1.extractNull4ByteTerminatedString()?.byteCount		, 4)
		
		// string
		
		let data2 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x00]) // "String" null null
		XCTAssertEqual(data2.extractNull4ByteTerminatedString()?.stringValue	, "String")
		XCTAssertEqual(data2.extractNull4ByteTerminatedString()?.byteCount		, 8)
		
		// malformed (valid ascii string data, multiple of 4 bytes, but pad is not all nulls)
		let data3 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x01]) // "String" null 1
		XCTAssertNil(data3.extractNull4ByteTerminatedString())
		
		// malformed (valid ascii string data, but not multiple of 4 bytes and no null pad)
		let data4 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]) // "String"
		XCTAssertNil(data4.extractNull4ByteTerminatedString())
		
		// malformed (valid ascii string data, null terminated, but not multiple of 4 bytes)
		let data5 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00]) // "String" null
		XCTAssertNil(data5.extractNull4ByteTerminatedString())
		
		// malformed (valid ascii string data, null terminated, but less than 4 bytes)
		let data6 = Data([0x53, 0x74, 0x00]) // "St" null
		XCTAssertNil(data6.extractNull4ByteTerminatedString())
		
	}
	
	func test_extractNull4ByteTerminatedData() {
		
		// empty string
		
		let data1 = Data([0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04])
		XCTAssertEqual(data1.extractNull4ByteTerminatedData()?.data				, Data())
		XCTAssertEqual(data1.extractNull4ByteTerminatedData()?.byteCount		, 4)
		
		// string
		
		let data2 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x00]) // "String" null null
		XCTAssertEqual(data2.extractNull4ByteTerminatedData()?.data				, Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]))
		XCTAssertEqual(data2.extractNull4ByteTerminatedData()?.byteCount		, 8)
		
		// malformed (multiple of 4 bytes, but pad is not all nulls)
		let data3 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00, 0x01]) // "String" null 1
		XCTAssertNil(data3.extractNull4ByteTerminatedData())
		
		// malformed (not multiple of 4 bytes and no null pad)
		let data4 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67]) // "String"
		XCTAssertNil(data4.extractNull4ByteTerminatedData())
		
		// malformed (null terminated, but not multiple of 4 bytes)
		let data5 = Data([0x53, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x00]) // "String" null
		XCTAssertNil(data5.extractNull4ByteTerminatedData())
		
		// malformed (valid ascii string data, null terminated, but less than 4 bytes)
		let data6 = Data([0x53, 0x74, 0x00]) // "St" null
		XCTAssertNil(data6.extractNull4ByteTerminatedData())
	}
	
	func test_extractBlob1() {
		
		// success
		
		var data = Data()
		
		data += [0x00, 0x00, 0x00,    8] // int32 data length
		
		data += [   1,    2,    3,    4,
				    5,    6,    7,    8] // no 4-null byte pad needed if blob is a multiple of 4 bytes
		
		guard let blob = data.extractBlob() else {
			XCTFail("Could not extract blob from data. Can't continue test.")
			return
		}
		
		XCTAssertEqual(blob.blobValue, Data([1,2,3,4,5,6,7,8]))
		XCTAssertEqual(blob.byteCount, 8)
		
	}
	
	func test_extractBlob2() {
		
		// success
		
		var data = Data()
		
		data += [0x00, 0x00, 0x00,    9] // int32 data length
		
		data += [   1,    2,    3,    4,
				    5,    6,    7,    8,
				    9, 0x00, 0x00, 0x00]
		
		guard let blob = data.extractBlob() else {
			XCTFail("Could not extract blob from data. Can't continue test.")
			return
		}
		
		XCTAssertEqual(blob.blobValue, Data([1,2,3,4,5,6,7,8,9]))
		XCTAssertEqual(blob.byteCount, 12)
		
	}
	
	func test_extractBlob3() {
		
		// malformed
		
		var data = Data()
		
		data += [0x00, 0x00, 0x00,    9] // int32 data length
		
		data += [   1,    2,    3,    4,
				    5,    6,    7,    8,
				    9, 0x00]
		
		// null terminated but not null padded to multiples of 4 bytes
		XCTAssertNil(data.extractBlob())
		
	}
	
	func test_extractBlob4() {
		
		// malformed
		
		var data = Data()
		
		data += [0x00, 0x00, 0x00,    9] // int32 data length
		
		data += [   1,    2,    3,    4,
				    5,    6,    7,    8,
				    9]
		
		// not null padded to multiples of 4 bytes
		XCTAssertNil(data.extractBlob())
		
	}
	
	func test_extractBlob5() {
		
		// malformed
		
		var data = Data()
		
		data += [0x00, 0x00, 0x00,    9] // int32 data length
		
		data += [   1,    2,    3,    4,
				    5,    6,    7,    8,
				    9, 0x00, 0x00, 0x01]
		
		// null terminated but pad is not all nulls
		XCTAssertNil(data.extractBlob())
		
	}
	
	func test_extractBytesCount() {
		
		var data = Data()
		
		data += [0x01, 0x02, 0x03, 0x04] // arbitrary bytes
		
		// success
		
		// malformed
		
		// not null padded to multiples of 4 bytes
		XCTAssertNil(  data.extract(byteCount: -1))
		XCTAssertEqual(data.extract(byteCount: 0), Data([]))
		XCTAssertEqual(data.extract(byteCount: 1), Data([0x01]))
		XCTAssertEqual(data.extract(byteCount: 2), Data([0x01, 0x02]))
		XCTAssertEqual(data.extract(byteCount: 3), Data([0x01, 0x02, 0x03]))
		XCTAssertEqual(data.extract(byteCount: 4), Data([0x01, 0x02, 0x03, 0x04]))
		XCTAssertNil(  data.extract(byteCount: 5))
		XCTAssertNil(  data.extract(byteCount: 6))
		
	}
	
}

#endif
