//
//  OSCServer Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
@testable import OSCKit

final class OSCServer_Tests: XCTestCase {
    func testEmptyBundle() async throws {
        let server = OSCServer()
        
        let exp = expectation(description: "Message Dispatched")
        exp.isInverted = true // empty bundle produces no messages
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle()
        
        try await server.handle(payload: bundle)
        
        await fulfillment(of: [exp], timeout: 1.0)
    }
}

#endif
