//
//  OSCAddressSpace Utilities Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import struct Foundation.UUID
@testable import OSCKitCore
import Testing

@Suite struct OSCAddressSpace_Utilities_Tests {
    @Test
    func nodeValidateName() {
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "")
        )
        
        #expect(
            OSCAddressSpace<UUID>.Node.validate(name: " ")
        )
        
        #expect(
            OSCAddressSpace<UUID>.Node.validate(name: "abcDEF1234")
        )
        
        #expect(
            OSCAddressSpace<UUID>.Node.validate(name: "abc]p} ,.DEF1234-")
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc?d")
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc*")
        )
        
        #expect(
            OSCAddressSpace<UUID>.Node.validate(name: "a bc")
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc{d,e}f")
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc{d,e}f")
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "/abcDEF1234")
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abcDEF1234/")
        )
    }
    
    @Test
    func nodeValidateNameStrict() {
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: " ", strict: true)
        )
        
        #expect(
            OSCAddressSpace<UUID>.Node.validate(name: "abcDEF1234", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc]p} ,.DEF1234-", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc?d", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc*", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "a bc", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "/abcDEF1234", strict: true)
        )
        
        #expect(
            !OSCAddressSpace<UUID>.Node.validate(name: "abcDEF1234/", strict: true)
        )
    }
    
    @Test
    func methodID_Path() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = await addressSpace.register(localAddress: "/test1/test2")
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        
        #expect(
            await addressSpace.methodID(path: ["test1", "test2"]) ==
                t0ID
        )
        #expect(
            await addressSpace.methodID(path: ["test1", "test2", "methodA"]) ==
                t1ID
        )
        
        // edge cases
        
        // root
        #expect(await addressSpace.methodID(path: [] as [String]) == nil)
        
        // containers do not have method IDs
        #expect(await addressSpace.methodID(path: ["test1"]) == nil)
    }
}
