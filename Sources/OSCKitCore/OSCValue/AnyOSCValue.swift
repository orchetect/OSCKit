//
//  AnyOSCValue.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public typealias AnyOSCValue = any OSCValue

/// Compare two `OSCValue` instances.
///
/// - Note: This method is implemented as global since Swift will not allow `AnyOSCValue` (`any OSCValue`) to conform to `Equatable`.
public func == (lhs: AnyOSCValue, rhs: AnyOSCValue) -> Bool {
    AnyHashable(lhs) == AnyHashable(rhs)
}
