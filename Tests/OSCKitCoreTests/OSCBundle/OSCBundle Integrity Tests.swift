//
//  OSCBundle Integrity Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import OSCKitCore
import Testing

@Suite struct OSCBundle_Integrity_Tests {
    // MARK: - Constructors
    
    @Test
    func constructors() async throws {
        // empty
        
        let emptyBundle = OSCBundle([])
        #expect(emptyBundle.timeTag.rawValue == 1)
        #expect(emptyBundle.elements.isEmpty)
        
        // timetag only
        
        let timeTagOnly = OSCBundle(
            timeTag: .init(20),
            []
        )
        #expect(timeTagOnly.timeTag.rawValue == 20)
        #expect(timeTagOnly.elements.isEmpty)
        
        // elements only
        
        let elementsOnly = OSCBundle([.message("/")])
        #expect(elementsOnly.timeTag.rawValue == 1)
        #expect(elementsOnly.elements.count == 1)
        
        // timetag and elements
        
        let elementsAndTT = OSCBundle(
            timeTag: .init(20),
            [.message("/")]
        )
        #expect(elementsAndTT.timeTag.rawValue == 20)
        #expect(elementsAndTT.elements.count == 1)
        
        // raw data
        
        let rawData = try OSCBundle(from: OSCBundle.header + 20.int64.toData(.bigEndian))
        #expect(rawData.timeTag.rawValue == 20)
        #expect(rawData.elements.isEmpty)
    }
    
    // MARK: - Complex messages
    
    @Test
    func complex() async throws {
        // this does not necessarily prove that encoding or decoding actually matches OSC spec, it
        // simply ensures that rawData that OSCBundle generates can be decoded
        
        // build bundle
        
        let oscBundle = OSCBundle([
            // element 1
            .bundle([.message("/bundle1/msg")]),
            
            // element 2
            .bundle([
                .message(
                    "/bundle2/msg1",
                    values: [
                        Int32(500_000),
                        String("some string here")
                    ]
                ),
                .message(
                    "/bundle2/msg2",
                    values: [
                        Float32(8795.4556),
                        Int32(75)
                    ]
                )
            ]),
            
            // element 3
            .message(
                "/msg1",
                values: [Data([1, 2, 3])]
            ),
            
            // element 4
            .bundle([])
        ])
        
        // encode
        
        let encodedOSCbundle = try oscBundle.rawData()
        
        // decode
        
        let decodedOSCbundle = try OSCBundle(from: encodedOSCbundle)
        
        // verify contents
        
        #expect(decodedOSCbundle.timeTag.rawValue == 1)
        #expect(decodedOSCbundle.elements.count == 4)
        
        let element1 = try #require(decodedOSCbundle.elements[0] as? OSCBundle)
        #expect(element1.timeTag.rawValue == 1)
        #expect(element1.elements.count == 1)
        
        let element1A = try #require(element1.elements[0] as? OSCMessage)
        #expect(element1A.addressPattern.stringValue == "/bundle1/msg")
        #expect(element1A.values.isEmpty)
        
        let element2 = try #require(decodedOSCbundle.elements[1] as? OSCBundle)
        #expect(element2.timeTag.rawValue == 1)
        #expect(element2.elements.count == 2)
        
        let element2A = try #require(element2.elements[0] as? OSCMessage)
        #expect(element2A.addressPattern.stringValue == "/bundle2/msg1")
        #expect(element2A.values.count == 2)
        
        let element2A1 = try #require(element2A.values[0] as? Int32)
        #expect(element2A1 == 500_000)
        
        let element2A2 = try #require(element2A.values[1] as? String)
        #expect(element2A2 == "some string here")
        
        let element2B = try #require(element2.elements[1] as? OSCMessage)
        #expect(element2B.addressPattern.stringValue == "/bundle2/msg2")
        #expect(element2B.values.count == 2)
        
        let element2B1 = try #require(element2B.values[0] as? Float32)
        #expect(element2B1 == 8795.4556)
        
        let element2B2 = try #require(element2B.values[1] as? Int32)
        #expect(element2B2 == 75)
        
        let element3 = try #require(decodedOSCbundle.elements[2] as? OSCMessage)
        #expect(element3.addressPattern.stringValue == "/msg1")
        #expect(element3.values.count == 1)
        
        // element 4
        let element4 = try #require(decodedOSCbundle.elements[3] as? OSCBundle)
        #expect(element4.timeTag.rawValue == 1)
        #expect(element4.elements.isEmpty)
    }
}
