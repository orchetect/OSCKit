//
//  OSCTimeTag OSC 1.0 Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCTimeTag_OSC1_0_Tests: XCTestCase {
    func testDefault() throws {
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            [.message("/test", values: [Int32(123)])]
        )
        
        try server.handle(payload: bundle)
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func testImmediate() throws {
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            timeTag: .immediate(),
            [.message("/test", values: [Int32(123)])]
        )
        
        try server.handle(payload: bundle)
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func testNow() throws {
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            timeTag: .now(),
            [.message("/test", values: [Int32(123)])]
        )
        
        try server.handle(payload: bundle)
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test1SecondInFuture() throws {
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
        
        try server.handle(payload: bundle)
        
        wait(for: [expEarly], timeout: 0.99)
        wait(for: [exp], timeout: 0.5)
    }
    
    func testPast() throws {
        let server = OSCServer(timeTagMode: .osc1_0)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _, _ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            timeTag: .timeIntervalSinceNow(-1.0),
            [.message("/test", values: [Int32(123)])]
        )
        
        try server.handle(payload: bundle)
        
        wait(for: [exp], timeout: 0.5)
    }
}

#endif
