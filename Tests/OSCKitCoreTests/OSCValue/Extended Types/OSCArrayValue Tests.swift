//
//  OSCArrayValue Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import Testing

@Suite struct OSCArrayValue_Tests {
    @Test
    func empty() async throws {
        let msg = OSCMessage("/test", values: [OSCArrayValue([])])
        
        #expect(msg.values[0] as? OSCArrayValue == OSCArrayValue([]))
        
        // test encode and decode
        let rawData = try msg.rawData()
        let decodedMsg = try OSCMessage(from: rawData)
        #expect(msg == decodedMsg)
    }
    
    @Test
    func simple() async throws {
        let msg = OSCMessage("/test", values: [OSCArrayValue([Int32(123)])])
        
        #expect(msg.values[0] as? OSCArrayValue == OSCArrayValue([Int32(123)]))
        
        // test encode and decode
        let rawData = try msg.rawData()
        let decodedMsg = try OSCMessage(from: rawData)
        #expect(msg == decodedMsg)
    }
    
    @Test
    func nested() async throws {
        let msg = OSCMessage(
            "/test",
            values: [
                Int32(123),
                
                OSCArrayValue([
                    true,
                    String("A string"),
                    OSCArrayValue([
                        false
                    ])
                ]),
                
                Double(1.5),
                
                OSCArrayValue([
                    // empty array
                ]),
                
                OSCArrayValue([
                    String("Another string")
                ])
            ]
        )
        
        #expect(msg.values[0] as? Int32 == Int32(123))
        
        let val1 = try #require(msg.values[1] as? OSCArrayValue)
        #expect(val1.elements[0] as? Bool == true)
        #expect(val1.elements[1] as? String == String("A string"))
        let val1C = try #require(val1.elements[2] as? OSCArrayValue)
        #expect(val1C.elements[0] as? Bool == false)
        
        #expect(msg.values[2] as? Double == Double(1.5))
        
        let val3 = try #require(msg.values[3] as? OSCArrayValue)
        #expect(val3.elements.isEmpty)
        
        let val4 = try #require(msg.values[4] as? OSCArrayValue)
        #expect(val4.elements[0] as? String == String("Another string"))
        
        // test encode and decode
        let rawData = try msg.rawData()
        let decodedMsg = try OSCMessage(from: rawData)
        #expect(msg == decodedMsg)
    }
    
    // MARK: - `any OSCValue` Constructors
    
    @Test
    func oscValue_array() {
        let val: any OSCValue = .array([Int32(123)])
        #expect(
            val as? OSCArrayValue ==
                OSCArrayValue([Int32(123)])
        )
    }
    
    // MARK: - Equatable Operators
    
    @Test
    func equatable() {
        let oscArray1 = OSCArrayValue([123, "A string"])
        let oscArray2 = OSCArrayValue([123, "A string"])
        
        #expect(oscArray1 == oscArray2)
        #expect(oscArray2 == oscArray1)
        
        #expect(!(oscArray1 != oscArray2))
        #expect(!(oscArray2 != oscArray1))
    }
    
    @Test
    func equatableWithArray() {
        let array: [any OSCValue] = [123, "A string"]
        let oscArray = OSCArrayValue([123, "A string"])
        
        #expect(array == oscArray)
        #expect(oscArray == array)
        
        #expect(!(array != oscArray))
        #expect(!(oscArray != array))
    }
}
