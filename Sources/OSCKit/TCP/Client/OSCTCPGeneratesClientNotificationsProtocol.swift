//
//  OSCTCPGeneratesClientNotificationsProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

protocol _OSCTCPGeneratesClientNotificationsProtocol {
    func _generateConnectedNotification(
        remoteHost: String,
        remotePort: UInt16
    )
    
    func _generateDisconnectedNotification(
        remoteHost: String,
        remotePort: UInt16
    )
}
