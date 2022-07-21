//
//  Dispatcher Utilities Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCAddress_Dispatcher_Utilities_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testNodeSanitizeName() {
        
        let inputName: ASCIIString = #"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 1#2*3,4/5?6[7]8{9}0"#
        let outputName: ASCIIString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        
        XCTAssertEqual(
            OSCAddress.Dispatcher.Node.sanitize(name: inputName),
            outputName
        )
        
    }
    
}

#endif
