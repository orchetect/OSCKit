//
//  OSCKit-API-1.2.0.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation

/// Received-message handler closure used by OSCKit socket classes.
@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCHandlerBlock")
public typealias LegacyOSCHandlerBlock = @Sendable (
    _ message: OSCMessage,
    _ timeTag: OSCTimeTag
) -> Void

extension OSCUDPServer {
    @_documentation(visibility: internal)
    @available(
        *,
         deprecated,
         message: "Handler closure now takes 4 parameters: message, timeTag, host, port."
    )
    @_disfavoredOverload
    public convenience init(
        port: UInt16 = 8000,
        timeTagMode: OSCTimeTagMode = .ignore,
        receiveQueue: DispatchQueue? = nil,
        handler: @escaping LegacyOSCHandlerBlock
    ) {
        self.init(
            port: port,
            timeTagMode: timeTagMode,
            queue: receiveQueue,
            receiveHandler: { message, timeTag, _, _ in handler(message, timeTag) }
        )
    }
    
    @_documentation(visibility: internal)
    @available(
        *,
         deprecated,
         message: "Handler closure now takes 4 parameters: message, timeTag, host, port."
    )
    @_disfavoredOverload
    public func setHandler(
        _ handler: @escaping LegacyOSCHandlerBlock
    ) {
        setHandler { message, timeTag, _, _ in handler(message, timeTag) }
    }
}

extension OSCUDPSocket {
    @_documentation(visibility: internal)
    @available(
        *,
        deprecated,
        message: "Handler closure now takes 4 parameters: message, timeTag, host, port."
    )
    @_disfavoredOverload
    public convenience init(
        localPort: UInt16? = nil,
        remoteHost: String? = nil,
        remotePort: UInt16? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        isIPv4BroadcastEnabled: Bool = false,
        queue: DispatchQueue? = nil,
        handler: @escaping LegacyOSCHandlerBlock
    ) {
        self.init(
            localPort: localPort,
            remoteHost: remoteHost,
            remotePort: remotePort,
            timeTagMode: timeTagMode,
            isIPv4BroadcastEnabled: isIPv4BroadcastEnabled,
            queue: nil,
            receiveHandler: { message, timeTag, _, _ in handler(message, timeTag) }
        )
    }
    
    @_documentation(visibility: internal)
    @available(
        *,
         deprecated,
         message: "Handler closure now takes 4 parameters: message, timeTag, host, port."
    )
    @_disfavoredOverload
    public func setHandler(
        _ handler: @escaping LegacyOSCHandlerBlock
    ) {
        setReceiveHandler { message, timeTag, _, _ in handler(message, timeTag) }
    }
}

#endif
