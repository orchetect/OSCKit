//
//  Dispatcher Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

#if shouldTestCurrentPlatform

import XCTest
import OSCKit

final class OSCAddress_Dispatcher_Tests: XCTestCase {
    
    override func setUp() { super.setUp() }
    override func tearDown() { super.tearDown() }
    
    func testMethodsMatching_Root() throws {
        
        let dispatcher = OSCAddress.Dispatcher()
        
        let t1ID = try XCTUnwrap(dispatcher.register("/test1"))
        let t2ID = try XCTUnwrap(dispatcher.register("/test2"))
        let _ = try XCTUnwrap(dispatcher.register("/test1/test1B")) // not tested, just want it present
        
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
        
        let dispatcher = OSCAddress.Dispatcher()
        
        let t1ID = try XCTUnwrap(dispatcher.register("/test1/test2/methodA"))
        let t2ID = try XCTUnwrap(dispatcher.register("/test1/test2/methodB"))
                
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
        
        let dispatcher = OSCAddress.Dispatcher()
        
        let t1ID = try XCTUnwrap(dispatcher.register("/test1/test3/methodA"))
        let t2ID = try XCTUnwrap(dispatcher.register("/test2/test4/methodB"))
        
        // wildcards
        
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
        
    }
    
}

#endif
