//
//  Dispatcher MethodID.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCAddress.Dispatcher {
    
    /// A unique identifier corresponding to an OSC address method that was registered with the `Dispatcher`
    public struct MethodID: Equatable, Hashable {
        
        let uuid = UUID()
        
    }
    
}
