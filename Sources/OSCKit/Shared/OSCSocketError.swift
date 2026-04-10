//
//  File.swift
//  OSCKit
//
//  Created by Joshua Wolfson on 8/4/2026.
//

import Foundation

public enum OSCSocketError: LocalizedError, Equatable, Hashable, Sendable {
    case notStarted
    case noRemoteHost
    case clientNotFound(OSCTCPClientSessionID)
    
    public var errorDescription: String? {
        switch self {
        case .notStarted:
            "The OSC socket has not been started yet."
        case .noRemoteHost:
            "A remote host was specified at initialization or in call to send()."
        case .clientNotFound(let id):
            "OSC TCP client socket with ID \(id) not found (not connected)."
        }
    }
}
