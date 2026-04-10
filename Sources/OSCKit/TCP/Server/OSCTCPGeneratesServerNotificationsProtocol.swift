//
//  OSCTCPGeneratesServerNotificationsProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin) && !os(watchOS)

protocol _OSCTCPGeneratesServerNotificationsProtocol {
    func _generateConnectedNotification(
        remoteHost: String,
        remotePort: UInt16,
        clientID: OSCTCPClientSessionID
    )
    
    func _generateDisconnectedNotification(
        remoteHost: String,
        remotePort: UInt16,
        clientID: OSCTCPClientSessionID,
        error: (any Error)?
    )
}

#endif
