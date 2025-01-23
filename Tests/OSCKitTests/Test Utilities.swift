//
//  Test Utilities.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing

func wait(
    expect condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async rethrows {
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try? await Task.sleep(seconds: pollingInterval)
    }
    
    #expect(try await condition(), comment, sourceLocation: sourceLocation)
}

func wait(
    require condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async throws {
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try await Task.sleep(seconds: pollingInterval)
    }
    
    try #require(await condition(), comment, sourceLocation: sourceLocation)
}

/// Use as a condition for individual tests that rely on stable/precise system timing.
func isSystemTimingStable(
    duration: TimeInterval = 0.1,
    tolerance: TimeInterval = 0.01
) -> Bool {
    let durationMS = UInt32(duration * TimeInterval(USEC_PER_SEC))
    
    let start = Date()
    usleep(durationMS)
    let end = Date()
    let diff = end.timeIntervalSince(start)
    
    let range = (duration - tolerance) ... (duration + tolerance)
    return range.contains(diff)
}
