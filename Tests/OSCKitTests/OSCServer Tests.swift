//
//  OSCServer Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCServer_Tests: XCTestCase {
    func testEmptyBundle() throws {
        let server = OSCServer()
        
        let exp = expectation(description: "Message Dispatched")
        exp.isInverted = true // empty bundle produces no messages
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle()
        
        try server.handle(payload: bundle)
        
        wait(for: [exp], timeout: 1.0)
    }
}

#endif
