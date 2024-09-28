//
//  OSCServerProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore

/// Internal protocol that all objects who act as an OSC server adopt.
/// Provides shared logic.
internal protocol _OSCServerProtocol: AnyObject {
    var timeTagMode: OSCTimeTagMode { get set }
    var handler: OSCHandlerBlock? { get set }
}

// MARK: - Handle and Dispatch

extension _OSCServerProtocol {
    /// Handle incoming OSC data recursively.
    func handle(
        payload: any OSCObject,
        timeTag: OSCTimeTag = .immediate()
    ) async throws {
        switch payload {
        case let bundle as OSCBundle:
            for element in bundle.elements {
                try await handle(payload: element, timeTag: bundle.timeTag)
            }
            
        case let message as OSCMessage:
            await schedule(message, at: timeTag)
            
        default:
            assertionFailure("Unexpected OSCObject type encountered.")
        }
    }
    
    func schedule(
        _ message: OSCMessage,
        at timeTag: OSCTimeTag = .immediate()
    ) async {
        switch timeTagMode {
        case .ignore:
            await dispatch(message, timeTag: timeTag)
            
        case .osc1_0:
            // TimeTag of 1 has special meaning in OSC to dispatch "now".
            if timeTag.isImmediate {
                await dispatch(message, timeTag: timeTag)
                return
            }
            
            // If Time Tag is <= now, dispatch immediately.
            // Otherwise, schedule message for future dispatch.
            guard timeTag.isFuture else {
                await dispatch(message, timeTag: timeTag)
                return
            }
            
            let secondsFromNow = timeTag.timeIntervalSinceNow()
            dispatch(message, timeTag: timeTag, at: secondsFromNow)
        }
    }
    
    func dispatch(_ message: OSCMessage, timeTag: OSCTimeTag) async {
        await self.handler?(message, timeTag)
    }
    
    func dispatch(
        _ message: OSCMessage,
        timeTag: OSCTimeTag,
        at secondsFromNow: TimeInterval
    ) {
        var secondsFromNow = secondsFromNow
        
        // clamp lower bound to 0
        guard secondsFromNow > 0 else {
            // don't schedule, just dispatch it immediately
            Task { await dispatch(message, timeTag: timeTag) }
            return
        }
        
        // safety check: protect again overflow
        let maxSeconds = TimeInterval(UInt64.max / 1_000_000_000)
        secondsFromNow = min(secondsFromNow, maxSeconds)
        let nanoseconds = UInt64(secondsFromNow * 1_000_000_000)
        
        Task {
            try await Task.sleep(nanoseconds: nanoseconds)
            await self.handler?(message, timeTag)
        }
    }
}
