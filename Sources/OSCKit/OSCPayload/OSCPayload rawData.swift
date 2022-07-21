//
//  OSCPayload rawData.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCPayload {
    
    /// Returns the OSC object's raw data bytes.
    public var rawData: Data {
        
        switch self {
        case .message(let element):
            return element.rawData
            
        case .bundle(let element):
            return element.rawData
            
        }
        
    }
    
}
