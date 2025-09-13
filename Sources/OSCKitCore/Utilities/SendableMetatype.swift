//
//  SendableMetatype.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if compiler(<6.2)
/// Stub protocol for Swift compiler prior to Swift 6.2.
///
/// This protocol has no effect when compiled with older versions of Swift.
/// When the package is compiled with Swift 6.2 or later, the standard library's
/// `SendableMetatype` protocol will be used in its place.
@_documentation(visibility: internal)
public protocol SendableMetatype { }
#endif
