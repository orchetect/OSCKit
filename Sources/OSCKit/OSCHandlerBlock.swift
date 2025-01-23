//
//  OSCHandlerBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore

/// Received-message handler closure used by OSCKit socket classes.
public typealias OSCHandlerBlock = @Sendable (
    _ message: OSCMessage,
    _ timeTag: OSCTimeTag
) -> Void
