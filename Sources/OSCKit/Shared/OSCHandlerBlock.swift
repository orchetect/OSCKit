//
//  OSCHandlerBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin) && !os(watchOS)

import OSCKitCore

/// Received-message handler closure used by OSCKit socket classes.
public typealias OSCHandlerBlock = @Sendable (
    _ message: OSCMessage,
    _ timeTag: OSCTimeTag,
    _ host: String,
    _ port: UInt16
) -> Void

#endif
