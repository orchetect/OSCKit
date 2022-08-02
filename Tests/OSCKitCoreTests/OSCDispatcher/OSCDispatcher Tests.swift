//
//  OSCDispatcher Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKitCore

final class OSCDispatcher_Tests: XCTestCase {
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    // MARK: - Address Registration
    
    func testRegisterAddress_PathComponents() throws {
        let dispatcher = OSCDispatcher()
        
        let t1ID = dispatcher.register(address: ["test1"])
        let t2ID = dispatcher.register(address: ["test1", "test2"])
        let t3ID = dispatcher.register(address: ["test3", "test4"])
        
        // basic verbatim match to check if register worked
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1"),
            [t1ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2"),
            [t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test3/test4"),
            [t3ID]
        )
    }
    
    func testUnregisterAddress() throws {
        let dispatcher = OSCDispatcher()
        
        let t1ID = dispatcher.register(address: "/test1/test3/methodA"); _ = t1ID
        let t2ID = dispatcher.register(address: "/test2/test4/methodB")
        
        XCTAssertTrue(
            dispatcher.unregister(address: "/test1/test3/methodA")
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test3/methodA"),
            []
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test2/test4/methodB"),
            [t2ID]
        )
        
        // containers still exist
        
        XCTAssert(
            dispatcher.methods(matching: "/test1").count == 1
        )
        
        XCTAssert(
            dispatcher.methods(matching: "/test1/test3").count == 1
        )
    }
    
    func testUnregisterAddress_PathComponents() throws {
        let dispatcher = OSCDispatcher()
        
        let t1ID = dispatcher.register(address: "/test1/test3/methodA"); _ = t1ID
        let t2ID = dispatcher.register(address: "/test2/test4/methodB")
        
        XCTAssertTrue(
            dispatcher.unregister(address: ["test1", "test3", "methodA"])
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test3/methodA"),
            []
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test2/test4/methodB"),
            [t2ID]
        )
        
        // containers still exist
        
        XCTAssert(
            dispatcher.methods(matching: "/test1").count == 1
        )
        
        XCTAssert(
            dispatcher.methods(matching: "/test1/test3").count == 1
        )
    }
    
    func testUnregisterAllAddresses() throws {
        let dispatcher = OSCDispatcher()
        
        let _ = dispatcher.register(address: "/test1/test3/methodA")
        let _ = dispatcher.register(address: "/test2/test4/methodB")
        
        dispatcher.unregisterAll()
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test3/methodA"),
            []
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test2/test4/methodB"),
            []
        )
        
        // containers still exist
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1"),
            []
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test3"),
            []
        )
    }
    
    // MARK: - Matches
    
    func testMethodsMatching_Root() throws {
        let dispatcher = OSCDispatcher()
        
        let t1ID = dispatcher.register(address: "/test1")
        let t2ID = dispatcher.register(address: "/test2")
        let _ = dispatcher.register(address: "/test1/test1B") // not tested, just want it present
        
        // non-matches
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test"),
            []
        )
        
        // verbatim matches
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1"),
            [t1ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test2"),
            [t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/"),
            [t1ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test2/"),
            [t2ID]
        )
        
        // wildcards
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test?"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test*"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test[12]"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test[!3]"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test{1,2}"),
            [t1ID, t2ID]
        )
        
        // edge cases
        
        XCTAssertEqual(
            dispatcher.methods(matching: ""),
            []
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/"),
            []
        )
    }
    
    func testMethodsMatching_NestedMethods() throws {
        let dispatcher = OSCDispatcher()
        
        let t1ID = dispatcher.register(address: "/test1/test2/methodA")
        let t2ID = dispatcher.register(address: "/test1/test2/methodB")
                
        // non-matches
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/method"),
            []
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/methodAA"),
            []
        )
        
        // verbatim matches
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/methodA"),
            [t1ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/methodB"),
            [t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/methodA/"),
            [t1ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/methodB/"),
            [t2ID]
        )
        
        // wildcards
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/method?"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/method*"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/method[AB]"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/method[!C]"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test1/test2/method{A,B}"),
            [t1ID, t2ID]
        )
        
        // edge cases
        
        XCTAssertEqual(
            dispatcher.methods(matching: ""),
            []
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/"),
            []
        )
    }
    
    func testMethodsMatching_MultipleContainerMatches() throws {
        let dispatcher = OSCDispatcher()
        
        let t1ID = dispatcher.register(address: "/test1/test3/methodA")
        let t2ID = dispatcher.register(address: "/test2/test4/methodB")
        
        // wildcard matches
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test?/test?/method?"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/*/test?/method?"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/test?/*/method?"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/*/*/method?"),
            [t1ID, t2ID]
        )
        
        XCTAssertEqual(
            dispatcher.methods(matching: "/*/*/*"),
            [t1ID, t2ID]
        )
        
        // wildcard returning containers instead of methods
        
        do {
            let matches = dispatcher.methods(matching: "/*")
            
            XCTAssertEqual(matches.count, 2)
            XCTAssertFalse(matches.contains(t1ID))
            XCTAssertFalse(matches.contains(t2ID))
        }
        
        do {
            let matches = dispatcher.methods(matching: "/*/*")
            
            XCTAssertEqual(matches.count, 2)
            XCTAssertFalse(matches.contains(t1ID))
            XCTAssertFalse(matches.contains(t2ID))
        }
        do {
            let matches = dispatcher.methods(matching: "/test?/test?")
            
            XCTAssertEqual(matches.count, 2)
            XCTAssertFalse(matches.contains(t1ID))
            XCTAssertFalse(matches.contains(t2ID))
        }
    }
    
    func testMethodsMatching_EdgeCases() {
        // ensure addresses are not sanitized in an unexpected way
        
        let dispatcher = OSCDispatcher()
        
        do {
            let addr = OSCAddress("/test1/test3/vol-")
            let id = dispatcher.register(address: addr)
            XCTAssertEqual(
                dispatcher.methods(matching: addr), [id]
            )
        }
        do {
            let addr = OSCAddress("/test2/test4/vol+")
            let id = dispatcher.register(address: addr)
            XCTAssertEqual(
                dispatcher.methods(matching: addr), [id]
            )
        }
        do {
            let addr = OSCAddress(#"/test2/test4/ajL_-du &@!)(}].,;:%$|\-"#)
            let id = dispatcher.register(address: addr)
            XCTAssertEqual(
                dispatcher.methods(matching: addr), [id]
            )
        }
    }
}

#endif
