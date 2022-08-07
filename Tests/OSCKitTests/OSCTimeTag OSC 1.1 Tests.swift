//
//  OSCTimeTag OSC 1.1 Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCTimeTag_OSC1_1_Tests: XCTestCase {
    func testDefault() throws {
        let server = OSCServer(timeTagMode: .ignore)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _,_ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ]
        )
        
        try server.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func testImmediate() throws {
        let server = OSCServer(timeTagMode: .ignore)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _,_ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ],
            timeTag: .immediate()
        )
        
        try server.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func testNow() throws {
        let server = OSCServer(timeTagMode: .ignore)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _,_ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ],
            timeTag: .now()
        )
        
        try server.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test1SecondInFuture() throws {
        let server = OSCServer(timeTagMode: .ignore)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _,_ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ],
            timeTag: .timeIntervalSinceNow(1.0)
        )
        
        try server.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
        
    }
    
    func testPast() throws {
        let server = OSCServer(timeTagMode: .ignore)
        
        let exp = expectation(description: "Message Dispatched")
        
        server.handler = { _,_ in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ],
            timeTag: .timeIntervalSinceNow(-1.0)
        )
        
        try server.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
    }
}

#endif