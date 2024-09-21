//
//  OSCAddressSpace Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import XCTest
import OSCKitCore

final class OSCAddressSpace_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Address Registration
    
    func testRegisterAddress_PathComponents() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: ["test1"])
        let t2ID = addressSpace.register(localAddress: ["test1", "test2"])
        let t3ID = addressSpace.register(localAddress: ["test3", "test4"])
        
        // basic verbatim match to check if register worked
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1")),
            [t1ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2")),
            [t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test3/test4")),
            [t3ID]
        )
    }
    
    func testUnregisterAddress() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test3/methodA"); _ = t1ID
        let t2ID = addressSpace.register(localAddress: "/test2/test4/methodB")
        
        XCTAssertTrue(
            addressSpace.unregister(localAddress: "/test1/test3/methodA")
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test3/methodA")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test2/test4/methodB")),
            [t2ID]
        )
        
        // should not match containers which are not also methods
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1")).count, 0
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test3")).count, 0
        )
    }
    
    func testUnregisterAddress_PathComponents() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test3/methodA"); _ = t1ID
        let t2ID = addressSpace.register(localAddress: "/test2/test4/methodB")
        
        XCTAssertTrue(
            addressSpace.unregister(localAddress: ["test1", "test3", "methodA"])
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test3/methodA")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test2/test4/methodB")),
            [t2ID]
        )
        
        // should not match containers which are not also methods
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1")).count, 0
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test3")).count, 0
        )
    }
    
    func testRegisterAddress_MethodThatAlsoBecomesAContainer() throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = addressSpace.register(localAddress: "/test1/test2")
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        
        // confirm registrations worked and match as methods
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2")),
            [t0ID]
        )
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodA")),
            [t1ID]
        )
    }
    
    func testRegisterAddress_ContainerThatBecomesAMethod() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        let t0ID = addressSpace.register(localAddress: "/test1/test2")
        
        // confirm registrations worked and match as methods
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2")),
            [t0ID]
        )
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodA")),
            [t1ID]
        )
    }
    
    func testUnregisterAddress_MethodThatAlsoBecomesAContainer_RemoveMethod() throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = addressSpace.register(localAddress: "/test1/test2")
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        
        // unregister downstream method
        XCTAssertTrue(
            addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodA")),
            []
        )
        
        // should not modify pre-existing methods that were also containers
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2")),
            [t0ID]
        )
        
        // attempt to unregister again
        XCTAssertFalse(
            addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
    }
    
    func testUnregisterAddress_ContainerThatBecomesAMethod_RemoveMethod() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA"); _ = t1ID
        let t0ID = addressSpace.register(localAddress: "/test1/test2")
        
        // unregister downstream method
        XCTAssertTrue(
            addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodA")),
            []
        )
        
        // should not modify pre-existing methods that were also containers
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2")),
            [t0ID]
        )
        
        // attempt to unregister again
        XCTAssertFalse(
            addressSpace.unregister(localAddress: ["test1", "test2", "methodA"])
        )
    }
    
    func testUnregisterAddress_MethodThatAlsoBecomesAContainer_RemoveContainer() throws {
        let addressSpace = OSCAddressSpace()
        
        let t0ID = addressSpace.register(localAddress: "/test1/test2"); _ = t0ID
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA")
        
        // unregister midstream container method
        XCTAssertTrue(
            addressSpace.unregister(localAddress: ["test1", "test2"])
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2")),
            []
        )
        
        // should not modify pre-existing downstream methods or containers
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodA")),
            [t1ID]
        )
        
        // attempt to unregister again
        XCTAssertFalse(
            addressSpace.unregister(localAddress: ["test1", "test2"])
        )
    }
    
    func testUnregisterAddress_ContainerThatBecomesAMethod_RemoveContainer() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA")
        let t0ID = addressSpace.register(localAddress: "/test1/test2"); _ = t0ID
        
        // unregister midstream container method
        XCTAssertTrue(
            addressSpace.unregister(localAddress: ["test1", "test2"])
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2")),
            []
        )
        
        // should not modify pre-existing downstream methods or containers
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodA")),
            [t1ID]
        )
        
        // attempt to unregister again
        XCTAssertFalse(
            addressSpace.unregister(localAddress: ["test1", "test2"])
        )
    }
    
    func testUnregisterAllAddresses() throws {
        let addressSpace = OSCAddressSpace()
        
        let _ = addressSpace.register(localAddress: "/test1/test3/methodA")
        let _ = addressSpace.register(localAddress: "/test2/test4/methodB")
        
        addressSpace.unregisterAll()
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test3/methodA")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test2/test4/methodB")),
            []
        )
        
        // containers still exist
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test3")),
            []
        )
    }
    
    // MARK: - Matches
    
    func testMethodsMatching_Root() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1")
        let t2ID = addressSpace.register(localAddress: "/test2")
        let _ = addressSpace.register(localAddress: "/test1/test1B") // not tested
        
        // non-matches
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test")),
            []
        )
        
        // verbatim matches
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1")),
            [t1ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test2")),
            [t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/")),
            [t1ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test2/")),
            [t2ID]
        )
        
        // wildcards
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test?")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test*")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test[12]")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test[!3]")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test{1,2}")),
            [t1ID, t2ID]
        )
        
        // edge cases
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/")),
            []
        )
    }
    
    func testMethodsMatching_NestedMethods() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test2/methodA")
        let t2ID = addressSpace.register(localAddress: "/test1/test2/methodB")
                
        // non-matches
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/method")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodAA")),
            []
        )
        
        // verbatim matches
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodA")),
            [t1ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodB")),
            [t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodA/")),
            [t1ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/methodB/")),
            [t2ID]
        )
        
        // wildcards
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/method?")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/method*")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/method[AB]")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/method[!C]")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1/test2/method{A,B}")),
            [t1ID, t2ID]
        )
        
        // partial path matches should not return containers
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test1")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test?")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test*")),
            []
        )
        
        // edge cases
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/")),
            []
        )
    }
    
    func testMethodsMatching_MultipleContainerMatches() throws {
        let addressSpace = OSCAddressSpace()
        
        let t1ID = addressSpace.register(localAddress: "/test1/test3/methodA")
        let t2ID = addressSpace.register(localAddress: "/test2/test4/methodB")
        
        // wildcard matches
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test?/test?/method?")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/*/test?/method?")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test?/*/method?")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/*/*/method?")),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/*/*/*")),
            [t1ID, t2ID]
        )
        
        // wildcard returning containers instead of methods
        // (don't test for equal arrays since the ordering may differ on each execution)
        
        do {
            let matches = addressSpace.methods(matching: .init("/*/*/*"))
            
            XCTAssertEqual(matches.count, 2)
            XCTAssertTrue(matches.contains(t1ID))
            XCTAssertTrue(matches.contains(t2ID))
        }
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/*")),
            []
        )
           
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/*/*")),
            []
        )
        
        XCTAssertEqual(
            addressSpace.methods(matching: .init("/test?/test?")),
            []
        )
    }
    
    func testMethodsMatching_EdgeCases() {
        // ensure addresses are not sanitized in an unexpected way
        
        let addressSpace = OSCAddressSpace()
        
        do {
            let addr = "/test1/test3/vol-"
            let id = addressSpace.register(localAddress: addr)
            XCTAssertEqual(
                addressSpace.methods(matching: .init(addr)), [id]
            )
        }
        do {
            let addr = "/test2/test4/vol+"
            let id = addressSpace.register(localAddress: addr)
            XCTAssertEqual(
                addressSpace.methods(matching: .init(addr)), [id]
            )
        }
        do {
            let addr = #"/test2/test4/ajL_-du &@!)(}].,;:%$|\-"#
            let id = addressSpace.register(localAddress: addr)
            XCTAssertEqual(
                addressSpace.methods(matching: .init(addr)), [id]
            )
        }
    }
    
    func testDispatchMatching_CurrentQueue() {
        let addressSpace = OSCAddressSpace()
        
        let test1Exp = expectation(description: "test1 Closure Called")
        let test2Exp = expectation(description: "test2 Closure Called")
        let test3Exp = expectation(description: "test3 Closure Called")
        test3Exp.isInverted = true
        
        let id1 = addressSpace.register(localAddress: "/base/test1") { values in
            XCTAssert(values == ["A string", 123])
            test1Exp.fulfill()
        }
        
        let id2 = addressSpace.register(localAddress: "/base/test2") { values in
            XCTAssert(values == ["A string", 123])
            test2Exp.fulfill()
        }
        
        // this shouldn't be called
        let id3 = addressSpace.register(localAddress: "/base/blah3") { values in
            test3Exp.fulfill()
        }
        
        let methodIDs = addressSpace.dispatch(
            OSCMessage("/base/test?", values: ["A string", 123])
        )
        
        wait(for: [test1Exp, test2Exp, test3Exp], timeout: 1.0)
        
        XCTAssertEqual(methodIDs.count, 2)
        XCTAssertTrue(methodIDs.contains(id1))
        XCTAssertTrue(methodIDs.contains(id2))
        _ = id3
    }
    
    func testDispatchMatching_OnQueue() {
        let addressSpace = OSCAddressSpace()
        
        let test1Exp = expectation(description: "test1 Closure Called")
        let test2Exp = expectation(description: "test2 Closure Called")
        let test3Exp = expectation(description: "test3 Closure Called")
        test3Exp.isInverted = true
        
        let id1 = addressSpace.register(localAddress: "/base/test1") { values in
            XCTAssert(values == ["A string", 123])
            test1Exp.fulfill()
        }
        
        let id2 = addressSpace.register(localAddress: "/base/test2") { values in
            XCTAssert(values == ["A string", 123])
            test2Exp.fulfill()
        }
        
        // this shouldn't be called
        let id3 = addressSpace.register(localAddress: "/base/blah3") { values in
            test3Exp.fulfill()
        }
        
        let methodIDs = addressSpace.dispatch(
            OSCMessage("/base/test?", values: ["A string", 123]),
            on: .global()
        )
        
        wait(for: [test1Exp, test2Exp, test3Exp], timeout: 1.0)
        
        XCTAssertEqual(methodIDs.count, 2)
        XCTAssertTrue(methodIDs.contains(id1))
        XCTAssertTrue(methodIDs.contains(id2))
        _ = id3
    }
}
