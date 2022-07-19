//
//  Data Extensions for OSC Bundle.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension Data {
    
    /// A fast function to test if Data() begins with an OSC bundle header
    /// (Note: Does NOT do extensive checks to ensure data block isn't malformed)
    @inlinable
    var appearsToBeOSCBundle: Bool {
        
        self.starts(with: OSCBundle.header)
        
    }
    
}
