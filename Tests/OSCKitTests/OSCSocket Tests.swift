//
//  OSCSocket Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
@testable import OSCKit

final class OSCSocket_Tests: XCTestCase {
    func testEmptyBundle() async throws {
        let server = OSCSocket(remoteHost: "localhost")
        
        let exp = expectation(description: "Message Dispatched")
        exp.isInverted = true // empty bundle produces no messages
        
        await server.setHandler { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle()
        
        await server._handle(payload: bundle)
        
        await fulfillment(of: [exp], timeout: 1.0)
    }
}

#endif
