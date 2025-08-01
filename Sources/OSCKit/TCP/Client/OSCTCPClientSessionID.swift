//
//  OSCTCPClientSessionID.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

/// Identifier tag used by ``OSCTCPServer`` to uniquely identify a connected client session.
///
/// > Note:
/// >
/// > A client ID is transient and only valid for the lifecycle of the connection. Client IDs are randomly-assigned
/// > upon each newly-made connection. For this reason, these IDs should not be stored persistently, but instead
/// > queried from the OSC TCP server when a client connects or analyzing currently-connected clients.
public typealias OSCTCPClientSessionID = Int
