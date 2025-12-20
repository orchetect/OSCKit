//
//  OSCAddressSpace Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import struct Foundation.UUID
@testable import OSCKitCore
import Testing

@Suite struct OSCAddressSpace_Tests {
    // MARK: - Method ID Generics
    
    /// This test just ensures expected init syntax works and the compiler does not complain.
    @Test
    func initMethodIDTypes() {
        // defaults to `UUID` method ID type
        let _ = OSCAddressSpace()
        
        // use `String` as method ID type, with explicit type notation
        let _ = OSCAddressSpace<String>()
        
        // use `String` as method ID type using designated initializer overload
        let _ = OSCAddressSpace(methodIDs: String.self)
    }
    
    // MARK: - Address Registration
    
    @Test
    func registerAddress_PathComponents() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: ["test1"])
        let t2ID = await addressSpace.register(localAddress: ["test1", "test2"])
        let t3ID = await addressSpace.register(localAddress: ["test3", "test4"])
        
        // basic verbatim match to check if register worked
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2")) ==
                [t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test3/test4")) ==
                [t3ID]
        )
    }
    
    @Test
    func registerAddress_PathComponents_CustomMethodIDType() async throws {
        enum MyMethodID /* : Equatable, Hashable, Sendable */ {
            case one
            case two
            case three
        }
        
        let addressSpace = OSCAddressSpace<MyMethodID>()
        
        await addressSpace.register(localAddress: ["test1"], id: .one)
        await addressSpace.register(localAddress: ["test1", "test2"], id: .two)
        await addressSpace.register(localAddress: ["test3", "test4"], id: .three)
        
        // basic verbatim match to check if register worked
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")) ==
            [.one]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2")) ==
            [.two]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test3/test4")) ==
            [.three]
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test2/test4/methodB")) ==
                [t2ID]
        )
        
        // should not match containers which are not also methods
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")).isEmpty
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test3")).isEmpty
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test2/test4/methodB")) ==
                [t2ID]
        )
        
        // should not match containers which are not also methods
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")).isEmpty
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test3")).isEmpty
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test2/test4/methodB")) ==
                [t2ID]
        )
        
        // cannot unregister a node that is a container, since we can't get a method ID for a contianer
        #expect(await addressSpace.methodID(path: ["test2"]) == nil)
    }
    
    @Test
    func registerAddress_MethodThatAlsoBecomesAContainer() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = await addressSpace.register(localAddress: "/test1/test2")
        let t1ID = await addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        
        // confirm registrations worked and match as methods
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2")) ==
                [t0ID]
        )
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodA")) ==
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2")) ==
                [t0ID]
        )
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodA")) ==
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodA")) ==
                []
        )
        
        // should not modify pre-existing methods that were also containers
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2")) ==
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodA")) ==
                []
        )
        
        // should not modify pre-existing methods that were also containers
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2")) ==
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2")) ==
                []
        )
        
        // should not modify pre-existing downstream methods or containers
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodA")) ==
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2")) ==
                []
        )
        
        // should not modify pre-existing downstream methods or containers
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodA")) ==
                [t1ID]
        )
        
        // attempt to unregister again
        #expect(
            await !addressSpace.unregister(localAddress: ["test1", "test2"])
        )
    }
    
    @Test
    func unregisterAddress_CustomMethodIDType() async throws {
        enum MyMethodID /* : Equatable, Hashable, Sendable */ {
            case one
            case two
            case three
        }
        
        let addressSpace = OSCAddressSpace<MyMethodID>()
        
        await addressSpace.register(localAddress: ["test1"], id: .one)
        await addressSpace.register(localAddress: ["test1", "test2"], id: .two)
        await addressSpace.register(localAddress: ["test3", "test4"], id: .three)
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")) ==
                [.one]
        )
        
        #expect(await addressSpace.unregister(methodID: .one))
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")) ==
                []
        )
    }
    
    @Test
    func unregisterAllAddresses() async throws {
        let addressSpace = OSCAddressSpace()
        
        _ = await addressSpace.register(localAddress: "/test1/test3/methodA")
        _ = await addressSpace.register(localAddress: "/test2/test4/methodB")
        
        await addressSpace.unregisterAll()
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test3/methodA")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test2/test4/methodB")) ==
                []
        )
        
        // containers still exist
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test3")) ==
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
            await addressSpace.methods(matching: OSCAddressPattern("/test")) ==
                []
        )
        
        // verbatim matches
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test2")) ==
                [t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test2/")) ==
                [t2ID]
        )
        
        // wildcards
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test*")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test[12]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test[!3]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test{1,2}")) ==
                [t1ID, t2ID]
        )
        
        // edge cases
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/")) ==
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
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/method")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodAA")) ==
                []
        )
        
        // verbatim matches
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodA")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodB")) ==
                [t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodA/")) ==
                [t1ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/methodB/")) ==
                [t2ID]
        )
        
        // wildcards
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/method*")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/method[AB]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/method[!C]")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1/test2/method{A,B}")) ==
                [t1ID, t2ID]
        )
        
        // partial path matches should not return containers
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test1")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test?")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test*")) ==
                []
        )
        
        // edge cases
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/")) ==
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
            await addressSpace.methods(matching: OSCAddressPattern("/test?/test?/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/*/test?/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test?/*/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/*/*/method?")) ==
                [t1ID, t2ID]
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/*/*/*")) ==
                [t1ID, t2ID]
        )
        
        // wildcard returning containers instead of methods
        // (don't test for equal arrays since the ordering may differ on each execution)
        
        do {
            let matches = await addressSpace.methods(matching: OSCAddressPattern("/*/*/*"))
            
            #expect(matches.count == 2)
            #expect(matches.contains(t1ID))
            #expect(matches.contains(t2ID))
        }
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/*")) ==
                []
        )
           
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/*/*")) ==
                []
        )
        
        #expect(
            await addressSpace.methods(matching: OSCAddressPattern("/test?/test?")) ==
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
                await addressSpace.methods(matching: OSCAddressPattern(addr)) == [id]
            )
        }
        do {
            let addr = "/test2/test4/vol+"
            let id = await addressSpace.register(localAddress: addr)
            #expect(
                await addressSpace.methods(matching: OSCAddressPattern(addr)) == [id]
            )
        }
        do {
            let addr = #"/test2/test4/ajL_-du &@!)(}].,;:%$|\-"#
            let id = await addressSpace.register(localAddress: addr)
            #expect(
                await addressSpace.methods(matching: OSCAddressPattern(addr)) == [id]
            )
        }
    }
    
    @Test
    func dispatchMatching() async throws {
        let addressSpace = OSCAddressSpace()
        
        var id1: UUID!
        var id2: UUID!
        var id3: UUID!
        var methodIDs: [UUID]!
        
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
    
    @Test
    func nodePath() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: ["test1"])
        let t2ID = await addressSpace.register(localAddress: ["test1", "test2"])
        let t3ID = await addressSpace.register(localAddress: ["test3", "test4"])
        
        await addressSpace.withIsolation { addressSpace in
            #expect(addressSpace.nodePath(methodID: t1ID)?.map(\.name) == ["test1"])
            #expect(addressSpace.nodePath(methodID: t2ID)?.map(\.name) == ["test1", "test2"])
            #expect(addressSpace.nodePath(methodID: t3ID)?.map(\.name) == ["test3", "test4"])
            
            // edge cases
            #expect(addressSpace.nodePath(methodID: UUID()) == nil)
        }
    }
    
    @Test
    func methodNodes() async throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = await addressSpace.register(localAddress: ["test1"])
        let t2ID = await addressSpace.register(localAddress: ["test1", "test2"])
        let t3ID = await addressSpace.register(localAddress: ["test3", "test4"])
        
        await addressSpace.withIsolation { addressSpace in
            #expect(addressSpace.methodNodes(patternMatching: OSCAddressPattern("/test1")).map(\.methodID) == [t1ID])
            #expect(addressSpace.methodNodes(patternMatching: OSCAddressPattern("/test1/test2")).map(\.methodID) == [t2ID])
            #expect(addressSpace.methodNodes(patternMatching: OSCAddressPattern("/test3/test4")).map(\.methodID) == [t3ID])
            
            // edge cases
            #expect(addressSpace.methodNodes(patternMatching: OSCAddressPattern("")) == [])
            #expect(addressSpace.methodNodes(patternMatching: OSCAddressPattern("/")) == [])
            #expect(addressSpace.methodNodes(patternMatching: OSCAddressPattern("/foo")) == [])
            #expect(addressSpace.methodNodes(patternMatching: OSCAddressPattern("/test1/foo")) == [])
        }
    }
}

// MARK: - Helpers

extension OSCAddressSpace {
    func dumpRoot() {
        dump(root)
    }
    
    // Mechanism to introspect actor contents that are non-Sendable.
    typealias IsolationBlock = @Sendable (_ addressSpace: isolated OSCAddressSpace) throws -> ()
    func withIsolation(_ block: IsolationBlock) rethrows {
        try block(self)
    }
}

extension OSCAddressSpaceNode {
    var methodID: MethodID? {
        guard case let .method(id: id, block: _) = nodeType else { return nil }
        return id
    }
}
