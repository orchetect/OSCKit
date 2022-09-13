//
//  OSCMessage Data Extensions.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data {
    /// A fast test if `Data` appears to be an OSC message.
    /// (Note: Does NOT do extensive checks to ensure message isn't malformed.)
    @inlinable @_disfavoredOverload
    var appearsToBeOSCMessage: Bool {
        // it's possible an OSC address won't start with "/", but it should!
        starts(with: OSCMessage.header)
    }
}
