//
//  OSCImpulseValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import Testing

@Suite struct OSCImpulseValue_Tests {
    // MARK: - `any OSCValue` Constructors
    
    @Test func oscValue_impulse() {
        let val: any OSCValue = .impulse
        #expect(val as? OSCImpulseValue == OSCImpulseValue())
    }
}
