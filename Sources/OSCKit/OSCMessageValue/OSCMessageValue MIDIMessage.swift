//
//  OSCMessageValue MIDIMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation

extension OSCMessageValue {
    
    public struct MIDIMessage: Equatable, Hashable, CustomStringConvertible {
        
        public var portID: UInt8
        public var status: UInt8
        public var data1: UInt8
        public var data2: UInt8
        
        @inlinable
        public init(portID: UInt8,
                    status: UInt8,
                    data1: UInt8 = 0x00,
                    data2: UInt8 = 0x00) {
            
            self.portID = portID
            self.status = status
            self.data1 = data1
            self.data2 = data2
            
        }
        
        public var description: String {
            
            "portID:\(portID.hex.stringValue) status:\(status.hex.stringValue) data1:\(data1.hex.stringValue) data2:\(data2.hex.stringValue)"
            
        }
        
    }
    
}
