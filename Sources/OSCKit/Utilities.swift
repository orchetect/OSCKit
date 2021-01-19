//
//  Utilities.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2019-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import Foundation


// MARK: - Data methods

internal extension Data {
	
	/// Internal helper function.
	@inlinable func extractInt32() -> (int32Value: Int32, byteCount: Int)? {
		
		if self.count < 4 { return nil }
		
		let chunk = self.subdata(in: 0..<4)
		
		guard let value = chunk.toInt32(from: .bigEndian)
		else { return nil }
		
		return ( value, chunk.count )
		
	}
	
	/// Internal helper function.
	@inlinable func extractInt64() -> (int64Value: Int64, byteCount: Int)? {
		
		if self.count < 8 { return nil }
		
		let chunk = self.subdata(in: 0..<8)
		
		guard let value = chunk.toInt64(from: .bigEndian)
		else { return nil }
		
		return ( value, chunk.count )
		
	}
	
	/// Internal helper function.
	/// aka Float
	@inlinable func extractFloat32() -> (float32Value: Float32, byteCount: Int)? {
		
		if self.count < 4 { return nil }
		
		let chunk = self.subdata(in: 0..<4)
		
		guard let value = chunk.toFloat32(from: .bigEndian)
		else { return nil }
		
		return ( value, chunk.count )
		
	}
	
	/// Internal helper function.
	/// aka Float64
	@inlinable func extractDouble() -> (doubleValue: Double, byteCount: Int)? {
		
		if self.count < 8 { return nil }
		
		let chunk = self.subdata(in: 0..<8)
		
		guard let value = chunk.toDouble(from: .bigEndian)
		else { return nil }
		
		return ( value, chunk.count )
		
	}
	
	/// Internal helper function.
	@inlinable func extractNull4ByteTerminatedString() -> (stringValue: String, byteCount: Int)? {
		
		// extractNull4ByteTerminatedData takes care of data size validation so we don't need to do it here
		guard let chunk = self.extractNull4ByteTerminatedData()
		else { return nil }
		
		guard let string = chunk.data.toString(using: .nonLossyASCII)
		else { return nil }
		
		return ( string, chunk.byteCount )
		
	}
	
	/// Internal helper function.
	@inlinable func extractNull4ByteTerminatedData() -> (data: Data, byteCount: Int)? {
		
		// ensure minimum of 4 bytes to work with
		if self.count < 4 { return nil }
		
		// check for first null
		guard let nullFound: Int = self.range(of: Data([0x00]))?.lowerBound
		else { return nil }
		
		// calculate theoretical position after first null that is a multiple of 4 bytes
		let byteCount = nullFound + (4 - (nullFound % 4))
		
		// check to see if there actually are enough bytes
		guard self.count >= byteCount else { return nil }
		
		// check to see if any pad bytes are all nulls
		guard self[nullFound..<byteCount].allSatisfy({ $0 == 0x00 })
		else { return nil }
		
		return ( self.subdata(in: 0..<nullFound), byteCount )
		
	}
	
	/// Internal helper function.
	@inlinable func extractBlob() -> (blobValue: Data, byteCount: Int)? {
		
		// check for int32 length chunk
		guard let pull = self.extractInt32()
		else { return nil }
		
		let blobSize = Int(pull.int32Value) // blob byte length
		
		let blobRawSize = (self.count - 4).roundedUp(toMultiplesOf: 4) // blob OSC chunk length
		
		// check if data is indeed at least as long as the int32 length claims it is
		if (blobRawSize > self.count - 4) { return nil }
		
		// check to see if any pad bytes are all nulls
		guard self[4+blobSize..<4+blobRawSize].allSatisfy({ $0 == 0x00 })
		else { return nil }
		
		let chunk = self.subdata(in: 4..<4+blobSize)
		
		return ( chunk, blobRawSize )
		
	}
	
	/// Internal helper function.
	@inlinable func extract(byteCount: Int) -> Data? {
		
		if byteCount < 0 || byteCount > self.count { return nil }
		
		return self[0..<byteCount]
		
	}
	
}

internal extension Data {
	
	/// Internal helper function.
	/// Conforms a data bock representing a string to 4-byte null-padded OSC-string formatting
	@inlinable var fourNullBytePadded: Data {
		
		var retval = self
		let appendval = Data([UInt8](repeating: 00, count: (4 - (self.count % 4))))
		retval += appendval
		
		return retval
		
	}
	
}
