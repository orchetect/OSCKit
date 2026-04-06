//
//  Packet Length Header Coding Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data
#endif

@testable import OSCKit
import Testing

@Suite struct PacketLengthHeaderCodingTests {
    // swiftformat:options --wrapcollections preserve
    
    /// Test `Data.packetLengthHeaderEncoded()` method.
    @Test
    func dataPacketLengthHeaderEncoded() {
        #expect(
            Data().packetLengthHeaderEncoded(byteOrder: .littleEndian)
                == Data([0x00, 0x00, 0x00, 0x00])
        )
        #expect(
            Data([0x40]).packetLengthHeaderEncoded(byteOrder: .littleEndian)
                == Data([0x01, 0x00, 0x00, 0x00, 0x40])
        )
        #expect(
            Data([0x40, 0x41]).packetLengthHeaderEncoded(byteOrder: .littleEndian)
                == Data([0x02, 0x00, 0x00, 0x00, 0x40, 0x41])
        )
        
        #expect(
            Data().packetLengthHeaderEncoded(byteOrder: .bigEndian)
                == Data([0x00, 0x00, 0x00, 0x00])
        )
        #expect(
            Data([0x40]).packetLengthHeaderEncoded(byteOrder: .bigEndian)
                == Data([0x00, 0x00, 0x00, 0x01, 0x40])
        )
        #expect(
            Data([0x40, 0x41]).packetLengthHeaderEncoded(byteOrder: .bigEndian)
                == Data([0x00, 0x00, 0x00, 0x02, 0x40, 0x41])
        )
    }
    
    /// Test `Data.dataPacketLengthHeaderDecoded()` method containing one or fewer packets.
    @Test
    func dataPacketLengthHeaderDecoded_SinglePacket() throws {
        #expect(
            try Data([0x00, 0x00, 0x00, 0x00]).packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data()]
        )
        #expect(
            try Data([0x01, 0x00, 0x00, 0x00, 0x40]).packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data([0x40])]
        )
        #expect(
            try Data([0x02, 0x00, 0x00, 0x00, 0x40, 0x41]).packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data([0x40, 0x41])]
        )
    }
    
    /// Test `Data.packetLengthHeaderDecoded()` method containing one or fewer packets -- edge cases.
    @Test
    func dataPacketLengthHeaderDecoded_SinglePacket_EdgeCases() throws {
        // not enough bytes
        #expect(throws: OSCTCPPacketLengthHeaderDecodingError.notEnoughBytes) {
            try Data([0x01, 0x00, 0x00, 0x00]).packetLengthHeaderDecoded(byteOrder: .littleEndian)
        }
        
        // too many bytes
        #expect(throws: OSCTCPPacketLengthHeaderDecodingError.notEnoughBytes) {
            try Data([0x01, 0x00, 0x00, 0x00, 0x40, 0x41]).packetLengthHeaderDecoded(byteOrder: .littleEndian)
        }
        
        // wrong UInt32 size encoding byteOrder
        #expect(throws: OSCTCPPacketLengthHeaderDecodingError.notEnoughBytes) {
            try Data([0x00, 0x00, 0x00, 0x01, 0x40]).packetLengthHeaderDecoded(byteOrder: .littleEndian)
        }
    }
    
    /// Test `Data.packetLengthHeaderDecoded()` method containing two or more packets.
    @Test
    func dataPacketLengthHeaderDecoded_MultiplePackets() throws {
        #expect(
            try Data([0x00, 0x00, 0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data(), Data()]
        )
        #expect(
            try Data([0x00, 0x00, 0x00, 0x00,
                      0x01, 0x00, 0x00, 0x00, 0x40])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data(), Data([0x40])]
        )
        #expect(
            try Data([0x01, 0x00, 0x00, 0x00, 0x40,
                      0x01, 0x00, 0x00, 0x00, 0x41])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data([0x40]), Data([0x41])]
        )
        #expect(
            try Data([0x02, 0x00, 0x00, 0x00, 0x40,
                      0x41, 0x01, 0x00, 0x00, 0x00, 0x42])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data([0x40, 0x41]), Data([0x42])]
        )
        #expect(
            try Data([0x02, 0x00, 0x00, 0x00, 0x40, 0x41,
                      0x02, 0x00, 0x00, 0x00, 0x42, 0x43])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data([0x40, 0x41]), Data([0x42, 0x43])]
        )
        #expect(
            try Data([0x02, 0x00, 0x00, 0x00, 0x40, 0x41,
                      0x02, 0x00, 0x00, 0x00, 0x42, 0x43,
                      0x00, 0x00, 0x00, 0x00])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data([0x40, 0x41]), Data([0x42, 0x43]), Data()]
        )
        #expect(
            try Data([0x02, 0x00, 0x00, 0x00, 0x40, 0x41,
                      0x00, 0x00, 0x00, 0x00,
                      0x02, 0x00, 0x00, 0x00, 0x42, 0x43])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
                == [Data([0x40, 0x41]), Data(), Data([0x42, 0x43])]
        )
    }
    
    /// Test `Data.packetLengthHeaderDecoded()` method containing two or more packets -- edge cases.
    @Test
    func dataPacketLengthHeaderDecoded_MultiplePackets_EdgeCases() throws {
        // one valid packet and one packet with not enough bytes
        #expect(throws: OSCTCPPacketLengthHeaderDecodingError.notEnoughBytes) {
            try Data([0x01, 0x00, 0x00, 0x00, 0x40,
                      0x02, 0x00, 0x00, 0x00, 0x41])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
        }
        
        // one valid packet and one packet with not enough bytes
        #expect(throws: OSCTCPPacketLengthHeaderDecodingError.notEnoughBytes) {
            try Data([0x01, 0x00, 0x00, 0x00, 0x40,
                      0x01, 0x00, 0x00, 0x00, 0x41, 0x42])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
        }
        
        // two valid packets and one packet with not enough bytes
        #expect(throws: OSCTCPPacketLengthHeaderDecodingError.notEnoughBytes) {
            try Data([0x01, 0x00, 0x00, 0x00, 0x40,
                      0x02, 0x00, 0x00, 0x00, 0x41, 0x42,
                      0x02, 0x00, 0x00, 0x00, 0x43])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
        }
        
        // two packets with wrong UInt32 size encoding byteOrder
        #expect(throws: OSCTCPPacketLengthHeaderDecodingError.notEnoughBytes) {
            try Data([0x00, 0x00, 0x00, 0x01, 0x40,
                      0x00, 0x00, 0x00, 0x02, 0x41, 0x42])
                .packetLengthHeaderDecoded(byteOrder: .littleEndian)
        }
    }
    
    /// Practical test: Encode and decode an OSC Message
    @Test
    func oscEncodeDecode() throws {
        let oscMessage = OSCMessage("/address/here", values: [123, true, 1.5, "abcdefg123456"])
        let oscRawData = try oscMessage.rawData()
        #expect(oscRawData.count == 52)
        
        let encodedData = oscRawData.packetLengthHeaderEncoded(byteOrder: .bigEndian)
        #expect(encodedData.count == oscRawData.count + 4)
        #expect(encodedData == Data([0x00, 0x00, 0x00, 0x34]) + oscRawData)
        
        let decodedData = try encodedData.packetLengthHeaderDecoded(byteOrder: .bigEndian)
        #expect(decodedData == [oscRawData])
    }
}
