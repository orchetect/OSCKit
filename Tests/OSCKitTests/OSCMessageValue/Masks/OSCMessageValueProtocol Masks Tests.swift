//
//  OSCMessageValueProtocol Masks Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit
import OTCore
import SwiftASCII

final class OSCMessageValueProtocol_Masks_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - [].values(mask:) Mask
    
    func testValuesFromValueMask1() throws {
        
        let mask: [OSCMessage.ValueMask.Token] = [.int32]
        
        // success
        let result1 = try [OSCMessageValue]([.int32(123)])
            .masked(mask)
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0] as? Int32, 123)
        
        // fail - empty values array
        let result2 = try? [OSCMessageValue]([])
            .masked(mask)
        XCTAssertNil(result2)
        
        // fail - wrong type
        let result3 = try? [OSCMessageValue]([.int64(123)])
            .masked(mask)
        XCTAssertNil(result3)
        
        // fail - matches but too many values
        let result4 = try? [OSCMessageValue]([.int32(123), .int32(123)])
            .masked(mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask2() throws {
        
        let mask: [OSCMessage.ValueMask.Token] = [.int32Optional]
        
        // success
        let result1 = try [OSCMessageValue]([.int32(123)])
            .masked(mask)
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0] as? Int32, 123)
        
        // success - value was optional
        let result2 = try [OSCMessageValue]([])
            .masked(mask)
        XCTAssertEqual(result2.count, 1)
        XCTAssertNil(result2[0] as? Int32) // array containing a nil
        
        // fail - wrong type
        let result3 = try? [OSCMessageValue]([.int64(123)])
            .masked(mask)
        XCTAssertNil(result3)
        
        // fail - matches but too many values
        let result4 = try? [OSCMessageValue]([.int32(123), .int32(123)])
            .masked(mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask3() throws {
        
        let mask: [OSCMessage.ValueMask.Token] = [.number]
        
        // success
        let result1 = try [OSCMessageValue]([.int32(123)])
            .masked(mask)
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0] as? Int32, 123)
        
        // fail - empty values array
        let result2 = try? [OSCMessageValue]([])
            .masked(mask)
        XCTAssertNil(result2)
        
        // success
        let result3 = try [OSCMessageValue]([.int64(123)])
            .masked(mask)
        XCTAssertEqual(result3.count, 1)
        XCTAssertEqual(OSCMessageValue.numberAsInt(result3[0]!), 123)
        
        // fail - matches but too many values
        let result4 = try? [OSCMessageValue]([.int32(123), .int32(123)])
            .masked(mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask4() throws {
        
        let mask: [OSCMessage.ValueMask.Token] = [.numberOptional]
        
        // success
        let result1 = try [OSCMessageValue]([.int32(123)])
            .masked(mask)
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0] as? Int32, 123)
        
        // success - value was optional
        let result2 = try [OSCMessageValue]([])
            .masked(mask)
        XCTAssertEqual(result2.count, 1)
        XCTAssertNil(result2[0] as? Int32) // array containing a nil
        
        // success
        let result3 = try [OSCMessageValue]([.int64(123)])
            .masked(mask)
        XCTAssertEqual(result3.count, 1)
        XCTAssertEqual(OSCMessageValue.numberAsInt(result3[0]!), 123)
        
        // fail - matches but too many values
        let result4 = try? [OSCMessageValue]([.int32(123), .int32(123)])
            .masked(mask)
        XCTAssertNil(result4)
        
    }
    
}

#endif
