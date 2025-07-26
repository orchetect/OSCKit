//
//  OSCKit-API-1.3.0.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCUDPClient")
public typealias OSCClient = OSCUDPClient

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCUDPServer")
public typealias OSCServer = OSCUDPServer

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCUDPSocket")
public typealias OSCSocket = OSCUDPSocket

extension OSCUDPServer {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(port:timeTagMode:queue:receiveHandler:)")
    @_disfavoredOverload
    public convenience init(
        port: UInt16 = 8000,
        timeTagMode: OSCTimeTagMode = .ignore,
        receiveQueue: DispatchQueue? = nil,
        handler: OSCHandlerBlock? = nil
    ) {
        self.init(port: port, timeTagMode: timeTagMode, queue: receiveQueue, receiveHandler: handler)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "setReceiveHandler")
    @_disfavoredOverload
    public func setHandler(
        _ handler: OSCHandlerBlock?
    ) {
        setReceiveHandler(handler)
    }
}

extension OSCUDPSocket {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(localPort:remoteHost:remotePort:timeTagMode:isIPv4BroadcastEnabled:queue:receiveHandler:)")
    @_disfavoredOverload
    public convenience init(
        localPort: UInt16? = nil,
        remoteHost: String? = nil,
        remotePort: UInt16? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        isIPv4BroadcastEnabled: Bool = false,
        receiveQueue: DispatchQueue? = nil,
        handler: OSCHandlerBlock? = nil
    ) {
        self.init(
            localPort: localPort,
            remoteHost: remoteHost,
            remotePort: remotePort,
            timeTagMode: timeTagMode,
            isIPv4BroadcastEnabled: isIPv4BroadcastEnabled,
            queue: receiveQueue,
            receiveHandler: handler
        )
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "setReceiveHandler")
    @_disfavoredOverload
    public func setHandler(
        _ handler: OSCHandlerBlock?
    ) {
        setReceiveHandler(handler)
    }
}

#endif
