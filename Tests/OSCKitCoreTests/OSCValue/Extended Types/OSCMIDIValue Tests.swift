//
//  OSCMIDIValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCMIDIValue_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - `any OSCValue` Constructors
    
    func testOSCValue_midi() {
        let val: any OSCValue = .midi(portID: 0x01, status: 0x90, data1: 0x02, data2: 0x03)
        XCTAssertEqual(
            val as? OSCMIDIValue,
            OSCMIDIValue(portID: 0x01, status: 0x90, data1: 0x02, data2: 0x03)
        )
    }
}

#endif
