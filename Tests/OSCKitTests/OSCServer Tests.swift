//
//  OSCServer Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@testable import OSCKit
import Testing

@Suite struct OSCServer_Tests {
    @Test func emptyBundle() async throws {
        try await confirmation(expectedCount: 0) { confirmation in
            let server = OSCServer()
            
            await server.setHandler { _, _ in
                confirmation()
            }
            
            let bundle = OSCBundle()
            
            await server._handle(payload: bundle)
            
            try await Task.sleep(seconds: 1)
        }
    }
}

#endif
