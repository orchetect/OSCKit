//
//  SLIP Coding Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
@testable import OSCKit
import Testing

@Suite struct SLIPCodingTests {
    private let END: UInt8 = 0xC0
    private let ESC: UInt8 = 0xDB
    private let ESC_END: UInt8 = 0xDC
    private let ESC_ESC: UInt8 = 0xDD
    
    /// Test `Data.slipEncoded()` method.
    @Test
    func dataSlipEncoded() {
        #expect(Data().slipEncoded() == Data([END, END]))
        #expect(Data([0x01]).slipEncoded() == Data([END, 0x01, END]))
        #expect(Data([0x01, 0x02]).slipEncoded() == Data([END, 0x01, 0x02, END]))
        
        // just establishing that it is possible to recursively encode, even though we'd never want to.
        // perhaps in future this could check to see if the data is already encoded to prevent this.
        #expect(
            Data([0x01, 0x02]).slipEncoded().slipEncoded()
                == Data([END, ESC, ESC_END, 0x01, 0x02, ESC, ESC_END, END])
        )
        
        #expect(Data([0x01, END, 0x02]).slipEncoded() == Data([END, 0x01, ESC, ESC_END, 0x02, END]))
        #expect(Data([0x01, ESC, 0x02]).slipEncoded() == Data([END, 0x01, ESC, ESC_ESC, 0x02, END]))
        
        #expect(Data([0x01, END, END, 0x02]).slipEncoded() == Data([END, 0x01, ESC, ESC_END, ESC, ESC_END, 0x02, END]))
        #expect(Data([0x01, ESC, ESC, 0x02]).slipEncoded() == Data([END, 0x01, ESC, ESC_ESC, ESC, ESC_ESC, 0x02, END]))
        #expect(Data([0x01, ESC, END, 0x02]).slipEncoded() == Data([END, 0x01, ESC, ESC_ESC, ESC, ESC_END, 0x02, END]))
        #expect(Data([0x01, END, ESC, 0x02]).slipEncoded() == Data([END, 0x01, ESC, ESC_END, ESC, ESC_ESC, 0x02, END]))
        
