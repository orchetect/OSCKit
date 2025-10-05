//
//  OSCAddressSpace Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import OSCKitCore
import Testing

@Suite struct OSCAddressSpace_Tests {
    // MARK: - Address Registration
    
    @Test
    func registerAddress_PathComponents() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: ["test1"])
        let t2ID = await addressSpace.register(localAddress: ["test1", "test2"])
        let t3ID = await addressSpace.register(localAddress: ["test3", "test4"])
        
        // basic verbatim match to check if register worked
        
        #expect(
            await addressSpace.methods(matching: .init("/test1")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2")) ==
                [t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test3/test4")) ==
                [t3ID]
        )
    }
    
    @Test
    func registerAddress_EmptyAddress() async throws {
        // only asserts in debug builds. only testable with Xcode 26+ on macOS.
        #if os(macOS) && DEBUG && compiler(>=6.2)
        await #expect(processExitsWith: .failure) {
            let addressSpace = OSCAddressSpace()
            let _ = await addressSpace.register(localAddress: "")
        }
        #endif
    }
    
    @Test
    func registerAddress_PathComponents_EmptyAddress() async throws {
        // only asserts in debug builds. only testable with Xcode 26+ on macOS.
        #if os(macOS) && DEBUG && compiler(>=6.2)
        await #expect(processExitsWith: .failure) {
            let addressSpace = OSCAddressSpace()
            let _ = await addressSpace.register(localAddress: [] as [String])
        }
        #endif
    }
    
    @Test
    func unregisterAddress() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1/test3/methodA"); _ = t1ID
        let t2ID = await addressSpace.register(localAddress: "/test2/test4/methodB")
        
        #expect(
            await addressSpace.unregister(localAddress: "/test1/test3/methodA")
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test2/test4/methodB")) ==
                [t2ID]
        )
        
        // should not match containers which are not also methods
        
        #expect(
            await addressSpace.methods(matching: .init("/test1")).isEmpty
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test3")).isEmpty
        )
    }
    
    @Test
    func unregisterAddress_PathComponents() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1/test3/methodA"); _ = t1ID
        let t2ID = await addressSpace.register(localAddress: "/test2/test4/methodB")
        
        #expect(
            await addressSpace.unregister(localAddress: ["test1", "test3", "methodA"])
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test2/test4/methodB")) ==
                [t2ID]
        )
        
        // should not match containers which are not also methods
        
        #expect(
            await addressSpace.methods(matching: .init("/test1")).isEmpty
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test3")).isEmpty
        )
    }
    
    @Test
    func unregisterAddress_MethodID() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1/test3/methodA"); _ = t1ID
        let t2ID = await addressSpace.register(localAddress: "/test2/test4/methodB")
        
        #expect(
            await addressSpace.unregister(methodID: t1ID)
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test2/test4/methodB")) ==
                [t2ID]
        )
        
        // cannot unregister a node that is a container
        let test2ID = try #require(await addressSpace.methodID(path: ["test2"]))
        #expect(await !addressSpace.unregister(methodID: test2ID))
        
        // cannot unregister root
        let rootID = try #require(await addressSpace.methodID(path: [] as [String]))
        #expect(await !addressSpace.unregister(methodID: rootID))
    }
    
    @Test
    func registerAddress_MethodThatAlsoBecomesAContainer() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = await addressSpace.register(localAddress: "/test1/test2")
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        
        // confirm registrations worked and match as methods
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2")) ==
                [t0ID]
        )
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
    }
    
    @Test
    func registerAddress_ContainerThatBecomesAMethod() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        let t0ID = await addressSpace.register(localAddress: "/test1/test2")
        
        // confirm registrations worked and match as methods
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2")) ==
                [t0ID]
        )
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
    }
    
    @Test
    func unregisterAddress_MethodThatAlsoBecomesAContainer_RemoveMethod() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = await addressSpace.register(localAddress: "/test1/test2")
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        
        // unregister downstream method
        #expect(
            await addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                []
        )
        
        // should not modify pre-existing methods that were also containers
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2")) ==
                [t0ID]
        )
        
        // attempt to unregister again
        #expect(
            await !addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
    }
    
    @Test
    func unregisterAddress_ContainerThatBecomesAMethod_RemoveMethod() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        let t0ID = await addressSpace.register(localAddress: "/test1/test2")
        
        // unregister downstream method
        #expect(
            await addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                []
        )
        
        // should not modify pre-existing methods that were also containers
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2")) ==
                [t0ID]
        )
        
        // attempt to unregister again
        #expect(
            await !addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
    }
    
    @Test
    func unregisterAddress_MethodThatAlsoBecomesAContainer_RemoveContainer() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = await addressSpace.register(localAddress: "/test1/test2"); _ = t0ID
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA")
        
        // unregister midstream container method
        #expect(
            await addressSpace.unregister(localAddress: ["test1", "test2"])
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2")) ==
                []
        )
        
        // should not modify pre-existing downstream methods or containers
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
        
        // attempt to unregister again
        #expect(
            await !addressSpace.unregister(localAddress: ["test1", "test2"])
        )
    }
    
    @Test
    func unregisterAddress_ContainerThatBecomesAMethod_RemoveContainer() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA")
        let t0ID = await addressSpace.register(localAddress: "/test1/test2"); _ = t0ID
        
        // unregister midstream container method
        #expect(
            await addressSpace.unregister(localAddress: ["test1", "test2"])
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2")) ==
                []
        )
        
        // should not modify pre-existing downstream methods or containers
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
        
        // attempt to unregister again
        #expect(
            await !addressSpace.unregister(localAddress: ["test1", "test2"])
        )
    }
    
    @Test
    func unregisterAllAddresses() async throws {
        let addressSpace = OSCAddressSpace()
        
        _ = await addressSpace.register(localAddress: "/test1/test3/methodA")
        _ = await addressSpace.register(localAddress: "/test2/test4/methodB")
        
        await addressSpace.unregisterAll()
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test2/test4/methodB")) ==
                []
        )
        
        // containers still exist
        
        #expect(
            await addressSpace.methods(matching: .init("/test1")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test3")) ==
                []
        )
    }
    
    // MARK: - Matches
    
    @Test
    func methodsMatching_Root() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1")
        let t2ID = await addressSpace.register(localAddress: "/test2")
        _ = await addressSpace.register(localAddress: "/test1/test1B") // not tested
        
        // non-matches
        
        #expect(
            await addressSpace.methods(matching: .init("/test")) ==
                []
        )
        
        // verbatim matches
        
        #expect(
            await addressSpace.methods(matching: .init("/test1")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test2")) ==
                [t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test2/")) ==
                [t2ID]
        )
        
        // wildcards
        
        #expect(
            await addressSpace.methods(matching: .init("/test?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test*")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test[12]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test[!3]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test{1,2}")) ==
                [t1ID, t2ID]
        )
        
        // edge cases
        
        #expect(
            await addressSpace.methods(matching: .init("")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/")) ==
                []
        )
    }
    
    @Test
    func methodsMatching_NestedMethods() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA")
        let t2ID = await addressSpace.register(localAddress: "/test1/test2/methodB")
                
        // non-matches
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/method")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodAA")) ==
                []
        )
        
        // verbatim matches
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodA")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodB")) ==
                [t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodA/")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/methodB/")) ==
                [t2ID]
        )
        
        // wildcards
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/method*")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/method[AB]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/method[!C]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test1/test2/method{A,B}")) ==
                [t1ID, t2ID]
        )
        
        // partial path matches should not return containers
        
        #expect(
            await addressSpace.methods(matching: .init("/test1")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test?")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test*")) ==
                []
        )
        
        // edge cases
        
        #expect(
            await addressSpace.methods(matching: .init("")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/")) ==
                []
        )
    }
    
    @Test
    func methodsMatching_MultipleContainerMatches() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: "/test1/test3/methodA")
        let t2ID = await addressSpace.register(localAddress: "/test2/test4/methodB")
        
        // wildcard matches
        
        #expect(
            await addressSpace.methods(matching: .init("/test?/test?/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/*/test?/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test?/*/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/*/*/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/*/*/*")) ==
                [t1ID, t2ID]
        )
        
        // wildcard returning containers instead of methods
        // (don't test for equal arrays since the ordering may differ on each execution)
        
        do {
            let matches = await addressSpace.methods(matching: .init("/*/*/*"))
            
            #expect(matches.count == 2)
            #expect(matches.contains(t1ID))
            #expect(matches.contains(t2ID))
        }
        
        #expect(
            await addressSpace.methods(matching: .init("/*")) ==
                []
        )
           
        #expect(
            await addressSpace.methods(matching: .init("/*/*")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: .init("/test?/test?")) ==
                []
        )
    }
    
    @Test
    func methodsMatching_EdgeCases() async {
        // ensure addresses are not sanitized in an unexpected way
        
        let addressSpace = OSCAddressSpace()
        
        do {
            let addr = "/test1/test3/vol-"
            let id = await addressSpace.register(localAddress: addr)
            #expect(
                await addressSpace.methods(matching: .init(addr)) == [id]
            )
        }
        do {
            let addr = "/test2/test4/vol+"
            let id = await addressSpace.register(localAddress: addr)
            #expect(
                await addressSpace.methods(matching: .init(addr)) == [id]
            )
        }
        do {
            let addr = #"/test2/test4/ajL_-du &@!)(}].,;:%$|\-"#
            let id = await addressSpace.register(localAddress: addr)
            #expect(
                await addressSpace.methods(matching: .init(addr)) == [id]
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
            id1 = await addressSpace.register(localAddress: "/base/test1") { values, host, port in
                #expect(values == ["A string", 123])
                confirmation.confirm(count: 1)
            }
            
            id2 = await addressSpace.register(localAddress: "/base/test2") { values, host, port in
                #expect(values == ["A string", 123])
                confirmation.confirm(count: 10)
            }
            
            // this shouldn't be called
            id3 = await addressSpace.register(localAddress: "/base/blah3") { values, host, port in
                confirmation.confirm(count: 100)
            }
            
            methodIDs = await addressSpace.dispatch(
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
