//
//  OSCServer Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import OSCKit

final class OSCServer_Tests: XCTestCase {
    func testEmptyBundle() throws {
        let del = OSCServerDelegate()
        
        let exp = expectation(description: "Message Dispatched")
        exp.isInverted = true // empty bundle produces no messages
        
        del.handler = { oscMessage in
            exp.fulfill()
        }
        
        let bundle = OSCBundle(elements: [])
        let payload: OSCPayload = .bundle(bundle)
        
        try del.handle(payload: payload)
        
        wait(for: [exp], timeout: 1.0)
    }
}

#endif
