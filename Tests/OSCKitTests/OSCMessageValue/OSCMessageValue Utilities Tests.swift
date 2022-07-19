//
//  OSCMessageValue Utilities Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit

final class OSCMessageValue_Utilities_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testNumberAsInt() {
        
        // core types
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Int),     123)
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Int32),   123)
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Float32), 123)
        
        // extended types
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Int64),   123)
        XCTAssertEqual(OSCMessageValue.numberAsInt(123 as Double),  123)
        
        // unsuccessful
        XCTAssertNil(  OSCMessageValue.numberAsInt(123.45 as Float32))
        
        // invalid
        XCTAssertNil(  OSCMessageValue.numberAsInt("a string"))
        
    }
    
    func testNumberAsDouble() {
        
        // core types
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Int),      123.0)
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Int32),    123.0)
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Float32),  123.0)
        
        // extended types
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Int64),    123.0)
        XCTAssertEqual(OSCMessageValue.numberAsDouble(123 as Double),   123.0)
        
        // unsuccessful
        XCTAssertNil(  OSCMessageValue.numberAsDouble(Int.max as Int))
        
        // invalid
        XCTAssertNil(  OSCMessageValue.numberAsDouble("a string"))
        
    }
    
}

#endif
