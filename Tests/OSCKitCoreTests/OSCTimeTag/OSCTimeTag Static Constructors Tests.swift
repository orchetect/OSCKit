//
//  OSCTimeTag Static Constructors Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import Testing
import Numerics

@Suite struct OSCTimeTag_StaticConstructors_Tests {
    // MARK: - Static Constructors
    
    @Test func timeTagImmediate() {
        let val: OSCTimeTag = .immediate()
        #expect(val == OSCTimeTag(1))
    }
    
    // MARK: - `any OSCValue` Constructors
    
    @Test func oscValue_timeTag() {
        let val: any OSCValue = .timeTag(123, era: 1)
        #expect(val as? OSCTimeTag == OSCTimeTag(123, era: 1))
    }
    
    @Test func oscValue_timeTagImmediate() {
        let val: any OSCValue = .timeTagImmediate()
        #expect(val as? OSCTimeTag == OSCTimeTag.immediate())
    }
    
    @Test func oscValue_timeTagNow() throws {
        let val: any OSCValue = .timeTagNow()
        let now = OSCTimeTag.now()
        
        let valTI = try #require((val as? OSCTimeTag)?.timeInterval(since: primeEpoch))
        let nowTI = now.timeInterval(since: primeEpoch)
        #expect(valTI.isApproximatelyEqual(to: nowTI, absoluteTolerance: 0.001))
    }
    
    @Test func oscValue_timeTagTimeIntervalSinceNow() throws {
        let val: any OSCValue = .timeTag(timeIntervalSinceNow: 5.0)
        let now = OSCTimeTag(timeIntervalSinceNow: 5.0)
        
        let valTI = try #require((val as? OSCTimeTag)?.timeInterval(since: primeEpoch))
        let nowTI = now.timeInterval(since: primeEpoch)
        
        #expect(valTI.isApproximatelyEqual(to: nowTI, absoluteTolerance: 0.001))
    }
    
    @Test func oscValue_timeTagTimeIntervalSince1900() {
        let val: any OSCValue = .timeTag(timeIntervalSince1900: 9_467_107_200.0)
        #expect(val as? OSCTimeTag == OSCTimeTag(timeIntervalSince1900: 9_467_107_200.0))
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6, *)
    @Test func oscValue_timeTagFuture() {
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
