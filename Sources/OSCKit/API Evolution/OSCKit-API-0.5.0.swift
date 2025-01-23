//
//  OSCKit-API-0.5.0.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation

extension OSCServer {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "OSCTimeTagMode")
    public typealias TimeTagMode = OSCTimeTagMode
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "localPort")
    public var port: UInt16 {
        localPort
    }
}

#endif
