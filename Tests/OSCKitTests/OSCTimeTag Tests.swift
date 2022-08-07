//
//  OSCTimeTag Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCTimeTag_Tests: XCTestCase {
    func testDefault() throws {
        let del = OSCServerDelegate()
        
        let exp = expectation(description: "Message Dispatched")
        
        del.handler = { oscMessage in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ]
        )
        
        try del.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func testImmediate() throws {
        let del = OSCServerDelegate()
        
        let exp = expectation(description: "Message Dispatched")
        
        del.handler = { oscMessage in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ],
            timeTag: .immediate()
        )
        
        try del.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func testNow() throws {
        let del = OSCServerDelegate()
        
        let exp = expectation(description: "Message Dispatched")
        
        del.handler = { oscMessage in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ],
            timeTag: .now()
        )
        
        try del.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
    }
    
    func test1SecondInFuture() throws {
        let del = OSCServerDelegate()
        
        let expEarly = expectation(description: "Message Dispatched Early")
        expEarly.isInverted = true
        
        let exp = expectation(description: "Message Dispatched")
        
        del.handler = { oscMessage in
            expEarly.fulfill()
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ],
            timeTag: .timeIntervalSinceNow(1.0)
        )
        
        try del.handle(payload: .bundle(bundle))
        
        wait(for: [expEarly], timeout: 0.99)
        wait(for: [exp], timeout: 0.5)
    }
    
    func testPast() throws {
        let del = OSCServerDelegate()
        
        let exp = expectation(description: "Message Dispatched")
        
        del.handler = { oscMessage in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(
            elements: [
                .message(OSCMessage(address: "/test", values: [.int32(123)]))
            ],
            timeTag: .timeIntervalSinceNow(-1.0)
        )
        
        try del.handle(payload: .bundle(bundle))
        
        wait(for: [exp], timeout: 0.5)
    }
}

#endif
