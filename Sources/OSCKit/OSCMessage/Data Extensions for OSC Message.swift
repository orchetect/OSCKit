//
//  Data Extensions for OSC Message.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension Data {
    
    /// A fast test if `Data` appears tor be an OSC message.
    /// (Note: Does NOT do extensive checks to ensure message isn't malformed.)
    @inlinable
    public var appearsToBeOSCMessage: Bool {
        
        // it's possible an OSC address won't start with "/", but it should!
        self.starts(with: OSCMessage.header)
        
    }
    
}
