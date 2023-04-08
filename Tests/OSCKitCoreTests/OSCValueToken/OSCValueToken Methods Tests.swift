//
//  OSCValueToken Methods Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKitCore
import SwiftASCII

final class OSCValueTokenMethods_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - OSCValueToken.isBaseType(matching:)
    
    // MARK: ... Core types
    
    func testBaseTypeMatches_blob() {
        let val: AnyOSCValue = Data([1, 2, 3])
        let valType: OSCValueToken = .blob
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_float32() {
        let val: AnyOSCValue = Float32(123.45)
        let valType: OSCValueToken = .float32
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType, .number:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_int32() {
        let val: AnyOSCValue = Int32(123)
        let valType: OSCValueToken = .int32
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType, .number:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_string() {
        let val: AnyOSCValue = String("A string")
        let valType: OSCValueToken = .string
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    // MARK: ... Extended types
    
    func testBaseTypeMatches_array() {
        let val: AnyOSCValue = OSCArrayValue([Int32(123)])
        let valType: OSCValueToken = .array
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_bool() {
        let val: AnyOSCValue = true
        let valType: OSCValueToken = .bool
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_character() {
        let val: AnyOSCValue = Character("A")
        let valType: OSCValueToken = .character
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_double() {
        let val: AnyOSCValue = Double(456.78)
        let valType: OSCValueToken = .double
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType, .number:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_int64() {
        let val: AnyOSCValue = Int64(456)
        let valType: OSCValueToken = .int64
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType, .number:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_impulse() {
        let val: AnyOSCValue = OSCImpulseValue()
        let valType: OSCValueToken = .impulse
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_midi() {
        let val: AnyOSCValue = OSCMIDIValue(portID: 0x00, status: 0x00, data1: 0x00, data2: 0x00)
        let valType: OSCValueToken = .midi
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_null() {
        let val: AnyOSCValue = OSCNullValue()
        let valType: OSCValueToken = .null
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_stringAlt() {
        let val: AnyOSCValue = OSCStringAltValue("An alt string")
        let valType: OSCValueToken = .stringAlt
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    func testBaseTypeMatches_timeTag() {
        let val: AnyOSCValue = OSCTimeTag(.init(456))
        let valType: OSCValueToken = .timeTag
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    // MARK: ... Opaque types
    
    func testBaseTypeMatches_number() {
        let val: any OSCValueMaskable = AnyOSCNumberValue(123)
        let valType: OSCValueToken = .number
        
        // includingOpaque: false
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType:
                XCTAssertTrue(val.oscValueToken.isBaseType(matching: token))
            default:
                XCTAssertFalse(val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        OSCValueToken.allCases.forEach { token in
            switch token {
            case valType, .number:
                XCTAssertTrue(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                XCTAssertFalse(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
}

#endif
