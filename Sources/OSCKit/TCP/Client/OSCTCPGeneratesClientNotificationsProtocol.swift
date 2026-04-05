//
//  OSCTCPGeneratesClientNotificationsProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin) && !os(watchOS)

@preconcurrency import CocoaAsyncSocket

protocol _OSCTCPGeneratesClientNotificationsProtocol {
    func _generateConnectedNotification()
    
    func _generateDisconnectedNotification(
        error: GCDAsyncSocketError?
    )
}

#endif
