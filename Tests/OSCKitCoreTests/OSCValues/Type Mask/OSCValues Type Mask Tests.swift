//
//  OSCValues Type Mask Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore
import OTCore
import SwiftASCII

final class OSCValues_TypeMask_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - 1 Value
    
    func testValues_V0() throws {
        // success
        XCTAssertEqual(
            try OSCValues([Int32(123)])
                .masked(Int32.self),
            123
        )
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([Int32(123)])
                .masked(Int64.self)
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([])
                .masked(Int32.self)
        )
        
        XCTAssertThrowsError(
            try OSCValues([Int32(123), String("str")])
                .masked(Int32.self)
        )
    }
    
    func testValues_V0o() throws {
        // success, has value
        XCTAssertEqual(
            try OSCValues([Int32(123)])
                .masked(Int32?.self),
            123
        )
        
        // success, nil optional
        XCTAssertEqual(
            try OSCValues([])
                .masked(Int32?.self),
            nil
        )
    }
    
    // MARK: - 2 Values
    
    func testValues_V0_V1() throws {
        // success
        do {
            let values: OSCValues = [Int32(123), String("str")]
            
            let masked = try values.masked(Int32.self, String.self)
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
        }
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([Int32(123), String("str")])
                .masked(Int64.self, String.self)
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([Int32(123)])
                .masked(Int32.self, String.self)
        )
        
        XCTAssertThrowsError(
            try OSCValues([Int32(123), String("str"), true])
                .masked(Int32.self, String.self)
        )
    }
    
    func testValues_V0_V1o() throws {
        // success, has value
        do {
            let masked = try OSCValues([Int32(123), String("str")])
                .masked(Int32.self, String?.self)
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
        }
        
        // success, nil optional
        do {
            let masked = try OSCValues([Int32(123)])
                .masked(Int32.self, String?.self)
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, nil)
        }
        
        // wrong value type
        XCTAssertThrowsError(
            try OSCValues([Int32(123), true])
                .masked(Int32.self, String?.self)
        )
    }
    
    func testValues_V0o_V1o() throws {
        // success, has value
        do {
            let masked = try OSCValues([
                Int32(123),
                String("str")
            ])
            .masked(
                Int32?.self,
                String?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
        }
        
        // success, nil optional
        do {
            let masked = try OSCValues([Int32(123)])
                .masked(
                    Int32?.self,
                    String?.self
                )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, nil)
        }
        
        // success, nil optional
        do {
            let masked = try OSCValues([])
                .masked(
                    Int32?.self,
                    String?.self
                )
            
            XCTAssertEqual(masked.0, nil)
            XCTAssertEqual(masked.1, nil)
        }
        
        // wrong value type
        XCTAssertThrowsError(
            try OSCValues([Int32(123), true])
                .masked(
                    Int32?.self,
                    String?.self
                )
        )
    }
    
    // MARK: - 3 Values
    // Note: 3 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2() throws {
        // success
        do {
            let values: OSCValues = [
                Int32(123),
                String("str"),
                true
            ]
            
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
        }
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true
            ])
            .masked(
                Int64.self, // wrong type
                String.self,
                Bool.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([Int32(123), String("str")])
                .masked(
                    Int32.self,
                    String.self,
                    Bool.self
                )
        )
        
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45)
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o() throws {
        let values: OSCValues = [
            Int32(123),
            String("str"),
            true
        ]
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
        }
        
        do {
            let masked = try OSCValues([]).masked(
                Int32?.self,
                String?.self,
                Bool?.self
            )
            
            XCTAssertEqual(masked.0, nil)
            XCTAssertEqual(masked.1, nil)
            XCTAssertEqual(masked.2, nil)
        }
    }
    
    // MARK: - 4 Values
    // Note: 4 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3() throws {
        // success
        do {
            let values: OSCValues = [
                Int32(123),
                String("str"),
                true,
                Float32(456.78)
            ]
            
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(456.78)
            ])
            .masked(
                Int64.self, // wrong type
                String.self,
                Bool.self,
                Float32.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self
            )
        )
        
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01])
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o() throws {
        let values: OSCValues = [
            Int32(123),
            String("str"),
            true,
            Float32(456.78)
        ]
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
        }
    }
    
    // MARK: - 5 Values
    // Note: 5 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4() throws {
        // success
        do {
            let values: OSCValues = [
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01])
            ]
            
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01])
            ])
            .masked(
                Int64.self, // wrong type
                String.self,
                Bool.self,
                Float32.self,
                Data.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45)
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self
            )
        )
        
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56)
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o() throws {
        let values: OSCValues = [
            Int32(123),
            String("str"),
            true,
            Float32(456.78),
            Data([0x01])
        ]
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32?.self,
                Data?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
        }
    }
    
    // MARK: - 6 Values
    // Note: 6 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5() throws {
        // success
        do {
            let values: OSCValues = [
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56)
            ]
            
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56)
            ])
            .masked(
                Int64.self, // wrong type
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01])
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self
            )
        )
        
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56),
                Character("C")
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o() throws {
        let values: OSCValues = [
            Int32(123),
            String("str"),
            true,
            Float32(456.78),
            Data([0x01]),
            Double(234.56)
        ]
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
        }
    }
    
    // MARK: - 7 Values
    // Note: 7 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5_V6() throws {
        // success
        do {
            let values: OSCValues = [
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56),
                Character("C")
            ]
            
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self
            )
            
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
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56),
                Character("C")
            ])
            .masked(
                Int64.self, // wrong type
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56)
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self
            )
        )
        
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999)
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o_V6o() throws {
        let values: OSCValues = [
            Int32(123),
            String("str"),
            true,
            Float32(456.78),
            Data([0x01]),
            Double(234.56),
            Character("C")
        ]
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self,
                Character?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self,
                Character?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self
            )
            
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
    // Note: 8 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5_V6_V7() throws {
        // success
        do {
            let values: OSCValues = [
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999)
            ]
            
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7.rawValue, 999)
        }
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999)
            ])
            .masked(
                Int64.self, // wrong type
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                Int64.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56),
                Character("C")
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                Int64.self
            )
        )
        
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999),
                OSCStringAltValue("str2")
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                Int64.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o() throws {
        let values: OSCValues = [
            Int32(123),
            String("str"),
            true,
            Float32(456.78),
            Data([0x01]),
            Double(234.56),
            Character("C"),
            OSCTimeTag(999)
        ]
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character?.self,
                OSCTimeTag?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
        }
    }
    
    // MARK: - 9 Values
    // Note: 9 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5_V6_V7_V8() throws {
        // success
        do {
            let values: OSCValues = [
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999),
                OSCStringAltValue("str2")
            ]
            
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7.rawValue, 999)
            XCTAssertEqual(masked.8.string, "str2")
        }
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999),
                OSCStringAltValue("str2")
            ])
            .masked(
                Int64.self, // wrong type
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999)
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self
            )
        )
        
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999),
                OSCStringAltValue("str2"),
                OSCMIDIValue(portID: 0x00, status: 0xFF)
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o_V8o() throws {
        let values: OSCValues = [
            Int32(123),
            String("str"),
            true,
            Float32(456.78),
            Data([0x01]),
            Double(234.56),
            Character("C"),
            OSCTimeTag(999),
            OSCStringAltValue("str2")
        ]
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
        }
    }
    
    // MARK: - 10 Values
    // Note: 10 Values does not have exhaustive tests, only basic tests
    
    func testValues_V0_V1_V2_V3_V4_V5_V6_V7_V8_V9() throws {
        // success
        do {
            let values: OSCValues = [
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999),
                OSCStringAltValue("str2"),
                OSCMIDIValue(portID: 0x00, status: 0xFF)
            ]
            
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self,
                OSCMIDIValue.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7.rawValue, 999)
            XCTAssertEqual(masked.8.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        // wrong type
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(456.78),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999),
                OSCStringAltValue("str2"),
                OSCMIDIValue(portID: 0x00, status: 0xFF)
            ])
            .masked(
                Int64.self, // wrong type
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self,
                OSCMIDIValue.self
            )
        )
        
        // wrong number of values
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999),
                OSCStringAltValue("str2")
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self,
                OSCMIDIValue.self
            )
        )
        
        XCTAssertThrowsError(
            try OSCValues([
                Int32(123),
                String("str"),
                true,
                Float32(123.45),
                Data([0x01]),
                Double(234.56),
                Character("C"),
                OSCTimeTag(999),
                OSCStringAltValue("str2"),
                OSCMIDIValue(portID: 0x00, status: 0xFF),
                OSCNullValue()
            ])
            .masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self,
                OSCMIDIValue.self
            )
        )
    }
    
    func testValues_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o_V8o_V9o() throws {
        let values: OSCValues = [
            Int32(123),
            String("str"),
            true,
            Float32(456.78),
            Data([0x01]),
            Double(234.56),
            Character("C"),
            OSCTimeTag(999),
            OSCStringAltValue("str2"),
            OSCMIDIValue(portID: 0x00, status: 0xFF)
        ]
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7.rawValue, 999)
            XCTAssertEqual(masked.8.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self,
                Double?.self,
                Character?.self,
                OSCTimeTag?.self,
                OSCStringAltValue?.self,
                OSCMIDIValue?.self
            )
            
            XCTAssertEqual(masked.0, 123)
            XCTAssertEqual(masked.1, "str")
            XCTAssertEqual(masked.2, true)
            XCTAssertEqual(masked.3, 456.78)
            XCTAssertEqual(masked.4, Data([0x01]))
            XCTAssertEqual(masked.5, 234.56)
            XCTAssertEqual(masked.6, "C")
            XCTAssertEqual(masked.7?.rawValue, 999)
            XCTAssertEqual(masked.8?.string, "str2")
            XCTAssertEqual(masked.9, OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
    }
    
    // MARK: - Substitute types
    
    func testSubstitution_Int() throws {
        XCTAssertEqual(
            try OSCValues([Int32(123)])
                .masked(Int.self),
            123
        )
        
        XCTAssertEqual(
            try OSCValues([Int64(123)])
                .masked(Int.self),
            123
        )
        
        XCTAssertThrowsError(
            try OSCValues([Double(123)])
                .masked(Int.self)
        )
    }
    
    func testSubstitution_Int_Optional() throws {
        XCTAssertEqual(
            try OSCValues([Int32(123)])
                .masked(Int?.self),
            123
        )
        
        XCTAssertEqual(
            try OSCValues([Int64(123)])
                .masked(Int?.self),
            123
        )
        
        XCTAssertThrowsError(
            try OSCValues([Double(123)])
                .masked(Int?.self)
        )
    }
    
    func testExclusivity_String() throws {
        // String should not substitute other string types
        // in the way that Int substitutes other integers.
        
        // String == String
        XCTAssertEqual(
            try OSCValues([String("str")])
                .masked(String.self),
            "str"
        )
        
        // OSCStringAltValue != String
        XCTAssertThrowsError(
            try OSCValues([OSCStringAltValue("str")])
                .masked(String.self)
        )
        
        // Character != String
        XCTAssertThrowsError(
            try OSCValues([Character("s")])
                .masked(String.self)
        )
    }
    
    func testExclusivity_Character() throws {
        // Character should not substitute other string types
        // in the way that Int substitutes other integers.
        
        // Character == Character
        XCTAssertEqual(
            try OSCValues([Character("a")])
                .masked(Character.self),
            "a"
        )
        
        // String != Character
        XCTAssertThrowsError(
            try OSCValues([String("a")])
                .masked(Character.self)
        )
        
        // OSCStringAltValue != Character
        XCTAssertThrowsError(
            try OSCValues([OSCStringAltValue("a")])
                .masked(Character.self)
        )
        
        // String of count>1 != Character
        XCTAssertThrowsError(
            try OSCValues([String("ab")])
                .masked(Character.self)
        )
        
        // OSCStringAltValue of count>1 != Character
        XCTAssertThrowsError(
            try OSCValues([OSCStringAltValue("ab")])
                .masked(Character.self)
        )
    }
    
    // MARK: - Meta type: AnyOSCNumberValue
    
    func testAnyOSCNumberValue_Int32() throws {
        let values: OSCValues = [Int32(123)]
        
        let masked = try values.masked(AnyOSCNumberValue.self)
        
        guard case let .int(v) = masked.base,
              let unwrapped = v as? Int32
        else { XCTFail(); return }
        
        XCTAssertEqual(unwrapped, 123)
    }
    
    func testAnyOSCNumberValue_Float32() throws {
        let values: OSCValues = [Float32(123.45)]
        
        let masked = try values.masked(AnyOSCNumberValue.self)
        
        guard case let .float(v) = masked.base,
              let unwrapped = v as? Float32
        else { XCTFail(); return }
        
        XCTAssertEqual(unwrapped, 123.45)
    }
    
    func testAnyOSCNumberValue_Int64() throws {
        let values: OSCValues = [Int64(123)]
        
        let masked = try values.masked(AnyOSCNumberValue.self)
        
        guard case let .int(v) = masked.base,
              let unwrapped = v as? Int64
        else { XCTFail(); return }
        
        XCTAssertEqual(unwrapped, 123)
    }
    
    func testAnyOSCNumberValue_Double() throws {
        let values: OSCValues = [Double(123.45)]
        
        let masked = try values.masked(AnyOSCNumberValue.self)
        
        guard case let .float(v) = masked.base,
              let unwrapped = v as? Double
        else { XCTFail(); return }
        
        XCTAssertEqual(unwrapped, 123.45)
    }
    
    func testAnyOSCNumberValue_Int32_Optional() throws {
        let values: OSCValues = [Int32(123)]
        
        let masked = try values.masked(AnyOSCNumberValue?.self)
        
        guard case let .int(v) = masked?.base,
              let unwrapped = v as? Int32
        else { XCTFail(); return }
        
        XCTAssertEqual(unwrapped, Int32(123))
    }
    
    func testAnyOSCNumberValue_Int32_Optional_Nil() throws {
        let values: OSCValues = []
        
        let masked = try values.masked(AnyOSCNumberValue?.self)
        
        XCTAssertEqual(masked, nil)
    }
}

#endif
