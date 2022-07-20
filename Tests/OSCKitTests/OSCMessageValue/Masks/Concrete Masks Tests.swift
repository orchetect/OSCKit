//
//  Concrete Masks Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit
import OTCore
import SwiftASCII

final class ConcreteMasks_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - 1 Value
    
    func testValues1() throws {
        
        // success
        XCTAssertEqual(
            try [OSCMessageValue]([.int32(123)])
                .values(mask: Int32.self),
            (123)
        )
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessageValue]([.int32(123)])
                .values(mask: Int64.self)
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessageValue]([.int32(123), .string("str")])
            .values(mask: Int32.self)
        )
        
    }
    
    func testValues1o() throws {
        
        XCTAssertEqual(
            try [OSCMessageValue]([.int32(123)])
                .values(mask: Int32?.self),
            123
        )
        
        XCTAssertEqual(
            try [OSCMessageValue]([])
                .values(mask: Int32?.self),
            nil
        )
        
    }
    
    // MARK: - 2 Values
    
    func testValues2() throws {
        
        let values: [OSCMessageValue] = [.int32(123), .string("str")]
        
        let masked = try XCTUnwrap(values.values(mask: Int32.self, ASCIIString.self))
        
        XCTAssertEqual(masked.0, 123)
        XCTAssertEqual(masked.1, "str")
        
    }
    
    // MARK: - 3 Values
    
    //    func testValues3() throws {
    //
    //        let values: [OSCMessageValue] = [.int32(123), .string("str")]
    //
    //        let masked = try XCTUnwrap(values.values(Int32.self, ASCIIString?.self))
    //
    //        XCTAssertEqual(masked.0, 123)
    //        XCTAssertEqual(masked.1, "str")
    //
    //    }
    
    // MARK: - OSCMessageNumericValue
    
    func testValuesNumeric_int32() throws {
        
        let values: [OSCMessageValue] = [.int32(123)]
        
        let masked = try values.values(mask: OSCMessageValue.Number.self)
        
        guard case let .int32(v) = masked else { XCTFail() ; return }
        
        XCTAssertEqual(v, 123)
        
    }
    
    func testValuesNumeric_float32() throws {
        
        let values: [OSCMessageValue] = [.float32(123.45)]
        
        let masked = try values.values(mask: OSCMessageValue.Number.self)
        
        guard case let .float32(v) = masked else { XCTFail() ; return }
        
        XCTAssertEqual(v, 123.45)
        
    }
    
    func testValuesNumeric_int64() throws {
        
        let values: [OSCMessageValue] = [.int64(123)]
        
        let masked = try values.values(mask: OSCMessageValue.Number.self)
        
        guard case let .int64(v) = masked else { XCTFail() ; return }
        
        XCTAssertEqual(v, 123)
        
    }
    
    func testValuesNumeric_double() throws {
        
        let values: [OSCMessageValue] = [.double(123.45)]
        
        let masked = try values.values(mask: OSCMessageValue.Number.self)
        
        guard case let .double(v) = masked else { XCTFail() ; return }
        
        XCTAssertEqual(v, 123.45)
        
    }
    
    func testValuesNumericOptional() throws {
        
        XCTAssertEqual(
            try [OSCMessageValue]([.int32(123)])
                .values(mask: OSCMessageValue.Number?.self),
            .int32(123)
        )
        
        XCTAssertEqual(
            try [OSCMessageValue]([])
                .values(mask: OSCMessageValue.Number?.self),
            nil
        )
        
    }
    
}

#endif
