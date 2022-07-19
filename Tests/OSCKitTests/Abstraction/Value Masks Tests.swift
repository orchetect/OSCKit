//
//  Value Masks Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit
import OTCore
import SwiftASCII

final class ValueMasksTests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    
    // MARK: - OSCMessage.MaskType
    
    func testOSCMessage_MaskType_BaseType() {
        
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        
        OSCMessage.MaskType.allCases.forEach { valueType in
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
    
    // MARK: -- Core types
    
    func testBaseTypeMatches_int32() {
        
        let val = OSCMessageValue.int32(123)
        
        // canMatchMetaTypes: false
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .int32:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .float32:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .string: XCTAssertTrue (val.baseTypeMatches(type: valueType))
            default: XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .blob:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .blob:
                XCTAssertTrue(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType, canMatchMetaTypes: true))
            }
        }
        
    }
    
    
    // MARK: -- Extended types
    
    func testBaseTypeMatches_int64() {
        
        let val = OSCMessageValue.int64(456)
        
        // canMatchMetaTypes: false
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .int64:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .timeTag:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .double:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .stringAlt:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .character:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .midi:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .bool:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        OSCMessage.MaskType.allCases.forEach { valueType in
            switch valueType {
            case .null:
                XCTAssertTrue(val.baseTypeMatches(type: valueType))
            default:
                XCTAssertFalse(val.baseTypeMatches(type: valueType))
            }
        }
        
        // canMatchMetaTypes: true
        OSCMessage.MaskType.allCases.forEach { valueType in
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
        
        let mask: [OSCMessage.MaskType] = [.int32]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
                        .matchesValueMask(expectedMask: mask))
        
        // fail - empty values array
        XCTAssertFalse([OSCMessageValue]()
                        .matchesValueMask(expectedMask: mask))
        
        // fail - wrong type
        XCTAssertFalse([OSCMessageValue]([.int64(123)])
                        .matchesValueMask(expectedMask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
                        .matchesValueMask(expectedMask: mask))
        
    }
    
    func testMatchesValueMask2() {
        
        let mask: [OSCMessage.MaskType] = [.int32Optional]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
                        .matchesValueMask(expectedMask: mask))
        
        // success - value was optional
        XCTAssertTrue([OSCMessageValue]()
                        .matchesValueMask(expectedMask: mask))
        
        // fail - wrong type
        XCTAssertFalse([OSCMessageValue]([.int64(123)])
                        .matchesValueMask(expectedMask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
                        .matchesValueMask(expectedMask: mask))
        
    }
    
    func testMatchesValueMask3() {
        
        let mask: [OSCMessage.MaskType] = [.number]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
                        .matchesValueMask(expectedMask: mask))
        
        // fail - empty values array
        XCTAssertFalse([OSCMessageValue]()
                        .matchesValueMask(expectedMask: mask))
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int64(123)])
                        .matchesValueMask(expectedMask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
                        .matchesValueMask(expectedMask: mask))
        
    }
    
    func testMatchesValueMask4() {
        
        let mask: [OSCMessage.MaskType] = [.numberOptional]
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int32(123)])
                        .matchesValueMask(expectedMask: mask))
        
        // success - value was optional
        XCTAssertTrue([OSCMessageValue]()
                        .matchesValueMask(expectedMask: mask))
        
        // success
        XCTAssertTrue([OSCMessageValue]([.int64(123)])
                        .matchesValueMask(expectedMask: mask))
        
        // fail - matches but too many values
        XCTAssertFalse([OSCMessageValue]([.int32(123), .int32(123)])
                        .matchesValueMask(expectedMask: mask))
        
    }
    
    
    // MARK: - [].valuesFromValueMask Types
    
    // MARK: -- Core types
    
    func testValuesFromValueMask_int32() {
        
        typealias type                     = Int32
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .int32(value)
        let valueType: OSCMessage.MaskType = .int32
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_float32() {
        
        typealias type                     = Float32
        let value                          = 123.45 as type
        let msgValue:  OSCMessageValue     = .float32(value)
        let valueType: OSCMessage.MaskType = .float32
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_string() {
        
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCMessageValue     = .string(value)
        let valueType: OSCMessage.MaskType = .string
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_blob() {
        
        typealias type                     = Data
        let value                          = Data([1,2,3]) as type
        let msgValue:  OSCMessageValue     = .blob(value)
        let valueType: OSCMessage.MaskType = .blob
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    // MARK: -- Extended types
    
    func testValuesFromValueMask_int64() {
        
        typealias type                     = Int64
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .int64(value)
        let valueType: OSCMessage.MaskType = .int64
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_timeTag() {
        
        typealias type                     = Int64
        let value                          = 123 as type
        let msgValue:  OSCMessageValue     = .timeTag(value)
        let valueType: OSCMessage.MaskType = .timeTag
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_double() {
        
        typealias type                     = Double
        let value                          = 123.45 as type
        let msgValue:  OSCMessageValue     = .double(value)
        let valueType: OSCMessage.MaskType = .double
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_stringAlt() {
        
        typealias type                     = ASCIIString
        let value                          = "A string" as type
        let msgValue:  OSCMessageValue     = .stringAlt(value)
        let valueType: OSCMessage.MaskType = .stringAlt
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_character() {
        
        typealias type                     = ASCIICharacter
        let value                          = "A" as type
        let msgValue:  OSCMessageValue     = .character(value)
        let valueType: OSCMessage.MaskType = .character
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_midi() {
        
        typealias type                     = OSCMessageValue.MIDIMessage
        let value = OSCMessageValue.MIDIMessage(
            portID: 0x00, status: 0x80, data1: 0x50, data2: 0x40
        ) as type
        let msgValue:  OSCMessageValue     = .midi(value)
        let valueType: OSCMessage.MaskType = .midi
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_bool() {
        
        typealias type                     = Bool
        let value                          = true as type
        let msgValue:  OSCMessageValue     = .bool(value)
        let valueType: OSCMessage.MaskType = .bool
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    func testValuesFromValueMask_null() {
        
        typealias type                     = NSObject
        let value                          = NSNull() as type
        let msgValue:  OSCMessageValue     = .null
        let valueType: OSCMessage.MaskType = .null
        
        let result = [OSCMessageValue]([msgValue])
            .valuesFromValueMask(expectedMask: [valueType])
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?[safe: 0] as? type, value)
        
    }
    
    // MARK: - [].valuesFromValueMask Mask
    
    func testValuesFromValueMask1() {
        
        let mask: [OSCMessage.MaskType] = [.int32]
        
        // success
        let result1 = [OSCMessageValue]([.int32(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertEqual(result1?.count, 1)
        XCTAssertEqual(result1?[safe: 0] as? Int32, 123)
        
        // fail - empty values array
        let result2 = [OSCMessageValue]([])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertNil(result2)
        
        // fail - wrong type
        let result3 = [OSCMessageValue]([.int64(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertNil(result3)
        
        // fail - matches but too many values
        let result4 = [OSCMessageValue]([.int32(123), .int32(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask2() {
        
        let mask: [OSCMessage.MaskType] = [.int32Optional]
        
        // success
        let result1 = [OSCMessageValue]([.int32(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertEqual(result1?.count, 1)
        XCTAssertEqual(result1?[safe: 0] as? Int32, 123)
        
        // success - value was optional
        let result2 = [OSCMessageValue]([])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertEqual(result2?.count, 1)
        XCTAssertNil(result2?[safe: 0] as? Int32) // array containing a nil
        
        // fail - wrong type
        let result3 = [OSCMessageValue]([.int64(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertNil(result3)
        
        // fail - matches but too many values
        let result4 = [OSCMessageValue]([.int32(123), .int32(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask3() {
        
        let mask: [OSCMessage.MaskType] = [.number]
        
        // success
        let result1 = [OSCMessageValue]([.int32(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertEqual(result1?.count, 1)
        XCTAssertEqual(result1?[safe: 0] as? Int32, 123)
        
        // fail - empty values array
        let result2 = [OSCMessageValue]([])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertNil(result2)
        
        // success
        let result3 = [OSCMessageValue]([.int64(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertEqual(result3?.count, 1)
        XCTAssertEqual(OSCMessageValue.numberAsInt(result3?[safe: 0]!), 123)
        
        // fail - matches but too many values
        let result4 = [OSCMessageValue]([.int32(123), .int32(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertNil(result4)
        
    }
    
    func testValuesFromValueMask4() {
        
        let mask: [OSCMessage.MaskType] = [.numberOptional]
        
        // success
        let result1 = [OSCMessageValue]([.int32(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertEqual(result1?.count, 1)
        XCTAssertEqual(result1?[safe: 0] as? Int32, 123)
        
        // success - value was optional
        let result2 = [OSCMessageValue]([])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertEqual(result2?.count, 1)
        XCTAssertNil(result2?[safe: 0] as? Int32) // array containing a nil
        
        // success
        let result3 = [OSCMessageValue]([.int64(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertEqual(result3?.count, 1)
        XCTAssertEqual(OSCMessageValue.numberAsInt(result3?[safe: 0]!), 123)
        
        // fail - matches but too many values
        let result4 = [OSCMessageValue]([.int32(123), .int32(123)])
            .valuesFromValueMask(expectedMask: mask)
        XCTAssertNil(result4)
        
    }
    
}

#endif
