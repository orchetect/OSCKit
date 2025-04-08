//
//  OSCValueToken Methods Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCValueTokenMethods_Tests {
    // MARK: - OSCValueToken.isBaseType(matching:)
    
    // MARK: ... Core types
    
    @Test
    func baseTypeMatches_blob() {
        let val: any OSCValue = Data([1, 2, 3])
        let valType: OSCValueToken = .blob
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_float32() {
        let val: any OSCValue = Float32(123.45)
        let valType: OSCValueToken = .float32
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType, .number, .numberOrBool:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_int32() {
        let val: any OSCValue = Int32(123)
        let valType: OSCValueToken = .int32
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType, .number, .numberOrBool:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_string() {
        let val: any OSCValue = String("A string")
        let valType: OSCValueToken = .string
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    // MARK: ... Extended types
    
    @Test
    func baseTypeMatches_array() {
        let val: any OSCValue = OSCArrayValue([Int32(123)])
        let valType: OSCValueToken = .array
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_bool() {
        let val: any OSCValue = true
        let valType: OSCValueToken = .bool
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType, .numberOrBool:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_character() {
        let val: any OSCValue = Character("A")
        let valType: OSCValueToken = .character
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_double() {
        let val: any OSCValue = Double(456.78)
        let valType: OSCValueToken = .double
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType, .number, .numberOrBool:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_int64() {
        let val: any OSCValue = Int64(456)
        let valType: OSCValueToken = .int64
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType, .number, .numberOrBool:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_impulse() {
        let val: any OSCValue = OSCImpulseValue()
        let valType: OSCValueToken = .impulse
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_midi() {
        let val: any OSCValue = OSCMIDIValue(portID: 0x00, status: 0x00, data1: 0x00, data2: 0x00)
        let valType: OSCValueToken = .midi
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_null() {
        let val: any OSCValue = OSCNullValue()
        let valType: OSCValueToken = .null
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_stringAlt() {
        let val: any OSCValue = OSCStringAltValue("An alt string")
        let valType: OSCValueToken = .stringAlt
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    @Test
    func baseTypeMatches_timeTag() {
        let val: any OSCValue = OSCTimeTag(.init(456))
        let valType: OSCValueToken = .timeTag
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(val.oscValueToken.isBaseType(matching: token))
            default:
                #expect(!val.oscValueToken.isBaseType(matching: token), "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            switch token {
            case valType:
                #expect(
                    val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true)
                )
            default:
                #expect(
                    !val.oscValueToken
                        .isBaseType(matching: token, includingOpaque: true),
                    "\(token)"
                )
            }
        }
    }
    
    // MARK: ... Opaque types
    
    /// `AnyOSCNumberValue` will always carry the OSC value token `numberOrBool`, which means
    /// the `includingOpaque` parameter will have no effect.
    /// 
    /// Note that even though `Int32` is a core OSC type, it's still type-erased here.
    @Test(
        arguments: [
            AnyOSCNumberValue(Int(123)),
            AnyOSCNumberValue(Int32(456)),
            AnyOSCNumberValue(Double(150.5)),
            AnyOSCNumberValue(Bool(true))
        ]
    )
    func baseTypeMatches_numberOrBool(val: AnyOSCNumberValue) async {
        #expect(val.oscValueToken == .numberOrBool)
        
        // includingOpaque: false
        for token in OSCValueToken.allCases {
            let result = val.oscValueToken.isBaseType(matching: token)
            
            switch token {
            case .numberOrBool:
                #expect(result, "\(token)")
            default:
                #expect(!result, "\(token)")
            }
        }
        
        // includingOpaque: true
        for token in OSCValueToken.allCases {
            let result = val.oscValueToken.isBaseType(matching: token, includingOpaque: true)
            
            switch token {
            case .numberOrBool:
                #expect(result, "\(token)")
            default:
                #expect(!result, "\(token)")
            }
        }
    }
}
