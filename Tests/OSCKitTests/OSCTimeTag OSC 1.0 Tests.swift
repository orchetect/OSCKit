//
//  OSCTimeTag OSC 1.0 Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import XCTest
@testable import OSCKit

final class OSCTimeTag_OSC1_0_Tests: XCTestCase {
    func testDefault() async throws {
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            [.message("/test", values: [Int32(123)])]
        )
        
        try await server.handle(payload: bundle)
        
        await fulfillment(of: [exp], timeout: 0.5)
    }
    
    func testImmediate() async throws {
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            timeTag: .immediate(),
            [.message("/test", values: [Int32(123)])]
        )
        
        try await server.handle(payload: bundle)
        
        await fulfillment(of: [exp], timeout: 0.5)
    }
    
    func testNow() async throws {
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            timeTag: .now(),
            [.message("/test", values: [Int32(123)])]
        )
        
        try await server.handle(payload: bundle)
        
        await fulfillment(of: [exp], timeout: 0.5)
    }
    
    func test1SecondInFuture() async throws {
        try XCTSkipIfRunningOnCI()
        
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let expEarly = expectation(description: "Message Dispatched Early")
        expEarly.isInverted = true
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            expEarly.fulfill()
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            timeTag: .timeIntervalSinceNow(1.0),
            [.message("/test", values: [Int32(123)])]
        )
        
        try await server.handle(payload: bundle)
        
        // Note: this may be flaky on slow CI systems
        await fulfillment(of: [expEarly], timeout: 0.9)
        await fulfillment(of: [exp], timeout: 0.5)
    }
    
    func testPast() async throws {
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            timeTag: .timeIntervalSinceNow(-1.0),
            [.message("/test", values: [Int32(123)])]
        )
        
        try await server.handle(payload: bundle)
        
        await fulfillment(of: [exp], timeout: 0.5)
    }
}

#endif
