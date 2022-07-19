//
//  OSCBundle DecodeError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public extension OSCBundle {
    
    enum DecodeError: Error {
        
        /// Malformed data. `verboseError` contains the specific reason.
        case malformed(_ verboseError: String)
        
    }
    
}
