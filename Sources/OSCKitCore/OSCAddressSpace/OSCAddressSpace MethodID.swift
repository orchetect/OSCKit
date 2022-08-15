//
//  OSCAddressSpace MethodID.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCAddressSpace {
    /// A unique identifier corresponding to an OSC Method that was registered.
    public struct MethodID: Equatable, Hashable {
        let uuid = UUID()
    }
}
