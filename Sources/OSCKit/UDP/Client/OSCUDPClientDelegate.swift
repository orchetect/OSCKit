//
//  OSCUDPClientDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation
import OSCKitCore

final class OSCUDPClientDelegate: NSObject { }

extension OSCUDPClientDelegate: GCDAsyncUdpSocketDelegate {
    // we don't care about handling any delegate methods here so none are overridden
}

extension OSCUDPClientDelegate: Sendable { }

#endif
