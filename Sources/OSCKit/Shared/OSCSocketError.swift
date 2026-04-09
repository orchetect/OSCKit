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
    
    public var errorDescription: String? {
        switch self {
        case .notStarted:
            "The OSC socket has not been started yet."
        case .noRemoteHost:
            "A remote host was specified at initialization or in call to send()."
        }
    }
}
