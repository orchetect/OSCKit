//
//  OSCStringAltValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import Testing

@Suite struct OSCStringAltValue_Tests {
    // MARK: - `any OSCValue` Constructors
    
    @Test
    func anyOSCValue_stringAlt() {
        let val: any OSCValue = .stringAlt("A string")
        #expect(val as? OSCStringAltValue == OSCStringAltValue("A string"))
    }
    
    // MARK: - Equatable Operators
    
    @Test
    func equatable() {
        let stringAlt1 = OSCStringAltValue("A string")
        let stringAlt2 = OSCStringAltValue("A string")
        
        #expect(stringAlt1 == stringAlt2)
        #expect(stringAlt2 == stringAlt1)
        
        #expect(!(stringAlt1 != stringAlt2))
        #expect(!(stringAlt2 != stringAlt1))
    }
    
    @Test
    func equatableWithString() {
        let string = "A string"
        let stringAlt = OSCStringAltValue(string)
        
        #expect(string == stringAlt)
        #expect(stringAlt == string)
        
        #expect(!(string != stringAlt))
        #expect(!(stringAlt != string))
    }
}