        #expect(
            Data([0x01, 0x02, ESC, 0x03, END, 0x04]).slipEncoded()
                == Data([END, 0x01, 0x02, ESC, ESC_ESC, 0x03, ESC, ESC_END, 0x04, END])
        )
    }
    
    /// Test `Data.slipDecoded()` method.
    @Test
    func dataSlipDecoded() throws {
        // without double END bytes
        #expect(try Data().slipDecoded() == Data())
        #expect(try Data([0x01]).slipDecoded() == Data([0x01]))
        #expect(try Data([0x01, 0x02]).slipDecoded() == Data([0x01, 0x02]))
        #expect(try Data([0x01, 0x02, 0x03]).slipDecoded() == Data([0x01, 0x02, 0x03]))
        
        // with double END bytes
        #expect(try Data([END, END]).slipDecoded() == Data())
        #expect(try Data([END, 0x01, END]).slipDecoded() == Data([0x01]))
        #expect(try Data([END, 0x01, 0x02, END]).slipDecoded() == Data([0x01, 0x02]))
        #expect(try Data([END, 0x01, 0x02, 0x03, END]).slipDecoded() == Data([0x01, 0x02, 0x03]))
        
        // without double END bytes
        #expect(try Data([ESC, ESC_END]).slipDecoded() == Data([END]))
        #expect(try Data([ESC, ESC_ESC]).slipDecoded() == Data([ESC]))
        #expect(try Data([ESC, ESC_END, ESC, ESC_END]).slipDecoded() == Data([END, END]))
        #expect(try Data([ESC, ESC_ESC, ESC, ESC_ESC]).slipDecoded() == Data([ESC, ESC]))
        #expect(try Data([ESC, ESC_ESC, ESC, ESC_END]).slipDecoded() == Data([ESC, END]))
        #expect(try Data([ESC, ESC_END, ESC, ESC_ESC]).slipDecoded() == Data([END, ESC]))
        
        // with double END bytes
        #expect(try Data([END, ESC, ESC_END, END]).slipDecoded() == Data([END]))
        #expect(try Data([END, ESC, ESC_ESC, END]).slipDecoded() == Data([ESC]))
        #expect(try Data([END, ESC, ESC_END, ESC, ESC_END, END]).slipDecoded() == Data([END, END]))
        #expect(try Data([END, ESC, ESC_ESC, ESC, ESC_ESC, END]).slipDecoded() == Data([ESC, ESC]))
        #expect(try Data([END, ESC, ESC_ESC, ESC, ESC_END, END]).slipDecoded() == Data([ESC, END]))
        #expect(try Data([END, ESC, ESC_END, ESC, ESC_ESC, END]).slipDecoded() == Data([END, ESC]))
        
        #expect(try Data([END, 0x01, ESC, ESC_ESC, 0x02, ESC, ESC_END, 0x03, END]).slipDecoded() == Data([0x01, ESC, 0x02, END, 0x03]))
        
        // more than one END byte at start
        #expect(try Data([END, END, 0x01]).slipDecoded() == Data([0x01]))
        #expect(try Data([END, END, END, 0x01]).slipDecoded() == Data([0x01]))
        #expect(try Data([END, END, 0x01, END]).slipDecoded() == Data([0x01]))
        #expect(try Data([END, END, END, 0x01, END]).slipDecoded() == Data([0x01]))
        
        // more than one END byte at end
        #expect(try Data([0x01, END, END]).slipDecoded() == Data([0x01]))
        #expect(try Data([END, 0x01, END, END]).slipDecoded() == Data([0x01]))
        #expect(try Data([0x01, END, END, END]).slipDecoded() == Data([0x01]))
        #expect(try Data([END, 0x01, END, END, END]).slipDecoded() == Data([0x01]))
    }
    
    /// Test for error: two consecutive ESC bytes is not technically valid.
    @Test
    func dataSlipDecoded_DoubleEscapeBytes() throws {
        #expect(throws: SLIPDecodingError.doubleEscapeBytes) {
            try Data([END, 0x01, ESC, ESC, 0x02, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.doubleEscapeBytes) {
            try Data([END, 0x01, ESC, ESC, ESC_END, 0x02, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.doubleEscapeBytes) {
            try Data([END, 0x01, ESC, ESC, ESC_END, ESC_END, 0x02, END]).slipDecoded()
        }
    }
    
    /// Test for error: encountering an escaped character without first receiving an ESC byte.
    @Test
    func dataSlipDecoded_MissingEscapeByte() throws {
        #expect(throws: SLIPDecodingError.missingEscapeByte) {
            try Data([END, 0x01, ESC_ESC, 0x02, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.missingEscapeByte) {
            try Data([END, 0x01, ESC_END, 0x02, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.missingEscapeByte) {
            try Data([END, ESC_ESC, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.missingEscapeByte) {
            try Data([END, ESC_END, END]).slipDecoded()
        }
    }
    
    /// Test for error: missing valid escaped character after receiving ESC byte.
    @Test
    func dataSlipDecoded_MissingEscapedCharacter() throws {
        #expect(throws: SLIPDecodingError.missingEscapedCharacter) {
            try Data([END, 0x01, ESC, 0x02, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.missingEscapedCharacter) {
            try Data([END, 0x01, ESC, 0x02, ESC_END, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.missingEscapedCharacter) {
            try Data([END, 0x01, ESC, 0x02, ESC_ESC, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.missingEscapedCharacter) {
            try Data([END, 0x01, ESC, END]).slipDecoded()
        }
    }
    
    /// Test for error: Unexpected END byte in middle of packet data.
    @Test
    func dataSlipDecoded_UnexpectedEndByte() throws {
        #expect(throws: SLIPDecodingError.unexpectedEndByte) {
            try Data([0x01, END, 0x02, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.unexpectedEndByte) {
            try Data([END, 0x01, END, 0x02, END]).slipDecoded()
        }
        #expect(throws: SLIPDecodingError.unexpectedEndByte) {
            try Data([0x01, END, 0x02]).slipDecoded()
        }
    }
    
    /// Test `Data.slipDoubleEndStripped()` method.
    @Test
    func dataSlipDoubleEndStripped() {
        #expect(Data().slipDoubleEndStripped() == Data())
        #expect(Data([0x01]).slipDoubleEndStripped() == Data([0x01]))
        #expect(Data([0x01, 0x02]).slipDoubleEndStripped() == Data([0x01, 0x02]))
        #expect(Data([0x01, 0x02, 0x03]).slipDoubleEndStripped() == Data([0x01, 0x02, 0x03]))
        
        // empty internal bytes is ok
        #expect(Data([END, END]).slipDoubleEndStripped() == Data([]))
        // one END internal byte is ok
        #expect(Data([END, END, END]).slipDoubleEndStripped() == Data([END]))
        // two (or more) END internal bytes is ok
        #expect(Data([END, END, END, END]).slipDoubleEndStripped() == Data([END, END]))
        // only one bounding END is left untouched
        #expect(Data([END]).slipDoubleEndStripped() == Data([END]))
        // only one bounding END is left untouched
        #expect(Data([END, 0x01]).slipDoubleEndStripped() == Data([END, 0x01]))
        // only one bounding END is left untouched
        #expect(Data([0x01, END]).slipDoubleEndStripped() == Data([0x01, END]))
        
        // one internal byte
        #expect(Data([END, 0x01, END]).slipDoubleEndStripped() == Data([0x01]))
        // two internal bytes
        #expect(Data([END, 0x01, 0x02, END]).slipDoubleEndStripped() == Data([0x01, 0x02]))
        
        // only strip END bytes, not ESC bytes
        #expect(Data([0xDB, 0xDB]).slipDoubleEndStripped() == Data([0xDB, 0xDB]))
        #expect(Data([0xDB, 0x01, 0xDB]).slipDoubleEndStripped() == Data([0xDB, 0x01, 0xDB]))
    }
}
