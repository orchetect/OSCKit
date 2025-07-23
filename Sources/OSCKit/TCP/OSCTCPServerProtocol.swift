//
//  OSCTCPServerProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation

/// Internal protocol that TCP-based OSC classes adopt in order to handle incoming OSC data.
protocol _OSCTCPServerProtocol: _OSCServerProtocol {
    var tcpSocket: GCDAsyncSocket { get }
}

#endif
