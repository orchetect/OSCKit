//
//  AnyOSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public typealias AnyOSCValue = any OSCValue

/// `==` convenience method since directly comparing two `any OSCValue` is not possible.
func isEqual(_ lhs: AnyOSCValue, _ rhs: AnyOSCValue) -> Bool {
    AnyHashable(lhs) == AnyHashable(rhs)
}
