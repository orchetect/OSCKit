//
//  OSCTCPServerProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation

protocol _OSCTCPServerProtocol: _OSCServerProtocol {
    var tcpSocket: GCDAsyncSocket { get }
}

#endif
