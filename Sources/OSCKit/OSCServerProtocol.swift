//
//  OSCServerProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore

/// Internal protocol that all objects who act as an OSC server adopt.
/// Provides shared logic.
protocol _OSCServerProtocol: AnyObject where Self: Sendable {
    var queue: DispatchQueue { get }
    var timeTagMode: OSCTimeTagMode { get set }
    var handler: OSCHandlerBlock? { get set }
}

// MARK: - Handle and Dispatch

extension _OSCServerProtocol {
    /// Handle incoming OSC data recursively.
    func _handle(
        payload: any OSCObject,
        timeTag: OSCTimeTag = .immediate(),
        remoteHost: String,
        remotePort: UInt16
    ) {
        queue.async {
            switch payload {
            case let bundle as OSCBundle:
                for element in bundle.elements {
                    self._handle(
                        payload: element,
                        timeTag: bundle.timeTag,
                        remoteHost: remoteHost,
                        remotePort: remotePort
                    )
                }
                
            case let message as OSCMessage:
                self._schedule(
                    message,
                    at: timeTag,
                    remoteHost: remoteHost,
                    remotePort: remotePort
                )
                
            default:
                assertionFailure("Unexpected OSCObject type encountered.")
            }
        }
    }
    
    private func _schedule(
        _ message: OSCMessage,
        at timeTag: OSCTimeTag = .immediate(),
        remoteHost: String,
        remotePort: UInt16
    ) {
        switch self.timeTagMode {
        case .ignore:
            _dispatch(message, timeTag: timeTag, remoteHost: remoteHost, remotePort: remotePort)
            
        case .osc1_0:
            // TimeTag of 1 has special meaning in OSC to dispatch "now".
            if timeTag.isImmediate {
                _dispatch(message, timeTag: timeTag, remoteHost: remoteHost, remotePort: remotePort)
                return
            }
            
            // If Time Tag is <= now, dispatch immediately.
            // Otherwise, schedule message for future dispatch.
            guard timeTag.isFuture else {
                _dispatch(message, timeTag: timeTag, remoteHost: remoteHost, remotePort: remotePort)
                return
            }
            
            let secondsFromNow = timeTag.timeIntervalSinceNow()
            _dispatch(
                message,
                timeTag: timeTag,
                remoteHost: remoteHost,
                remotePort: remotePort,
                at: secondsFromNow
            )
        }
    }
    
    private func _dispatch(
        _ message: OSCMessage,
        timeTag: OSCTimeTag,
        remoteHost: String,
        remotePort: UInt16
    ) {
        queue.async {
            self.handler?(message, timeTag, remoteHost, remotePort)
        }
    }
    
    private func _dispatch(
        _ message: OSCMessage,
        timeTag: OSCTimeTag,
        remoteHost: String,
        remotePort: UInt16,
        at secondsFromNow: TimeInterval
    ) {
        // clamp lower bound to 0
        guard secondsFromNow > 0 else {
            // don't schedule, just dispatch it immediately
            _dispatch(message, timeTag: timeTag, remoteHost: remoteHost, remotePort: remotePort)
            return
        }
        
        let usec = Int(secondsFromNow * TimeInterval(USEC_PER_SEC))
        queue.asyncAfter(deadline: .now() + .microseconds(usec)) { [weak self] in
            self?.handler?(message, timeTag, remoteHost, remotePort)
        }
    }
}
