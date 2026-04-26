//
//  OSCSocketError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

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
        case let .clientNotFound(id):
            "OSC TCP client socket with ID \(id) not found (not connected)."
        }
    }
}

#endif
