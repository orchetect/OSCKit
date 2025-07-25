//
//  OSCTCPGeneratesClientNotificationsProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket

protocol _OSCTCPGeneratesClientNotificationsProtocol {
    func _generateConnectedNotification()
    
    func _generateDisconnectedNotification(
        error: GCDAsyncSocketError?
    )
}

#endif
