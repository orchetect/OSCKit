//
//  OSCTimeTag Static Constructors Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Numerics
import OSCKitCore
import Testing

@Suite struct OSCTimeTag_StaticConstructors_Tests {
    #if os(macOS) || os(iOS)
    let tolerance: TimeInterval = 0.005
    #elseif os(tvOS) || os(watchOS)
    // allow more time variance for CI pipeline to de-flake
    let tolerance: TimeInterval = 0.01
    #else // linux
    let tolerance: TimeInterval = 0.2
    #endif
    
    // MARK: - Static Constructors
    
    @Test
    func timeTagImmediate() {
        let val: OSCTimeTag = .immediate()
        #expect(val == OSCTimeTag(1))
    }
    
    // MARK: - `any OSCValue` Constructors
    
    @Test
    func oscValue_timeTag() {
        let val: any OSCValue = .timeTag(123, era: 1)
        #expect(val as? OSCTimeTag == OSCTimeTag(123, era: 1))
    }
    
    @Test
    func oscValue_timeTagImmediate() {
        let val: any OSCValue = .timeTagImmediate()
        #expect(val as? OSCTimeTag == OSCTimeTag.immediate())
    }
    
    @Test(.enabled(if: isSystemTimingStable()))
    func oscValue_timeTagNowA() throws {
        // capture time-sensitive variables first
        let now = Date()
        let val: any OSCValue = .timeTagNow()
        
        // perform conversions
        let nowTI = now.timeIntervalSince(primeEpoch)
        let valTI = try #require((val as? OSCTimeTag)?.timeInterval(since: primeEpoch))
        
        #expect(valTI.isApproximatelyEqual(to: nowTI, absoluteTolerance: tolerance))
    }
    
    @Test(.enabled(if: isSystemTimingStable()))
    func oscValue_timeTagNowB() throws {
        // capture time-sensitive variables first
        let now = Date()
        let val: OSCTimeTag = .now()
        
        // perform conversions
        let nowTI = now.timeIntervalSince(primeEpoch)
        let valTI = val.timeInterval(since: primeEpoch)
        
        #expect(valTI.isApproximatelyEqual(to: nowTI, absoluteTolerance: tolerance))
    }
    
    @Test(.enabled(if: isSystemTimingStable()))
    func oscValue_timeTagTimeIntervalSinceNowA() throws {
        // capture time-sensitive variables first
        var now = Date()
        let val: any OSCValue = .timeTag(timeIntervalSinceNow: 5.0)
        now = now.addingTimeInterval(5.0)
        
        // perform conversions
        let nowTI = now.timeIntervalSince(primeEpoch)
        let valTI = try #require((val as? OSCTimeTag)?.timeInterval(since: primeEpoch))
        
        #expect(valTI.isApproximatelyEqual(to: nowTI, absoluteTolerance: tolerance))
    }
    
    @Test(.enabled(if: isSystemTimingStable()))
    func oscValue_timeTagTimeIntervalSinceNowB() throws {
        // capture time-sensitive variables first
        var now = Date()
        let val = OSCTimeTag(timeIntervalSinceNow: 5.0)
        now = now.addingTimeInterval(5.0)
        
        // perform conversions
        let nowTI = now.timeIntervalSince(primeEpoch)
        let valTI = val.timeInterval(since: primeEpoch)
        
        #expect(valTI.isApproximatelyEqual(to: nowTI, absoluteTolerance: tolerance))
    }
    
    @Test
    func oscValue_timeTagTimeIntervalSince1900() {
        let val: any OSCValue = .timeTag(timeIntervalSince1900: 9_467_107_200.0)
        #expect(val as? OSCTimeTag == OSCTimeTag(timeIntervalSince1900: 9_467_107_200.0))
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6, *)
    @Test
    func oscValue_timeTagFuture() {
        let futureDate = Date().advanced(by: 200.0)
        let val: any OSCValue = .timeTag(future: futureDate)
        #expect(val as? OSCTimeTag == OSCTimeTag(future: futureDate))
    }
}

// MARK: - Helpers

/// NTP prime epoch, a.k.a. era 0.
private let primeEpoch: Date = DateComponents(
    calendar: .current,
    timeZone: .current,
    year: 1900,
    month: 1,
    day: 1,
    hour: 0,
    minute: 0,
    second: 0
).date!
