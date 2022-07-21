//
//  OSCPayload init.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCPayload {
    
    /// Syntactic sugar convenience
    public init(_ message: OSCMessage) {
        
        self = .message(message)
        
    }
    
    /// Syntactic sugar convenience
    public init(_ bundle: OSCBundle) {
        
        self = .bundle(bundle)
        
    }
    
}

extension OSCPayload {
    
    /// Syntactic sugar convenience
    public static func message(address: OSCAddress,
                               values: [OSCMessage.Value] = []) -> Self {
        
        let msg = OSCMessage(address: address,
                             values: values)
        
        return .message(msg)
        
    }
    
    /// Syntactic sugar convenience
    public static func bundle(elements: [OSCPayload],
                              timeTag: Int64 = 1) -> Self {
        
        .bundle(OSCBundle(elements: elements,
                          timeTag: timeTag))
        
    }
    
}

