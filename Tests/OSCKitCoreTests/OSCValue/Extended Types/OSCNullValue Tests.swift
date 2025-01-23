//
//  OSCNullValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import Testing

@Suite struct OSCNullValue_Tests {
    // MARK: - `any OSCValue` Constructors
    
    @Test
    func oscValue_null() {
        let val: any OSCValue = .null
        #expect(val as? OSCNullValue == OSCNullValue())
    }
}
