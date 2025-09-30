//
//  OSCAddressSpace Utilities Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import OSCKitCore
import Testing

@Suite struct OSCAddressSpace_Utilities_Tests {
    @Test
    func nodeValidateName() {
        #expect(
            !OSCAddressSpace.Node.validate(name: "")
        )
        
        #expect(
            OSCAddressSpace.Node.validate(name: " ")
        )
        
        #expect(
            OSCAddressSpace.Node.validate(name: "abcDEF1234")
        )
        
        #expect(
            OSCAddressSpace.Node.validate(name: "abc]p} ,.DEF1234-")
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc?d")
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc*")
        )
        
        #expect(
            OSCAddressSpace.Node.validate(name: "a bc")
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc{d,e}f")
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc{d,e}f")
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "/abcDEF1234")
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abcDEF1234/")
        )
    }
    
    @Test
    func nodeValidateNameStrict() {
        #expect(
            !OSCAddressSpace.Node.validate(name: "", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: " ", strict: true)
        )
        
        #expect(
            OSCAddressSpace.Node.validate(name: "abcDEF1234", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc]p} ,.DEF1234-", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc?d", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc*", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "a bc", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abc{d,e}f", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "/abcDEF1234", strict: true)
        )
        
        #expect(
            !OSCAddressSpace.Node.validate(name: "abcDEF1234/", strict: true)
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
        #expect(await addressSpace.methodID(path: [] as [String]) != nil)
        
        // containers have a method ID even though they are not a method
        #expect(await addressSpace.methodID(path: ["test1"]) != nil)
    }
}
