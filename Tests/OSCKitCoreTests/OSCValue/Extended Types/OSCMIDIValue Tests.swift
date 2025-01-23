//
//  OSCMIDIValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import Testing

@Suite struct OSCMIDIValue_Tests {
    // MARK: - `any OSCValue` Constructors
    
    @Test
    func oscValue_midi() {
        let val: any OSCValue = .midi(portID: 0x01, status: 0x90, data1: 0x02, data2: 0x03)
        #expect(
            val as? OSCMIDIValue ==
                OSCMIDIValue(portID: 0x01, status: 0x90, data1: 0x02, data2: 0x03)
        )
    }
}
