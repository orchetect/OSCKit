//
//  OSCTimeTag OSC 1.1 Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@testable import OSCKit
import Testing

@Suite struct OSCTimeTag_OSC1_1_Tests {
    @Test func defaultTimeTag() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCServer(timeTagMode: .ignore)
            
            await server.setHandler { _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle([
                .message("/test", values: [Int32(123)])
            ])
            
            await server._handle(payload: bundle)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
    
    @Test func immediate() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCServer(timeTagMode: .ignore)
            
            await server.setHandler { _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .immediate(),
                [.message("/test", values: [Int32(123)])]
            )
            
            await server._handle(payload: bundle)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
    
    @Test func now() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCServer(timeTagMode: .ignore)
            
            await server.setHandler { _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .now(),
                [.message("/test", values: [Int32(123)])]
            )
            
            await server._handle(payload: bundle)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
    
    @Test func oneSecondInFuture() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCServer(timeTagMode: .ignore)
            
            await server.setHandler { _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .timeIntervalSinceNow(1.0),
                [.message("/test", values: [Int32(123)])]
            )
            
            await server._handle(payload: bundle)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
    
    @Test func past() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCServer(timeTagMode: .ignore)
            
            await server.setHandler { _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .timeIntervalSinceNow(-1.0),
                [.message("/test", values: [Int32(123)])]
            )
            
            await server._handle(payload: bundle)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
}

#endif
