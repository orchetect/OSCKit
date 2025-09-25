//
//  OSCKitCore-API-1.4.1.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCValueTagIdentity {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "tag")
    public func atomic(_ character: Character) -> Self {
        .tag(character)
    }
}

// MARK: - OSCValueDecoderBlock.swift

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCValueStaticTagDecoder")
public typealias OSCValueAtomicDecoder = OSCValueStaticTagDecoder

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCValueVariableTagDecoder")
public typealias OSCValueVariableDecoder = OSCValueVariableTagDecoder

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCValueVariadicTagDecoder")
public typealias OSCValueVariadicDecoder = OSCValueVariadicTagDecoder

// MARK: - OSCValueEncoderBlock.swift

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCValueStaticTagEncoder")
public typealias OSCValueAtomicEncoder = OSCValueStaticTagEncoder

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCValueVariableTagEncoder")
public typealias OSCValueVariableEncoder = OSCValueVariableTagEncoder

@_documentation(visibility: internal)
@available(*, deprecated, renamed: "OSCValueVariadicTagEncoder")
public typealias OSCValueVariadicEncoder = OSCValueVariadicTagEncoder
