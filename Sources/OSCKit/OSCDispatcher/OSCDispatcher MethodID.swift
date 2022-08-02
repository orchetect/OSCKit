//
//  OSCDispatcher MethodID.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCDispatcher {
    
    /// A unique identifier corresponding to an OSC address method that was registered with the dispatcher.
    public struct MethodID: Equatable, Hashable {
        
        let uuid = UUID()
        
    }
    
}
