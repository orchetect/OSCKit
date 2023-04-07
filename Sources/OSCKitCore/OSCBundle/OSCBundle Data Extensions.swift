//
//  OSCBundle Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data {
    /// A fast function to test if Data() begins with an OSC bundle header
    /// (Note: Does NOT do extensive checks to ensure data block isn't malformed)
    var appearsToBeOSCBundle: Bool {
        starts(with: OSCBundle.header)
    }
}
