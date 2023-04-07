//
//  OSCServerProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import CocoaAsyncSocket

public protocol OSCServerProtocol: AnyObject { }

internal protocol _OSCServerProtocol: OSCServerProtocol {
    var timeTagMode: OSCServer.TimeTagMode { get set }
    var dispatchQueue: DispatchQueue { get }
    var handler: ((_ message: OSCMessage, _ timeTag: OSCTimeTag) -> Void)? { get set }
}

// MARK: - Handle and Dispatch

extension _OSCServerProtocol {
    /// Handle incoming OSC data recursively.
    func handle(
        payload: any OSCObject,
        timeTag: OSCTimeTag = .immediate()
    ) throws {
        switch payload {
        case let bundle as OSCBundle:
            for element in bundle.elements {
                try handle(payload: element, timeTag: bundle.timeTag)
            }
            
        case let message as OSCMessage:
            schedule(message, at: timeTag)
            
        default:
            assertionFailure("Unexpected OSCObject type encountered.")
        }
    }
    
    func schedule(
        _ message: OSCMessage,
        at timeTag: OSCTimeTag = .immediate()
    ) {
        switch timeTagMode {
        case .ignore:
            dispatch(message, timeTag: timeTag)
            
        case .osc1_0:
            // TimeTag of 1 has special meaning in OSC to dispatch "now".
            if timeTag.isImmediate {
                dispatch(message, timeTag: timeTag)
                return
            }
            
            // If Time Tag is <= now, dispatch immediately.
            // Otherwise, schedule message for future dispatch.
            guard timeTag.isFuture else {
                dispatch(message, timeTag: timeTag)
                return
            }
            
            let secondsFromNow = timeTag.timeIntervalSinceNow()
            dispatch(message, timeTag: timeTag, at: secondsFromNow)
        }
    }
    
    func dispatch(_ message: OSCMessage, timeTag: OSCTimeTag) {
        dispatchQueue.async {
            self.handler?(message, timeTag)
        }
    }
    
    func dispatch(
        _ message: OSCMessage,
        timeTag: OSCTimeTag,
        at secondsFromNow: TimeInterval
    ) {
        dispatchQueue.asyncAfter(
            deadline: .now() + secondsFromNow
        ) { [weak self] in
            self?.handler?(message, timeTag)
        }
    }
}


/// Internal UDP receiver class so as to not expose `GCDAsyncUdpSocketDelegate` methods as public on `OSCServer`.
internal class OSCServerDelegate: NSObject, GCDAsyncUdpSocketDelegate {
    weak var oscServer: _OSCServerProtocol?
    
    init(oscServer: _OSCServerProtocol? = nil) {
        self.oscServer = oscServer
    }
    
    /// CocoaAsyncSocket receive delegate method implementation.
    func udpSocket(
        _ sock: GCDAsyncUdpSocket,
        didReceive data: Data,
        fromAddress address: Data,
        withFilterContext filterContext: Any?
    ) {
        guard let payload = try? data.parseOSC() else { return }
        try? oscServer?.handle(payload: payload)
    }
}
