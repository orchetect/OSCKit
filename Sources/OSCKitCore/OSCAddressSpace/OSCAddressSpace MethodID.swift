//
//  OSCAddressSpace MethodID.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension OSCAddressSpace {
    /// A closure executed when an inbound OSC message address pattern matches a local OSC method.
    public typealias MethodBlock = (_ values: OSCValues) -> Void
    
    /// A unique identifier corresponding to an OSC Method that was registered.
    public struct MethodID: Equatable, Hashable {
        let uuid = UUID()
    }
}
