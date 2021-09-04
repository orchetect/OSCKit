//
//  OSCPayload.swift
//  OSCKit
//
//  Created by Steffan Andrews on 2021-04-28.
//

import Foundation
import SwiftASCII

/// Enum describing an OSC message type.
public enum OSCPayload {
    
    case message(OSCMessage)
    case bundle(OSCBundle)
    
    /// Returns the OSC object's raw data bytes
    public var rawData: Data {
        switch self {
        case .message(let element):
            return element.rawData
            
        case .bundle(let element):
            return element.rawData
            
        }
    }
    
    /// Syntactic sugar convenience
    public init(_ message: OSCMessage) {
        self = .message(message)
    }
    
    /// Syntactic sugar convenience
    public init(_ bundle: OSCBundle) {
        self = .bundle(bundle)
    }
    
    /// Syntactic sugar convenience
    public static func message(address: ASCIIString,
                               values: [OSCMessageValue] = []) -> Self {
        
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


// MARK: - CustomStringConvertible

extension OSCPayload: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .message(let element):
            return element.description
            
        case .bundle(let element):
            return element.description
            
        }
    }
    
}
