//
//  OSCValues Type Mask Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore
import SwiftASCII
import Testing

@Suite struct OSCValues_TypeMask_Tests {
    // MARK: - 1 Value
    
    @Test
    func values_V0() throws {
        // success
        #expect(
            try OSCValues([Int32(123)])
                .masked(Int32.self) ==
                123
        )
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Int32(123)])
                .masked(Int64.self)
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([])
                .masked(Int32.self)
        }
        
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Int32(123), String("str")])
                .masked(Int32.self)
        }
    }
    
    @Test
    func values_V0o() throws {
        // success, has value
        #expect(
            try OSCValues([Int32(123)])
                .masked(Int32?.self) ==
                123
        )
        
        // success, nil optional
        #expect(
            try OSCValues([])
                .masked(Int32?.self) ==
                nil
        )
    }
    
    // MARK: - 2 Values
    
    @Test
    func values_V0_V1() throws {
        // success
        do {
            let values: OSCValues = [Int32(123), String("str")]
            
            let masked = try values.masked(Int32.self, String.self)
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Int32(123), String("str")])
                .masked(Int64.self, String.self)
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Int32(123)])
                .masked(Int32.self, String.self)
        }
        
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Int32(123), String("str"), true])
                .masked(Int32.self, String.self)
        }
    }
    
    @Test
    func values_V0_V1o() throws {
        // success, has value
        do {
            let masked = try OSCValues([Int32(123), String("str")])
                .masked(Int32.self, String?.self)
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
        }
        
        // success, nil optional
        do {
            let masked = try OSCValues([Int32(123)])
                .masked(Int32.self, String?.self)
            
            #expect(masked.0 == 123)
            #expect(masked.1 == nil)
        }
        
        // wrong value type
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Int32(123), true])
                .masked(Int32.self, String?.self)
        }
    }
    
    @Test
    func values_V0o_V1o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
        }
        
        // success, nil optional
        do {
            let masked = try OSCValues([Int32(123)])
                .masked(
                    Int32?.self,
                    String?.self
                )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == nil)
        }
        
        // success, nil optional
        do {
            let masked = try OSCValues([])
                .masked(
                    Int32?.self,
                    String?.self
                )
            
            #expect(masked.0 == nil)
            #expect(masked.1 == nil)
        }
        
        // wrong value type
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Int32(123), true])
                .masked(
                    Int32?.self,
                    String?.self
                )
        }
    }
    
    // MARK: - 3 Values
    // Note: 3 Values does not have exhaustive tests, only basic tests
    
    @Test
    func values_V0_V1_V2() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Int32(123), String("str")])
                .masked(
                    Int32.self,
                    String.self,
                    Bool.self
                )
        }
        
        #expect(throws: OSCValueMaskError.self) {
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
        }
    }
    
    @Test
    func values_V0o_V1o_V2o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
        }
        
        do {
            let masked = try OSCValues([]).masked(
                Int32?.self,
                String?.self,
                Bool?.self
            )
            
            #expect(masked.0 == nil)
            #expect(masked.1 == nil)
            #expect(masked.2 == nil)
        }
    }
    
    // MARK: - 4 Values
    // Note: 4 Values does not have exhaustive tests, only basic tests
    
    @Test
    func values_V0_V1_V2_V3() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        #expect(throws: OSCValueMaskError.self) {
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
        }
    }
    
    @Test
    func values_V0o_V1o_V2o_V3o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
        }
    }
    
    // MARK: - 5 Values
    // Note: 5 Values does not have exhaustive tests, only basic tests
    
    @Test
    func values_V0_V1_V2_V3_V4() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        #expect(throws: OSCValueMaskError.self) {
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
        }
    }
    
    @Test
    func values_V0o_V1o_V2o_V3o_V4o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool.self,
                Float32?.self,
                Data?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
        }
        
        do {
            let masked = try values.masked(
                Int32.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
        }
        
        do {
            let masked = try values.masked(
                Int32?.self,
                String?.self,
                Bool?.self,
                Float32?.self,
                Data?.self
            )
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
        }
    }
    
    // MARK: - 6 Values
    // Note: 6 Values does not have exhaustive tests, only basic tests
    
    @Test
    func values_V0_V1_V2_V3_V4_V5() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        #expect(throws: OSCValueMaskError.self) {
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
        }
    }
    
    @Test
    func values_V0o_V1o_V2o_V3o_V4o_V5o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
        }
    }
    
    // MARK: - 7 Values
    // Note: 7 Values does not have exhaustive tests, only basic tests
    
    @Test
    func values_V0_V1_V2_V3_V4_V5_V6() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        #expect(throws: OSCValueMaskError.self) {
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
        }
    }
    
    @Test
    func values_V0o_V1o_V2o_V3o_V4o_V5o_V6o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
        }
    }
    
    // MARK: - 8 Values
    // Note: 8 Values does not have exhaustive tests, only basic tests
    
    @Test
    func values_V0_V1_V2_V3_V4_V5_V6_V7() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7.rawValue == 999)
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        #expect(throws: OSCValueMaskError.self) {
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
        }
    }
    
    @Test
    func values_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
        }
    }
    
    // MARK: - 9 Values
    // Note: 9 Values does not have exhaustive tests, only basic tests
    
    @Test
    func values_V0_V1_V2_V3_V4_V5_V6_V7_V8() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7.rawValue == 999)
            #expect(masked.8.string == "str2")
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        #expect(throws: OSCValueMaskError.self) {
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
        }
    }
    
    @Test
    func values_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o_V8o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7.rawValue == 999)
            #expect(masked.8?.string == "str2")
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
        }
    }
    
    // MARK: - 10 Values
    // Note: 10 Values does not have exhaustive tests, only basic tests
    
    @Test
    func values_V0_V1_V2_V3_V4_V5_V6_V7_V8_V9() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7.rawValue == 999)
            #expect(masked.8.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
        
        // wrong type
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        // wrong number of values
        #expect(throws: OSCValueMaskError.self) {
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
        }
        
        #expect(throws: OSCValueMaskError.self) {
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
        }
    }
    
    @Test
    func values_V0o_V1o_V2o_V3o_V4o_V5o_V6o_V7o_V8o_V9o() throws {
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7.rawValue == 999)
            #expect(masked.8.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
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
            
            #expect(masked.0 == 123)
            #expect(masked.1 == "str")
            #expect(masked.2 == true)
            #expect(masked.3 == 456.78)
            #expect(masked.4 == Data([0x01]))
            #expect(masked.5 == 234.56)
            #expect(masked.6 == Character("C"))
            #expect(masked.7?.rawValue == 999)
            #expect(masked.8?.string == "str2")
            #expect(masked.9 == OSCMIDIValue(portID: 0x00, status: 0xFF))
        }
    }
    
    // MARK: - Substitute types
    
    @Test
    func substitution_Int() throws {
        #expect(
            try OSCValues([Int32(123)])
                .masked(Int.self) ==
                123
        )
        
        #expect(
            try OSCValues([Int64(123)])
                .masked(Int.self) ==
                123
        )
        
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Double(123)])
                .masked(Int.self)
        }
    }
    
    @Test
    func substitution_Int_Optional() throws {
        #expect(
            try OSCValues([Int32(123)])
                .masked(Int?.self) ==
                123
        )
        
        #expect(
            try OSCValues([Int64(123)])
                .masked(Int?.self) ==
                123
        )
        
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Double(123)])
                .masked(Int?.self)
        }
    }
    
    @Test
    func exclusivity_String() throws {
        // String should not substitute other string types
        // in the way that Int substitutes other integers.
        
        // String == String
        #expect(
            try OSCValues([String("str")])
                .masked(String.self) ==
                "str"
        )
        
        // OSCStringAltValue != String
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([OSCStringAltValue("str")])
                .masked(String.self)
        }
        
        // Character != String
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([Character("s")])
                .masked(String.self)
        }
    }
    
    @Test
    func exclusivity_Character() throws {
        // Character should not substitute other string types
        // in the way that Int substitutes other integers.
        
        // Character == Character
        #expect(
            try OSCValues([Character("a")])
                .masked(Character.self) ==
                Character("a")
        )
        
        // String != Character
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([String("a")])
                .masked(Character.self)
        }
        
        // OSCStringAltValue != Character
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([OSCStringAltValue("a")])
                .masked(Character.self)
        }
        
        // String of count>1 != Character
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([String("ab")])
                .masked(Character.self)
        }
        
        // OSCStringAltValue of count>1 != Character
        #expect(throws: OSCValueMaskError.self) {
            try OSCValues([OSCStringAltValue("ab")])
                .masked(Character.self)
        }
    }
    
    // MARK: - Meta type: AnyOSCNumberValue
    
    @Test
    func anyOSCNumberValue_Int32() throws {
        let values: OSCValues = [Int32(123)]
        
        let masked = try values.masked(AnyOSCNumberValue.self)
        
        guard case let .int(v) = masked.base,
              let unwrapped = v as? Int32
        else { Issue.record(); return }
        
        #expect(unwrapped == 123)
    }
    
    @Test
    func anyOSCNumberValue_Float32() throws {
        let values: OSCValues = [Float32(123.45)]
        
        let masked = try values.masked(AnyOSCNumberValue.self)
        
        guard case let .float(v) = masked.base,
              let unwrapped = v as? Float32
        else { Issue.record(); return }
        
        #expect(unwrapped == 123.45)
    }
    
    @Test
    func anyOSCNumberValue_Int64() throws {
        let values: OSCValues = [Int64(123)]
        
        let masked = try values.masked(AnyOSCNumberValue.self)
        
        guard case let .int(v) = masked.base,
              let unwrapped = v as? Int64
        else { Issue.record(); return }
        
        #expect(unwrapped == 123)
    }
    
    @Test
    func anyOSCNumberValue_Double() throws {
        let values: OSCValues = [Double(123.45)]
        
        let masked = try values.masked(AnyOSCNumberValue.self)
        
        guard case let .float(v) = masked.base,
              let unwrapped = v as? Double
        else { Issue.record(); return }
        
        #expect(unwrapped == 123.45)
    }
    
    @Test
    func anyOSCNumberValue_Int32_Optional() throws {
        let values: OSCValues = [Int32(123)]
        
        let masked = try values.masked(AnyOSCNumberValue?.self)
        
        guard case let .int(v) = masked?.base,
              let unwrapped = v as? Int32
        else { Issue.record(); return }
        
        #expect(unwrapped == Int32(123))
    }
    
    @Test
    func anyOSCNumberValue_Int32_Optional_Nil() throws {
        let values: OSCValues = []
        
        let masked = try values.masked(AnyOSCNumberValue?.self)
        
        #expect(masked == nil)
    }
}
