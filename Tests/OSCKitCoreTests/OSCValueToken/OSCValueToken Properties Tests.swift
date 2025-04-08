//
//  OSCValueToken Properties Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCValueToken_Properties_Tests {
    // MARK: - baseType
    
    @Test(arguments: OSCValueToken.allCases)
    func baseType(token: OSCValueToken) {
        switch token {
        // concrete types
        
        // -- core types
        case .blob:                 #expect(token.baseType == .blob)
        case .float32:              #expect(token.baseType == .float32)
        case .int32:                #expect(token.baseType == .int32)
        case .string:               #expect(token.baseType == .string)
        // -- extended types
        case .array:                #expect(token.baseType == .array)
        case .bool:                 #expect(token.baseType == .bool)
        case .character:            #expect(token.baseType == .character)
        case .double:               #expect(token.baseType == .double)
        case .int64:                #expect(token.baseType == .int64)
        case .impulse:              #expect(token.baseType == .impulse)
        case .midi:                 #expect(token.baseType == .midi)
        case .null:                 #expect(token.baseType == .null)
        case .stringAlt:            #expect(token.baseType == .stringAlt)
        case .timeTag:              #expect(token.baseType == .timeTag)
        // -- opaque types
        case .number:               #expect(token.baseType == .number)
        case .numberOrBool:         #expect(token.baseType == .numberOrBool)
        // optional versions of concrete types
        // -- core types
        case .blobOptional:         #expect(token.baseType == .blob)
        case .float32Optional:      #expect(token.baseType == .float32)
        case .int32Optional:        #expect(token.baseType == .int32)
        case .stringOptional:       #expect(token.baseType == .string)
        // -- extended types
        case .arrayOptional:        #expect(token.baseType == .array)
        case .boolOptional:         #expect(token.baseType == .bool)
        case .characterOptional:    #expect(token.baseType == .character)
        case .doubleOptional:       #expect(token.baseType == .double)
        case .int64Optional:        #expect(token.baseType == .int64)
        case .impulseOptional:      #expect(token.baseType == .impulse)
        case .midiOptional:         #expect(token.baseType == .midi)
        case .nullOptional:         #expect(token.baseType == .null)
        case .stringAltOptional:    #expect(token.baseType == .stringAlt)
        case .timeTagOptional:      #expect(token.baseType == .timeTag)
        // -- opaque types
        case .numberOptional:       #expect(token.baseType == .number)
        case .numberOrBoolOptional: #expect(token.baseType == .numberOrBool)
        }
    }
    
    // MARK: - isOptional
    
    @Test(arguments: OSCValueToken.allCases)
    func IsOptional(token: OSCValueToken) {
        switch token {
        // optional versions of concrete types
        
        // -- core types
        case .blobOptional:         #expect(token.isOptional)
        case .float32Optional:      #expect(token.isOptional)
        case .int32Optional:        #expect(token.isOptional)
        case .stringOptional:       #expect(token.isOptional)
        // -- extended types
        case .arrayOptional:        #expect(token.isOptional)
        case .boolOptional:         #expect(token.isOptional)
        case .characterOptional:    #expect(token.isOptional)
        case .doubleOptional:       #expect(token.isOptional)
        case .int64Optional:        #expect(token.isOptional)
        case .impulseOptional:      #expect(token.isOptional)
        case .midiOptional:         #expect(token.isOptional)
        case .nullOptional:         #expect(token.isOptional)
        case .stringAltOptional:    #expect(token.isOptional)
        case .timeTagOptional:      #expect(token.isOptional)
        // -- opaque types
        case .numberOptional:       #expect(token.isOptional)
        case .numberOrBoolOptional: #expect(token.isOptional)
        default:                    #expect(!token.isOptional)
        }
    }
}
