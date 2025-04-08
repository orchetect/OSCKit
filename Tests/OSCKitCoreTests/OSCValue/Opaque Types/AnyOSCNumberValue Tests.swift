//
//  AnyOSCNumberValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import OSCKitCore
import Testing

@Suite struct AnyOSCNumberValue_Tests {
    // MARK: - boolValue
    
    @Test
    func bool_boolValue() {
        #expect(AnyOSCNumberValue(true as Bool).boolValue == true)
        #expect(AnyOSCNumberValue(false as Bool).boolValue == false)
    }
    
    @Test
    func int_boolValue() {
        #expect(AnyOSCNumberValue(-1 as Int).boolValue == false)
        #expect(AnyOSCNumberValue(0 as Int).boolValue == false)
        #expect(AnyOSCNumberValue(1 as Int).boolValue == true)
        #expect(AnyOSCNumberValue(2 as Int).boolValue == true)
    }
    
    @Test
    func int32_boolValue() {
        #expect(AnyOSCNumberValue(-1 as Int32).boolValue == false)
        #expect(AnyOSCNumberValue(0 as Int32).boolValue == false)
        #expect(AnyOSCNumberValue(1 as Int32).boolValue == true)
        #expect(AnyOSCNumberValue(2 as Int32).boolValue == true)
    }
    
    @Test
    func double_boolValue() {
        #expect(AnyOSCNumberValue(-1.0 as Double).boolValue == false)
        #expect(AnyOSCNumberValue(0.0 as Double).boolValue == false)
        #expect(AnyOSCNumberValue(0.99 as Double).boolValue == false)
        #expect(AnyOSCNumberValue(1.0 as Double).boolValue == true)
        #expect(AnyOSCNumberValue(2.0 as Double).boolValue == true)
    }
    
    // MARK: - intValue
    
    @Test
    func bool_intValue() {
        #expect(AnyOSCNumberValue(true as Bool).intValue == 1)
        #expect(AnyOSCNumberValue(false as Bool).intValue == 0)
    }
    
    @Test
    func int_intValue() {
        #expect(AnyOSCNumberValue(-1 as Int).intValue == -1)
        #expect(AnyOSCNumberValue(0 as Int).intValue == 0)
        #expect(AnyOSCNumberValue(1 as Int).intValue == 1)
        #expect(AnyOSCNumberValue(2 as Int).intValue == 2)
    }
    
    @Test
    func int32_intValue() {
        #expect(AnyOSCNumberValue(-1 as Int32).intValue == -1)
        #expect(AnyOSCNumberValue(0 as Int32).intValue == 0)
        #expect(AnyOSCNumberValue(1 as Int32).intValue == 1)
        #expect(AnyOSCNumberValue(2 as Int32).intValue == 2)
    }
    
    @Test
    func double_intValue() {
        #expect(AnyOSCNumberValue(-1.0 as Double).intValue == -1)
        #expect(AnyOSCNumberValue(0.0 as Double).intValue == 0)
        #expect(AnyOSCNumberValue(0.99 as Double).intValue == 0)
        #expect(AnyOSCNumberValue(1.0 as Double).intValue == 1)
        #expect(AnyOSCNumberValue(2.0 as Double).intValue == 2)
    }
    
    // MARK: - doubleValue
    
    @Test
    func bool_doubleValue() {
        #expect(AnyOSCNumberValue(true as Bool).doubleValue == 1.0)
        #expect(AnyOSCNumberValue(false as Bool).doubleValue == 0.0)
    }
    
    @Test
    func int_doubleValue() {
        #expect(AnyOSCNumberValue(-1 as Int).doubleValue == -1.0)
        #expect(AnyOSCNumberValue(0 as Int).doubleValue == 0.0)
        #expect(AnyOSCNumberValue(1 as Int).doubleValue == 1.0)
        #expect(AnyOSCNumberValue(2 as Int).doubleValue == 2.0)
    }
    
    @Test
    func int32_doubleValue() {
        #expect(AnyOSCNumberValue(-1 as Int32).doubleValue == -1.0)
        #expect(AnyOSCNumberValue(0 as Int32).doubleValue == 0.0)
        #expect(AnyOSCNumberValue(1 as Int32).doubleValue == 1.0)
        #expect(AnyOSCNumberValue(2 as Int32).doubleValue == 2.0)
    }
    
    @Test
    func double_doubleValue() {
        #expect(AnyOSCNumberValue(-1.0 as Double).doubleValue == -1.0)
        #expect(AnyOSCNumberValue(0.0 as Double).doubleValue == 0.0)
        #expect(AnyOSCNumberValue(0.99 as Double).doubleValue == 0.99)
        #expect(AnyOSCNumberValue(1.0 as Double).doubleValue == 1.0)
        #expect(AnyOSCNumberValue(2.0 as Double).doubleValue == 2.0)
    }
}
