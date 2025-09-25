//
//  OSCTimeTag OSC 1.0 Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@testable import OSCKit
import Testing

@Suite struct OSCTimeTag_OSC1_0_Tests {
    @Test
    func defaultTimeTag() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCUDPServer(timeTagMode: .osc1_0)
            
            server.setReceiveHandler { _, _, _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                [.message("/test", values: [Int32(123)])]
            )
            
            server._handle(packet: .bundle(bundle), remoteHost: "localhost", remotePort: 8000)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
    
    @Test
    func immediate() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCUDPServer(timeTagMode: .osc1_0)
            
            server.setReceiveHandler { _, _, _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .immediate(),
                [.message("/test", values: [Int32(123)])]
            )
            
            server._handle(packet: .bundle(bundle), remoteHost: "localhost", remotePort: 8000)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
    
    @Test
    func now() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCUDPServer(timeTagMode: .osc1_0)
            
            server.setReceiveHandler { _, _, _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .now(),
                [.message("/test", values: [Int32(123)])]
            )
            
            server._handle(packet: .bundle(bundle), remoteHost: "localhost", remotePort: 8000)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
    
    /// Tests that a message with a time-tag of 1 second in the future does not arrive early.
    @Test(.enabled(if: isSystemTimingStable()))
    func oneSecondInFuture_Early() async throws {
        try await confirmation(expectedCount: 0) { confirmation in
            let server = OSCUDPServer(timeTagMode: .osc1_0)
            
            server.setReceiveHandler { _, _, _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .timeIntervalSinceNow(1.0), // 1 second in future
                [.message("/test", values: [Int32(123)])]
            )
            
            server._handle(packet: .bundle(bundle), remoteHost: "localhost", remotePort: 8000)
            
            try await Task.sleep(seconds: 0.9) // just under 1 second
        }
    }
    
    // TODO: this test can be flakey when run on CI systems because it is time-sensitive
    /// Tests that a message with a time-tag of 1 second in the future arrives after its intended scheduled time.
    @Test(.enabled(if: isSystemTimingStable()))
    func oneSecondInFuture_OnTimeOrThereafter() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCUDPServer(timeTagMode: .osc1_0)
            
            server.setReceiveHandler { _, _, _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .timeIntervalSinceNow(1.0),
                [.message("/test", values: [Int32(123)])]
            )
            
            server._handle(packet: .bundle(bundle), remoteHost: "localhost", remotePort: 8000)
            
            // Note: this may be flaky on slow CI systems
            try await Task.sleep(seconds: 1.1) // just over 1 second
        }
    }
    
    @Test
    func past() async throws {
        try await confirmation(expectedCount: 1) { confirmation in
            let server = OSCUDPServer(timeTagMode: .osc1_0)
            
            server.setReceiveHandler { _, _, _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle(
                timeTag: .timeIntervalSinceNow(-1.0),
                [.message("/test", values: [Int32(123)])]
            )
            
            server._handle(packet: .bundle(bundle), remoteHost: "localhost", remotePort: 8000)
            
            try await Task.sleep(seconds: 0.5)
        }
    }
}

#endif
