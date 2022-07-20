//
//  Value Masks Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit
import OTCore
import SwiftASCII

final class ValueMasks_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    
    // MARK: - OSCMessage.ValueMask.Token
    
    func testOSCMessage_MaskType_BaseType() {
        
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
                
                // concrete types
                
                // -- core types
            case .int32:                XCTAssertEqual(valueType.baseType, .int32)
            case .float32:              XCTAssertEqual(valueType.baseType, .float32)
            case .string:               XCTAssertEqual(valueType.baseType, .string)
            case .blob:                 XCTAssertEqual(valueType.baseType, .blob)
                
                // -- extended types
            case .int64:                XCTAssertEqual(valueType.baseType, .int64)
            case .timeTag:              XCTAssertEqual(valueType.baseType, .timeTag)
            case .double:               XCTAssertEqual(valueType.baseType, .double)
            case .stringAlt:            XCTAssertEqual(valueType.baseType, .stringAlt)
            case .character:            XCTAssertEqual(valueType.baseType, .character)
            case .midi:                 XCTAssertEqual(valueType.baseType, .midi)
            case .bool:                 XCTAssertEqual(valueType.baseType, .bool)
            case .null:                 XCTAssertEqual(valueType.baseType, .null)
                
                // "meta" types
                
            case .number:               XCTAssertEqual(valueType.baseType, .number)
                
                // optional versions of concrete types
                
                // -- core types
            case .int32Optional:        XCTAssertEqual(valueType.baseType, .int32)
            case .float32Optional:      XCTAssertEqual(valueType.baseType, .float32)
            case .stringOptional:       XCTAssertEqual(valueType.baseType, .string)
            case .blobOptional:         XCTAssertEqual(valueType.baseType, .blob)
                
                // -- extended types
            case .int64Optional:        XCTAssertEqual(valueType.baseType, .int64)
            case .timeTagOptional:      XCTAssertEqual(valueType.baseType, .timeTag)
            case .doubleOptional:       XCTAssertEqual(valueType.baseType, .double)
            case .stringAltOptional:    XCTAssertEqual(valueType.baseType, .stringAlt)
            case .characterOptional:    XCTAssertEqual(valueType.baseType, .character)
            case .midiOptional:         XCTAssertEqual(valueType.baseType, .midi)
            case .boolOptional:         XCTAssertEqual(valueType.baseType, .bool)
            case .nullOptional:         XCTAssertEqual(valueType.baseType, .null)
                
                // -- meta types
                
            case .numberOptional:       XCTAssertEqual(valueType.baseType, .number)
                
            }
        }
    }
    
    func testOSCMessage_MaskType_IsOptional() {
        
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
                
                // optional versions of concrete types
                
                // -- core types
            case .int32Optional:        XCTAssertEqual(valueType.isOptional, true)
            case .float32Optional:      XCTAssertEqual(valueType.isOptional, true)
            case .stringOptional:       XCTAssertEqual(valueType.isOptional, true)
            case .blobOptional:         XCTAssertEqual(valueType.isOptional, true)
                
                // -- extended types
            case .int64Optional:        XCTAssertEqual(valueType.isOptional, true)
            case .timeTagOptional:      XCTAssertEqual(valueType.isOptional, true)
            case .doubleOptional:       XCTAssertEqual(valueType.isOptional, true)
            case .stringAltOptional:    XCTAssertEqual(valueType.isOptional, true)
            case .characterOptional:    XCTAssertEqual(valueType.isOptional, true)
            case .midiOptional:         XCTAssertEqual(valueType.isOptional, true)
            case .boolOptional:         XCTAssertEqual(valueType.isOptional, true)
            case .nullOptional:         XCTAssertEqual(valueType.isOptional, true)
                
                // -- meta types
                
            case .numberOptional:       XCTAssertEqual(valueType.isOptional, true)
                
            default:                    XCTAssertEqual(valueType.isOptional, false)
                
            }
        }
        
    }
    
    
    // MARK: - OSCMessageValue.baseTypeMatches
    
    // MARK: - Core types
    
    func testBaseTypeMatches_int32() {
        
        let val = OSCMessageValue.int32(123)
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .int32:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .int32, .number:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_float32() {
        
        let val = OSCMessageValue.float32(123.45)
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .float32:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .float32, .number:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_string() {
        
        let val = OSCMessageValue.string("A string")
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .string: XCTAssertTrue (val.baseTypeMatches(type: valueType))
            default: XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .string:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_blob() {
        
        let val = OSCMessageValue.blob(Data([1,2,3]))
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .blob:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .blob:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    
    // MARK: - Extended types
    
    func testBaseTypeMatches_int64() {
        
        let val = OSCMessageValue.int64(456)
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .int64:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .int64, .number:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_timeTag() {
        
        let val = OSCMessageValue.timeTag(456)
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .timeTag:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .timeTag:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_double() {
        
        let val = OSCMessageValue.double(456.78)
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .double:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .double, .number:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_stringAlt() {
        
        let val = OSCMessageValue.stringAlt("An alt string")
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .stringAlt:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .stringAlt:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_character() {
        
        let val = OSCMessageValue.character("A")
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .character:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .character:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_midi() {
        
        let val = OSCMessageValue.midi(portID: 0x00, status: 0x00, data1: 0x00, data2: 0x00)
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .midi:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .midi:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_bool() {
        
        let val = OSCMessageValue.bool(true)
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .bool:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .bool:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    func testBaseTypeMatches_null() {
        
        let val = OSCMessageValue.null
        
        // canMatchMetaTypes: false
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .null:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.ValueMask.Token.allCases.forEach { valueType in
            switch valueType {
            case .null:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    
    // MARK: - [].matchesValueMask
    
    func testMatchesValueMask1() {
        
        let mask: [OSCMessage.ValueMask.Token] = [.int32]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
            .matches(mask: mask))
        
        // fail - empty values array
        XCTAssertFalse([OSCMessageValue]()
            .matches(mask: mask))
        
        // fail - wrong type
        XCTAssertFalse([OSCMessageValue]([.int64(123)])
            .matches(mask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
            .matches(mask: mask))
        
    }
    
    func testMatchesValueMask2() {
        
        let mask: [OSCMessage.ValueMask.Token] = [.int32Optional]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
            .matches(mask: mask))
        
        // success - value was optional
        XCTAssertTrue([OSCMessageValue]()
            .matches(mask: mask))
        
        // fail - wrong type
        XCTAssertFalse([OSCMessageValue]([.int64(123)])
            .matches(mask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
            .matches(mask: mask))
        
    }
    
    func testMatchesValueMask3() {
        
        let mask: [OSCMessage.ValueMask.Token] = [.number]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
            .matches(mask: mask))
        
        // fail - empty values array
        XCTAssertFalse([OSCMessageValue]()
            .matches(mask: mask))
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int64(123)])
            .matches(mask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
            .matches(mask: mask))
        
    }
    
    func testMatchesValueMask4() {
        
        let mask: [OSCMessage.ValueMask.Token] = [.numberOptional]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
            .matches(mask: mask))
        
        // success - value was optional
        XCTAssertTrue([OSCMessageValue]()
            .matches(mask: mask))
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int64(123)])
            .matches(mask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
            .matches(mask: mask))
        
    }
    
    
    // MARK: - [].valuesFromValueMask Types
    
    // MARK: - Core types
    
    func testValuesFromValueMask_int32() throws {
        
        typealias type                     = Int32
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .int32(value)
        let valueType: OSCMessage.ValueMask.Token = .int32
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_float32() throws {
        
        typealias type                     = Float32
        let value                          = 123.45 as type
        let msgValue:  OSCMessageValue     = .float32(value)
        let valueType: OSCMessage.ValueMask.Token = .float32
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_string() throws {
        
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCMessageValue     = .string(value)
        let valueType: OSCMessage.ValueMask.Token = .string
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_blob() throws {
        
        typealias type                     = Data
        let value                          = Data([1,2,3]) as type
        let msgValue:  OSCMessageValue     = .blob(value)
        let valueType: OSCMessage.ValueMask.Token = .blob
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    // MARK: - Extended types
    
    func testValuesFromValueMask_int64() throws {
        
        typealias type                     = Int64
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .int64(value)
        let valueType: OSCMessage.ValueMask.Token = .int64
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_timeTag() throws {
        
        typealias type                     = Int64
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .timeTag(value)
        let valueType: OSCMessage.ValueMask.Token = .timeTag
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_double() throws {
        
        typealias type                     = Double
        let value                          = 123.45 as type
        let msgValue:  OSCMessageValue     = .double(value)
        let valueType: OSCMessage.ValueMask.Token = .double
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_stringAlt() throws {
        
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCMessageValue     = .stringAlt(value)
        let valueType: OSCMessage.ValueMask.Token = .stringAlt
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_character() throws {
        
        typealias type                     = ASCIICharacter
        let value                          = "A" as type
        let msgValue:  OSCMessageValue     = .character(value)
        let valueType: OSCMessage.ValueMask.Token = .character
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_midi() throws {
        
        typealias type                     = OSCMessageValue.MIDIMessage
        let value = OSCMessageValue.MIDIMessage(
            portID: 0x00, status: 0x80, data1: 0x50, data2: 0x40
        ) as type
        let msgValue:  OSCMessageValue     = .midi(value)
        let valueType: OSCMessage.ValueMask.Token = .midi
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_bool() throws {
        
        typealias type                     = Bool
        let value                          = true as type
        let msgValue:  OSCMessageValue     = .bool(value)
        let valueType: OSCMessage.ValueMask.Token = .bool
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    func testValuesFromValueMask_null() throws {
        
        typealias type                     = NSObject
        let value                          = NSNull() as type
        let msgValue:  OSCMessageValue     = .null
        let valueType: OSCMessage.ValueMask.Token = .null
        
        let result = try [OSCMessageValue]([msgValue])
            .values(mask: [valueType])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0] as? type, value)
        
    }
    
    // MARK: - [].valuesFromValueMask Mask
    
    func testValuesFromValueMask1() throws {
        
        let mask: [OSCMessage.ValueMask.Token] = [.int32]
        
        // success
        let result1 = try [OSCMessageValue]([.int32(123)])
            .values(mask: mask)
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0] as? Int32, 123)
        
        // fail - empty values array
        let result2 = try? [OSCMessageValue]([])
            .values(mask: mask)
        XCTAssertNil(result2)
        
        // fail - wrong type
        let result3 = try? [OSCMessageValue]([.int64(123)])
            .values(mask: mask)
        XCTAssertNil(result3)
        
        // fail - matches but too many values
        let result4 = try? [OSCMessageValue]([.int32(123), .int32(123)])
            .values(mask: mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask2() throws {
        
        let mask: [OSCMessage.ValueMask.Token] = [.int32Optional]
        
        // success
        let result1 = try [OSCMessageValue]([.int32(123)])
            .values(mask: mask)
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0] as? Int32, 123)
        
        // success - value was optional
        let result2 = try [OSCMessageValue]([])
            .values(mask: mask)
        XCTAssertEqual(result2.count, 1)
        XCTAssertNil(result2[0] as? Int32) // array containing a nil
        
        // fail - wrong type
        let result3 = try? [OSCMessageValue]([.int64(123)])
            .values(mask: mask)
        XCTAssertNil(result3)
        
        // fail - matches but too many values
        let result4 = try? [OSCMessageValue]([.int32(123), .int32(123)])
            .values(mask: mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask3() throws {
        
        let mask: [OSCMessage.ValueMask.Token] = [.number]
        
        // success
        let result1 = try [OSCMessageValue]([.int32(123)])
            .values(mask: mask)
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0] as? Int32, 123)
        
        // fail - empty values array
        let result2 = try? [OSCMessageValue]([])
            .values(mask: mask)
        XCTAssertNil(result2)
        
        // success
        let result3 = try [OSCMessageValue]([.int64(123)])
            .values(mask: mask)
        XCTAssertEqual(result3.count, 1)
        XCTAssertEqual(OSCMessageValue.numberAsInt(result3[0]!), 123)
        
        // fail - matches but too many values
        let result4 = try? [OSCMessageValue]([.int32(123), .int32(123)])
            .values(mask: mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask4() throws {
        
        let mask: [OSCMessage.ValueMask.Token] = [.numberOptional]
        
        // success
        let result1 = try [OSCMessageValue]([.int32(123)])
            .values(mask: mask)
        XCTAssertEqual(result1.count, 1)
        XCTAssertEqual(result1[0] as? Int32, 123)
        
        // success - value was optional
        let result2 = try [OSCMessageValue]([])
            .values(mask: mask)
        XCTAssertEqual(result2.count, 1)
        XCTAssertNil(result2[0] as? Int32) // array containing a nil
        
        // success
        let result3 = try [OSCMessageValue]([.int64(123)])
            .values(mask: mask)
        XCTAssertEqual(result3.count, 1)
        XCTAssertEqual(OSCMessageValue.numberAsInt(result3[0]!), 123)
        
        // fail - matches but too many values
        let result4 = try? [OSCMessageValue]([.int32(123), .int32(123)])
            .values(mask: mask)
        XCTAssertNil(result4)
        
    }
    
}

#endif
