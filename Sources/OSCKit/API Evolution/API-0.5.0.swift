//
//  API-0.5.0.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

import Foundation

extension OSCServer {
    @available(*, deprecated, renamed: "OSCTimeTagMode")
    public typealias TimeTagMode = OSCTimeTagMode
    
    @available(*, deprecated, renamed: "localPort")
    public var port: UInt16 {
        localPort
    }
}

#endif
