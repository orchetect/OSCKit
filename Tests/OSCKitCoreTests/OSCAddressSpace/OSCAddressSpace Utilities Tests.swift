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
}
