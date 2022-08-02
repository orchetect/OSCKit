//
//  Concrete Masks Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import OTCore
import SwiftASCII

final class ConcreteMasks_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - 1 Value
    
    func testValues_V0() throws {
        // success
        XCTAssertEqual(
            try [OSCMessage.Value]([.int32(123)])
                .masked(Int32.self),
            (123)
        )
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([.int32(123)])
                .masked(Int64.self)
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([])
                .masked(Int32.self)
        )
        XCTAssertThrowsError(
            try [OSCMessage.Value]([.int32(123), .string("str")])
                .masked(Int32.self)
        )
    }
    
    func testValues_V0o() throws {
        // success, has value
        XCTAssertEqual(
            try [OSCMessage.Value]([.int32(123)])
                .masked(Int32?.self),
            123
        )
        
        // success, nil optional
        XCTAssertEqual(
            try [OSCMessage.Value]([])
                .masked(Int32?.self),
            nil
        )
    }
    
    // MARK: - 2 Values
    
    func testValues_V0_V1() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [.int32(123), .string("str")]
            
            let masked = try XCTUnwrap(values.masked(Int32.self, ASCIIString.self))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([.int32(123), .string("str")])
                .masked(Int64.self, ASCIIString.self)
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([.int32(123)])
                .masked(Int32.self, ASCIIString.self)
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([.int32(123), .string("str"), .bool(true)])
                .masked(Int32.self, ASCIIString.self)
        )
    }
    
    func testValues_V0_V1o() throws {
        // success, has value
        do {
            let masked = try [OSCMessage.Value]([.int32(123), .string("str")])
                .masked(Int32.self, ASCIIString?.self)
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
        }
        
        // success, nil optional
        do {
            let masked = try [OSCMessage.Value]([.int32(123)])
                .masked(Int32.self, ASCIIString?.self)
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, nil)
        }
        
        // wrong value type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([.int32(123), .bool(true)])
                .masked(Int32.self, ASCIIString?.self)
        )
    }
    
    func testValues_V0o_V1o() throws {
        // success, has value
        do {
            let masked = try [OSCMessage.Value]([
                .int32(123),
                .string("str")
            ])
            .masked(
                Int32?.self,
                ASCIIString?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
        }
        
        // success, nil optional
        do {
            let masked = try [OSCMessage.Value]([.int32(123)])
                .masked(
                    Int32?.self,
                    ASCIIString?.self
                )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, nil)
        }
        
        // success, nil optional
        do {
            let masked = try [OSCMessage.Value]([])
                .masked(
                    Int32?.self,
                    ASCIIString?.self
                )
            
            XCTAssertEqual(masked.0, nil)
            XCTAssertEqual(masked.1, nil)
        }
        
        // wrong value type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([.int32(123), .bool(true)])
                .masked(
                    Int32?.self,
                    ASCIIString?.self
                )
        )
    }
    
    // MARK: - 3 Values
    // TODO: Note: 3 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [
                .int32(123),
                .string("str"),
                .bool(true)
            ]
            
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true)
            ])
            .masked(
                Int64.self, // wrong type
                ASCIIString.self,
                Bool.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([.int32(123), .string("str")])
                .masked(
                    Int32.self,
                    ASCIIString.self,
                    Bool.self
                )
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45)
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o() throws {
        let values: [OSCMessage.Value] = [
            .int32(123),
            .string("str"),
            .bool(true)
        ]
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32?.self,
                ASCIIString?.self,
                Bool?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
        }
    }
    
    // MARK: - 4 Values
    // TODO: Note: 4 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78)
            ]
            
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78)
            ])
            .masked(
                Int64.self, // wrong type
                ASCIIString.self,
                Bool.self,
                Float32.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true)
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self
            )
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01]))
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o() throws {
        let values: [OSCMessage.Value] = [
            .int32(123),
            .string("str"),
            .bool(true),
            .float32(456.78)
        ]
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32?.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
    }
    
    // MARK: - 5 Values
    // TODO: Note: 5 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01]))
            ]
            
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01]))
            ])
            .masked(
                Int64.self, // wrong type
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45)
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self
            )
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56)
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o() throws {
        let values: [OSCMessage.Value] = [
            .int32(123),
            .string("str"),
            .bool(true),
            .float32(456.78),
            .blob(Data([0x01]))
        ]
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32?.self,
                Data?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32?.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
    }
    
    // MARK: - 6 Values
    // TODO: Note: 6 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56)
            ]
            
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56)
            ])
            .masked(
                Int64.self, // wrong type
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01]))
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self
            )
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C")
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o() throws {
        let values: [OSCMessage.Value] = [
            .int32(123),
            .string("str"),
            .bool(true),
            .float32(456.78),
            .blob(Data([0x01])),
            .double(234.56)
        ]
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32?.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
    }
    
    // MARK: - 7 Values
    // TODO: Note: 7 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5_V6() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C")
            ]
            
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C")
            ])
            .masked(
                Int64.self, // wrong type
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56)
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self
            )
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999)
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o_V6o() throws {
        let values: [OSCMessage.Value] = [
            .int32(123),
            .string("str"),
            .bool(true),
            .float32(456.78),
            .blob(Data([0x01])),
            .double(234.56),
            .character("C")
        ]
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self,
                ASCIICharacter?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32?.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
    }
    
    // MARK: - 8 Values
    // TODO: Note: 8 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5_V6_V7() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999)
            ]
            
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999)
            ])
            .masked(
                Int64.self, // wrong type
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C")
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self
            )
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999),
                .stringAlt("str2")
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o() throws {
        let values: [OSCMessage.Value] = [
            .int32(123),
            .string("str"),
            .bool(true),
            .float32(456.78),
            .blob(Data([0x01])),
            .double(234.56),
            .character("C"),
            .timeTag(999)
        ]
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter?.self,
                Int64?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32?.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
        }
    }
    
    // MARK: - 9 Values
    // TODO: Note: 9 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5_V6_V7_V8() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999),
                .stringAlt("str2")
            ]
            
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999),
                .stringAlt("str2")
            ])
            .masked(
                Int64.self, // wrong type
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999)
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self
            )
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999),
                .stringAlt("str2"),
                .midi(portID: 0x00, status: 0xFF)
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o_V8o() throws {
        let values: [OSCMessage.Value] = [
            .int32(123),
            .string("str"),
            .bool(true),
            .float32(456.78),
            .blob(Data([0x01])),
            .double(234.56),
            .character("C"),
            .timeTag(999),
            .stringAlt("str2")
        ]
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64?.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32?.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
        }
    }
    
    // MARK: - 10 Values
    // TODO: Note: 10 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5_V6_V7_V8_V9() throws {
        // success
        do {
            let values: [OSCMessage.Value] = [
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999),
                .stringAlt("str2"),
                .midi(portID: 0x00, status: 0xFF)
            ]
            
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self,
                OSCMessage.Value.MIDIMessage.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        // wrong type
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(456.78),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999),
                .stringAlt("str2"),
                .midi(portID: 0x00, status: 0xFF)
            ])
            .masked(
                Int64.self, // wrong type
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self,
                OSCMessage.Value.MIDIMessage.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999),
                .stringAlt("str2")
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self,
                OSCMessage.Value.MIDIMessage.self
            )
        )
        
        XCTAssertThrowsError(
            try [OSCMessage.Value]([
                .int32(123),
                .string("str"),
                .bool(true),
                .float32(123.45),
                .blob(Data([0x01])),
                .double(234.56),
                .character("C"),
                .timeTag(999),
                .stringAlt("str2"),
                .midi(portID: 0x00, status: 0xFF),
                .null
            ])
            .masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self,
                OSCMessage.Value.MIDIMessage.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o_V8o_V9o() throws {
        let values: [OSCMessage.Value] = [
            .int32(123),
            .string("str"),
            .bool(true),
            .float32(456.78),
            .blob(Data([0x01])),
            .double(234.56),
            .character("C"),
            .timeTag(999),
            .stringAlt("str2"),
            .midi(portID: 0x00, status: 0xFF)
        ]
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter.self,
                Int64?.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try XCTUnwrap(values.masked(
                Int32?.self,
                ASCIIString?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                ASCIICharacter?.self,
                Int64?.self,
                ASCIIString?.self,
                OSCMessage.Value.MIDIMessage?.self
            ))
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7, 999)
            XCTAssertEqual(masked.8, "str2")
            XCTAssertEqual(masked.9, OSCMessage.Value.MIDIMessage(portID: 0x00, status: 0xFF))
        }
    }
    
    // MARK: - Substitute types
    
    func testValuesNumeric_int() throws {
        XCTAssertEqual(
            try [OSCMessage.Value]([.int32(123)])
                .masked(Int.self),
            123
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([.int64(123)])
                .masked(Int.self),
            123
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([.timeTag(123)])
                .masked(Int.self),
            123
        )
    }
    
    func testValuesNumeric_string() throws {
        XCTAssertEqual(
            try [OSCMessage.Value]([.string("str")])
                .masked(String.self),
            "str"
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([.stringAlt("str")])
                .masked(String.self),
            "str"
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([.character("s")])
                .masked(String.self),
            "s"
        )
    }
    
    func testValuesNumeric_character() throws {
        XCTAssertEqual(
            try [OSCMessage.Value]([.character("a")])
                .masked(Character.self),
            "a"
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([.string("a")])
                .masked(Character.self),
            "a"
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([.stringAlt("a")])
                .masked(Character.self),
            "a"
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([.string("ab")])
                .masked(Character.self),
            "a"
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([.stringAlt("ab")])
                .masked(Character.self),
            "a"
        )
    }
    
    // MARK: - Meta type: OSCMessage.Value.Number
    
    func testValuesNumeric_int32() throws {
        let values: [OSCMessage.Value] = [.int32(123)]
        
        let masked = try values.masked(OSCMessage.Value.Number.self)
        
        guard case let .int32(v) = masked else { XCTFail(); return }
        
        XCTAssertEqual(v, 123)
    }
    
    func testValuesNumeric_float32() throws {
        let values: [OSCMessage.Value] = [.float32(123.45)]
        
        let masked = try values.masked(OSCMessage.Value.Number.self)
        
        guard case let .float32(v) = masked else { XCTFail(); return }
        
        XCTAssertEqual(v, 123.45)
    }
    
    func testValuesNumeric_int64() throws {
        let values: [OSCMessage.Value] = [.int64(123)]
        
        let masked = try values.masked(OSCMessage.Value.Number.self)
        
        guard case let .int64(v) = masked else { XCTFail(); return }
        
        XCTAssertEqual(v, 123)
    }
    
    func testValuesNumeric_double() throws {
        let values: [OSCMessage.Value] = [.double(123.45)]
        
        let masked = try values.masked(OSCMessage.Value.Number.self)
        
        guard case let .double(v) = masked else { XCTFail(); return }
        
        XCTAssertEqual(v, 123.45)
    }
    
    func testValuesNumericOptional() throws {
        XCTAssertEqual(
            try [OSCMessage.Value]([.int32(123)])
                .masked(OSCMessage.Value.Number?.self),
            .int32(123)
        )
        
        XCTAssertEqual(
            try [OSCMessage.Value]([])
                .masked(OSCMessage.Value.Number?.self),
            nil
        )
    }
}

#endif
