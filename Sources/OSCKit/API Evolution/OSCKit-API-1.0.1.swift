//
//  OSCKit-API-1.0.1.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation

extension OSCSocket {
    @_documentation(visibility: internal)
    @available(
        *,
        deprecated,
        renamed: "init(localPort:remoteHost:remotePort:timeTagMode:isPortReuseEnabled:isIPv4BroadcastEnabled:handler:)"
    )
    public init(
        localPort: UInt16? = nil,
        remoteHost: String? = nil,
        remotePort: UInt16? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        isIPv4BroadcastEnabled: Bool = false,
        isPortReuseEnabled: Bool = false,
        handler: OSCHandlerBlock? = nil
    ) {
        self.init(
            localPort: localPort,
            remoteHost: remoteHost,
            remotePort: remotePort,
            timeTagMode: timeTagMode,
            isPortReuseEnabled: isPortReuseEnabled,
            isIPv4BroadcastEnabled: isIPv4BroadcastEnabled,
            handler: handler
        )
    }
}

#endif
