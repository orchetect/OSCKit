//
//  OSCValueToken Properties Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore
import OTCore
import SwiftASCII

final class OSCValueToken_Properties_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - baseType
    
    func testBaseType() {
        OSCValueToken.allCases.forEach { token in
            switch token {
            // concrete types
            
            // -- core types
            case .blob:              XCTAssertEqual(token.baseType, .blob)
            case .float32:           XCTAssertEqual(token.baseType, .float32)
            case .int32:             XCTAssertEqual(token.baseType, .int32)
            case .string:            XCTAssertEqual(token.baseType, .string)
            
            // -- extended types
            case .array:             XCTAssertEqual(token.baseType, .array)
            case .bool:              XCTAssertEqual(token.baseType, .bool)
            case .character:         XCTAssertEqual(token.baseType, .character)
            case .double:            XCTAssertEqual(token.baseType, .double)
            case .int64:             XCTAssertEqual(token.baseType, .int64)
            case .impulse:           XCTAssertEqual(token.baseType, .impulse)
            case .midi:              XCTAssertEqual(token.baseType, .midi)
            case .null:              XCTAssertEqual(token.baseType, .null)
            case .stringAlt:         XCTAssertEqual(token.baseType, .stringAlt)
            case .timeTag:           XCTAssertEqual(token.baseType, .timeTag)
            
            // -- opaque types
            
            case .number:            XCTAssertEqual(token.baseType, .number)
            
            // optional versions of concrete types
            
            // -- core types
            case .blobOptional:      XCTAssertEqual(token.baseType, .blob)
            case .float32Optional:   XCTAssertEqual(token.baseType, .float32)
            case .int32Optional:     XCTAssertEqual(token.baseType, .int32)
            case .stringOptional:    XCTAssertEqual(token.baseType, .string)
            
            // -- extended types
            case .arrayOptional:     XCTAssertEqual(token.baseType, .array)
            case .boolOptional:      XCTAssertEqual(token.baseType, .bool)
            case .characterOptional: XCTAssertEqual(token.baseType, .character)
            case .doubleOptional:    XCTAssertEqual(token.baseType, .double)
            case .int64Optional:     XCTAssertEqual(token.baseType, .int64)
            case .impulseOptional:   XCTAssertEqual(token.baseType, .impulse)
            case .midiOptional:      XCTAssertEqual(token.baseType, .midi)
            case .nullOptional:      XCTAssertEqual(token.baseType, .null)
            case .stringAltOptional: XCTAssertEqual(token.baseType, .stringAlt)
            case .timeTagOptional:   XCTAssertEqual(token.baseType, .timeTag)
            
            // -- opaque types
            case .numberOptional:    XCTAssertEqual(token.baseType, .number)
            }
        }
    }
    
    // MARK: - isOptional
    
    func testIsOptional() {
        OSCValueToken.allCases.forEach { token in
            switch token {
            // optional versions of concrete types
            
            // -- core types
            case .blobOptional:      XCTAssertEqual(token.isOptional, true)
            case .float32Optional:   XCTAssertEqual(token.isOptional, true)
            case .int32Optional:     XCTAssertEqual(token.isOptional, true)
            case .stringOptional:    XCTAssertEqual(token.isOptional, true)
            
            // -- extended types
            case .arrayOptional:     XCTAssertEqual(token.isOptional, true)
            case .boolOptional:      XCTAssertEqual(token.isOptional, true)
            case .characterOptional: XCTAssertEqual(token.isOptional, true)
            case .doubleOptional:    XCTAssertEqual(token.isOptional, true)
            case .int64Optional:     XCTAssertEqual(token.isOptional, true)
            case .impulseOptional:   XCTAssertEqual(token.isOptional, true)
            case .midiOptional:      XCTAssertEqual(token.isOptional, true)
            case .nullOptional:      XCTAssertEqual(token.isOptional, true)
            case .stringAltOptional: XCTAssertEqual(token.isOptional, true)
            case .timeTagOptional:   XCTAssertEqual(token.isOptional, true)
            
            // -- opaque types
            case .numberOptional:    XCTAssertEqual(token.isOptional, true)
                
            default:                 XCTAssertEqual(token.isOptional, false)
            }
        }
    }
}

#endif
