//
//  OSCKitTests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OSCKit

final class OSCKitTests: XCTestCase {
    // empty
}

extension XCTestCase {
    func XCTSkipIfRunningOnCI() throws {
        if ProcessInfo.processInfo.environment["RUNNING_ON_CI"] != nil {
            throw XCTSkip("Skipping test on CI.")
        }
    }
}
