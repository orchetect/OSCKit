//
//  OSCBundle Integrity Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import OTCore

final class OSCBundle_Integrity_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Constructors
    
    func testConstructors() throws {
        // empty
        
        let emptyBundle = OSCBundle([])
        XCTAssertEqual(emptyBundle.timeTag.rawValue, 1)
        XCTAssertEqual(emptyBundle.elements.count, 0)
        
        // timetag only
        
        let timeTagOnly = OSCBundle(
            timeTag: .init(20),
            []
        )
        XCTAssertEqual(timeTagOnly.timeTag.rawValue, 20)
        XCTAssertEqual(timeTagOnly.elements.count, 0)
        
        // elements only
        
        let elementsOnly = OSCBundle([.message("/")])
        XCTAssertEqual(elementsOnly.timeTag.rawValue, 1)
        XCTAssertEqual(elementsOnly.elements.count, 1)
        
        // timetag and elements
        
        let elementsAndTT = OSCBundle(
            timeTag: .init(20),
            [.message("/")]
        )
        XCTAssertEqual(elementsAndTT.timeTag.rawValue, 20)
        XCTAssertEqual(elementsAndTT.elements.count, 1)
        
        // raw data
        
        let rawData = try OSCBundle(from: OSCBundle.header + 20.int64.toData(.bigEndian))
        XCTAssertEqual(rawData.timeTag.rawValue, 20)
        XCTAssertEqual(rawData.elements.count, 0)
    }
    
    // MARK: - Complex messages
    
    func testComplex() throws {
        // this does not necessarily prove that encoding or decoding actually matches OSC spec, it simply ensures that rawData that OSCBundle generates can be decoded
        
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
        
        XCTAssertEqual(decodedOSCbundle.timeTag.rawValue, 1)
        XCTAssertEqual(decodedOSCbundle.elements.count, 4)
        
        let element1 = try XCTUnwrap(decodedOSCbundle.elements[safe: 0] as? OSCBundle)
        XCTAssertEqual(element1.timeTag.rawValue, 1)
        XCTAssertEqual(element1.elements.count, 1)
        
        let element1A = try XCTUnwrap(element1.elements[safe: 0] as? OSCMessage)
        XCTAssertEqual(element1A.addressPattern.stringValue, "/bundle1/msg")
        XCTAssertEqual(element1A.values.count, 0)
        
        let element2 = try XCTUnwrap(decodedOSCbundle.elements[safe: 1] as? OSCBundle)
        XCTAssertEqual(element2.timeTag.rawValue, 1)
        XCTAssertEqual(element2.elements.count, 2)
        
        let element2A = try XCTUnwrap(element2.elements[safe: 0] as? OSCMessage)
        XCTAssertEqual(element2A.addressPattern.stringValue, "/bundle2/msg1")
        XCTAssertEqual(element2A.values.count, 2)
        
        let element2A1 = try XCTUnwrap(element2A.values[safe: 0] as? Int32)
        XCTAssertEqual(element2A1, 500_000)
        
        let element2A2 = try XCTUnwrap(element2A.values[safe: 1] as? String)
        XCTAssertEqual(element2A2, "some string here")
        
        let element2B = try XCTUnwrap(element2.elements[safe: 1] as? OSCMessage)
        XCTAssertEqual(element2B.addressPattern.stringValue, "/bundle2/msg2")
        XCTAssertEqual(element2B.values.count, 2)
        
        let element2B1 = try XCTUnwrap(element2B.values[safe: 0] as? Float32)
        XCTAssertEqual(element2B1, 8795.4556)
        
        let element2B2 = try XCTUnwrap(element2B.values[safe: 1] as? Int32)
        XCTAssertEqual(element2B2, 75)
        
        let element3 = try XCTUnwrap(decodedOSCbundle.elements[safe: 2] as? OSCMessage)
        XCTAssertEqual(element3.addressPattern.stringValue, "/msg1")
        XCTAssertEqual(element3.values.count, 1)
        
        // element 4
        let element4 = try XCTUnwrap(decodedOSCbundle.elements[safe: 3] as? OSCBundle)
        XCTAssertEqual(element4.timeTag.rawValue, 1)
        XCTAssertEqual(element4.elements.count, 0)
    }
}

#endif
