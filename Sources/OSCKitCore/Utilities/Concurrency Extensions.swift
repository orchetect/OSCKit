//
//  Concurrency Extensions.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2024-10-28.
//

import Foundation

fileprivate let maxSeconds = TimeInterval(UInt64.max / 1_000_000_000)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given duration in seconds.
    package static func sleep(seconds: TimeInterval) async throws {
        // safety check: protect again overflow
        
        let secondsClamped = min(seconds, maxSeconds)
        let nanoseconds = UInt64(secondsClamped * 1_000_000_000)
        
        try await sleep(nanoseconds: nanoseconds)
    }
}
