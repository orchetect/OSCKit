//
//  OSCAddressSpace Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import OSCKitCore
import Testing

@Suite struct OSCAddressSpace_Tests {
    // MARK: - Address Registration
    
    @Test
    func registerAddress_PathComponents() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: ["test1"])
        let t2ID = addressSpace.register(localAddress: ["test1", "test2"])
        let t3ID = addressSpace.register(localAddress: ["test3", "test4"])
        
        // basic verbatim match to check if register worked
        
        #expect(
            addressSpace.methods(matching: .init("/test1")) ==
                [t1ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2")) ==
                [t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test3/test4")) ==
                [t3ID]
        )
    }
    
    @Test
    func registerAddress_EmptyAddress() async throws {
        // only asserts in debug builds. only testable with Xcode 26+ on macOS.
        #if os(macOS) && DEBUG && compiler(>=6.2)
        await #expect(processExitsWith: .failure) {
            let addressSpace = OSCAddressSpace()
            let _ = addressSpace.register(localAddress: "")
        }
        #endif
    }
    
    @Test
    func registerAddress_PathComponents_EmptyAddress() async throws {
        // only asserts in debug builds. only testable with Xcode 26+ on macOS.
        #if os(macOS) && DEBUG && compiler(>=6.2)
        await #expect(processExitsWith: .failure) {
            let addressSpace = OSCAddressSpace()
            let _ = addressSpace.register(localAddress: [] as [String])
        }
        #endif
    }
    
    @Test
    func unregisterAddress() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test3/methodA"); _ = t1ID
        let t2ID = addressSpace.register(localAddress: "/test2/test4/methodB")
        
        #expect(
            addressSpace.unregister(localAddress: "/test1/test3/methodA")
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test2/test4/methodB")) ==
                [t2ID]
        )
        
        // should not match containers which are not also methods
        
        #expect(
            addressSpace.methods(matching: .init("/test1")).isEmpty
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test3")).isEmpty
        )
    }
    
    @Test
    func unregisterAddress_PathComponents() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test3/methodA"); _ = t1ID
        let t2ID = addressSpace.register(localAddress: "/test2/test4/methodB")
        
        #expect(
            addressSpace.unregister(localAddress: ["test1", "test3", "methodA"])
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test2/test4/methodB")) ==
                [t2ID]
        )
        
        // should not match containers which are not also methods
        
        #expect(
            addressSpace.methods(matching: .init("/test1")).isEmpty
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test3")).isEmpty
        )
    }
    
    @Test
    func registerAddress_MethodThatAlsoBecomesAContainer() throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = addressSpace.register(localAddress: "/test1/test2")
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        
        // confirm registrations worked and match as methods
        #expect(
            addressSpace.methods(matching: .init("/test1/test2")) ==
                [t0ID]
        )
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
    }
    
    @Test
    func registerAddress_ContainerThatBecomesAMethod() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        let t0ID = addressSpace.register(localAddress: "/test1/test2")
        
        // confirm registrations worked and match as methods
        #expect(
            addressSpace.methods(matching: .init("/test1/test2")) ==
                [t0ID]
        )
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
    }
    
    @Test
    func unregisterAddress_MethodThatAlsoBecomesAContainer_RemoveMethod() throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = addressSpace.register(localAddress: "/test1/test2")
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        
        // unregister downstream method
        #expect(
            addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                []
        )
        
        // should not modify pre-existing methods that were also containers
        #expect(
            addressSpace.methods(matching: .init("/test1/test2")) ==
                [t0ID]
        )
        
        // attempt to unregister again
        #expect(
            !addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
    }
    
    @Test
    func unregisterAddress_ContainerThatBecomesAMethod_RemoveMethod() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        let t0ID = addressSpace.register(localAddress: "/test1/test2")
        
        // unregister downstream method
        #expect(
            addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                []
        )
        
        // should not modify pre-existing methods that were also containers
        #expect(
            addressSpace.methods(matching: .init("/test1/test2")) ==
                [t0ID]
        )
        
        // attempt to unregister again
        #expect(
            !addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
    }
    
    @Test
    func unregisterAddress_MethodThatAlsoBecomesAContainer_RemoveContainer() throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = addressSpace.register(localAddress: "/test1/test2"); _ = t0ID
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA")
        
        // unregister midstream container method
        #expect(
            addressSpace.unregister(localAddress: ["test1", "test2"])
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2")) ==
                []
        )
        
        // should not modify pre-existing downstream methods or containers
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
        
        // attempt to unregister again
        #expect(
            !addressSpace.unregister(localAddress: ["test1", "test2"])
        )
    }
    
    @Test
    func unregisterAddress_ContainerThatBecomesAMethod_RemoveContainer() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA")
        let t0ID = addressSpace.register(localAddress: "/test1/test2"); _ = t0ID
        
        // unregister midstream container method
        #expect(
            addressSpace.unregister(localAddress: ["test1", "test2"])
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2")) ==
                []
        )
        
        // should not modify pre-existing downstream methods or containers
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
        
        // attempt to unregister again
        #expect(
            !addressSpace.unregister(localAddress: ["test1", "test2"])
        )
    }
    
    @Test
    func unregisterAllAddresses() throws {
        let addressSpace = OSCAddressSpace()
        
        _ = addressSpace.register(localAddress: "/test1/test3/methodA")
        _ = addressSpace.register(localAddress: "/test2/test4/methodB")
        
        addressSpace.unregisterAll()
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test2/test4/methodB")) ==
                []
        )
        
        // containers still exist
        
        #expect(
            addressSpace.methods(matching: .init("/test1")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test3")) ==
                []
        )
    }
    
    // MARK: - Matches
    
    @Test
    func methodsMatching_Root() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1")
        let t2ID = addressSpace.register(localAddress: "/test2")
        _ = addressSpace.register(localAddress: "/test1/test1B") // not tested
        
        // non-matches
        
        #expect(
            addressSpace.methods(matching: .init("/test")) ==
                []
        )
        
        // verbatim matches
        
        #expect(
            addressSpace.methods(matching: .init("/test1")) ==
                [t1ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test2")) ==
                [t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/")) ==
                [t1ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test2/")) ==
                [t2ID]
        )
        
        // wildcards
        
        #expect(
            addressSpace.methods(matching: .init("/test?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test*")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test[12]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test[!3]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test{1,2}")) ==
                [t1ID, t2ID]
        )
        
        // edge cases
        
        #expect(
            addressSpace.methods(matching: .init("")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/")) ==
                []
        )
    }
    
    @Test
    func methodsMatching_NestedMethods() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA")
        let t2ID = addressSpace.register(localAddress: "/test1/test2/methodB")
                
        // non-matches
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/method")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodAA")) ==
                []
        )
        
        // verbatim matches
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodB")) ==
                [t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodA/")) ==
                [t1ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/methodB/")) ==
                [t2ID]
        )
        
        // wildcards
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/method*")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/method[AB]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/method[!C]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test1/test2/method{A,B}")) ==
                [t1ID, t2ID]
        )
        
        // partial path matches should not return containers
        
        #expect(
            addressSpace.methods(matching: .init("/test1")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test?")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test*")) ==
                []
        )
        
        // edge cases
        
        #expect(
            addressSpace.methods(matching: .init("")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/")) ==
                []
        )
    }
    
    @Test
    func methodsMatching_MultipleContainerMatches() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test3/methodA")
        let t2ID = addressSpace.register(localAddress: "/test2/test4/methodB")
        
        // wildcard matches
        
        #expect(
            addressSpace.methods(matching: .init("/test?/test?/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/*/test?/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test?/*/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/*/*/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            addressSpace.methods(matching: .init("/*/*/*")) ==
                [t1ID, t2ID]
        )
        
        // wildcard returning containers instead of methods
        // (don't test for equal arrays since the ordering may differ on each execution)
        
        do {
            let matches = addressSpace.methods(matching: .init("/*/*/*"))
            
            #expect(matches.count == 2)
            #expect(matches.contains(t1ID))
            #expect(matches.contains(t2ID))
        }
        
        #expect(
            addressSpace.methods(matching: .init("/*")) ==
                []
        )
           
        #expect(
            addressSpace.methods(matching: .init("/*/*")) ==
                []
        )
        
        #expect(
            addressSpace.methods(matching: .init("/test?/test?")) ==
                []
        )
    }
    
    @Test
    func methodsMatching_EdgeCases() {
        // ensure addresses are not sanitized in an unexpected way
        
        let addressSpace = OSCAddressSpace()
        
        do {
            let addr = "/test1/test3/vol-"
            let id = addressSpace.register(localAddress: addr)
            #expect(
                addressSpace.methods(matching: .init(addr)) == [id]
            )
        }
        do {
            let addr = "/test2/test4/vol+"
            let id = addressSpace.register(localAddress: addr)
            #expect(
                addressSpace.methods(matching: .init(addr)) == [id]
            )
        }
        do {
            let addr = #"/test2/test4/ajL_-du &@!)(}].,;:%$|\-"#
            let id = addressSpace.register(localAddress: addr)
            #expect(
                addressSpace.methods(matching: .init(addr)) == [id]
            )
        }
    }
    
    @Test
    func dispatchMatching() async throws {
        let addressSpace = OSCAddressSpace()
        
        var id1: OSCAddressSpace.MethodID!
        var id2: OSCAddressSpace.MethodID!
        var id3: OSCAddressSpace.MethodID!
        var methodIDs: [OSCAddressSpace.MethodID]!
        
        try await confirmation(expectedCount: 11) { confirmation in
            id1 = addressSpace.register(localAddress: "/base/test1") { values, host, port in
                #expect(values == ["A string", 123])
                confirmation.confirm(count: 1)
            }
            
            id2 = addressSpace.register(localAddress: "/base/test2") { values, host, port in
                #expect(values == ["A string", 123])
                confirmation.confirm(count: 10)
            }
            
            // this shouldn't be called
            id3 = addressSpace.register(localAddress: "/base/blah3") { values, host, port in
                confirmation.confirm(count: 100)
            }
            
            methodIDs = addressSpace.dispatch(
                message: OSCMessage("/base/test?", values: ["A string", 123]),
                host: "localhost",
                port: 8000
            )
            
            try await Task.sleep(seconds: 0.5)
        }
        
        #expect(methodIDs.count == 2)
        #expect(methodIDs.contains(id1))
        #expect(methodIDs.contains(id2))
        _ = id3
    }
}
