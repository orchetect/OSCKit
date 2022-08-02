//
//  OSCBundle rawData.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

extension OSCBundle {
    /// Internal: generate raw OSC bytes from struct's properties
    @usableFromInline
    internal static func generateRawData(
        from elements: [OSCPayload],
        timeTag: Int64
    ) -> Data {
        // returns a raw OSC packet constructed out of the struct's properties
        
        // max UDP IPv4 packet size is 65507 bytes,
        // 10kb is reasonable buffer for typical OSC bundles
        var data = Data()
        data.reserveCapacity(10000)
        
        data.append(OSCBundle.header) // prime the header
        
        data.append(timeTag.toData(.bigEndian)) // add timetag
        
        for element in elements {
            let raw = element.rawData
            
            // element length
            data.append(raw.count.int32.toData(.bigEndian))
            
            // element data
            data.append(raw)
        }
        
        return data
    }
}
