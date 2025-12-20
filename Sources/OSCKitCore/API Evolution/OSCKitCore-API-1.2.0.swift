//
//  OSCKitCore-API-1.2.0.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCAddressSpace {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "MethodBlock")
    public typealias LegacyMethodBlock = @Sendable (_ values: OSCValues) async -> Void
    
    @_documentation(visibility: internal)
    @available(
        *,
         deprecated,
         message: "Handler closure now takes 3 parameters: values, host, port."
    )
    @_disfavoredOverload
    @discardableResult
    public func register(
        localAddress address: String,
        block: @escaping LegacyMethodBlock
    ) -> MethodID where MethodID == UUID {
        register(localAddress: address) { values, host, port in
            await block(values)
        }
    }
}

extension OSCAddressSpace {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "dispatch(message:host:port:)")
    @_disfavoredOverload
    @discardableResult
    public func dispatch(
        _ message: OSCMessage
    ) -> [MethodID] {
        dispatch(message: message, host: "", port: 0)
    }
}
