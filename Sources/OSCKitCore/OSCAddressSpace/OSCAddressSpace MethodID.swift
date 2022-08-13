//
//  OSCAddressSpace MethodID.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCAddressSpace {
    /// A unique identifier corresponding to an OSC Method that was registered.
    public struct MethodID: Equatable, Hashable {
        let uuid = UUID()
    }
}
