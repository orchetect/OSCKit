//
//  OSCAddressSpace MethodID.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCAddressSpace {
    /// A unique identifier corresponding to an OSC Method that was registered.
    public struct MethodID {
        let uuid = UUID()
    }
}

extension OSCAddressSpace.MethodID: Equatable { }

extension OSCAddressSpace.MethodID: Hashable { }

extension OSCAddressSpace.MethodID: Sendable { }
