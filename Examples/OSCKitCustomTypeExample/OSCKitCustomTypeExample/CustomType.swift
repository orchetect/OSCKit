//
//  CustomType.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore

struct CustomType: Equatable, Hashable, Codable {
    let id: Int
    let name: String
}

extension CustomType: OSCValue {
    // our underlying type when encoded in OSC will be a blob (raw Data)
    static let oscValueToken: OSCValueToken = .blob
}

extension CustomType: OSCValueCodable {
    // Define the custom type's OSC Type Tag as "j".
    // Note that this MUST NOT use an existing OSC Type Tag already defined in the OSC spec.
    static let oscTag: Character = "j"
    static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension CustomType: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    static let oscEncoding = OSCValueEncodingBlock { value in
        // encode our Codable type into raw data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(value)
        
        // it's our responsibility to make sure OSB blob (data) is encoded correctly
        // which includes a 4-byte length header and null-byte padding to multiples of 4 bytes.
        // we can ask the Data (blob) encoder to do the work for us:
        let blobData = try Data.oscEncoding.block(jsonData).data
        return (tag: oscTag, data: blobData)
    }
}

extension CustomType: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    static let oscDecoding = OSCValueDecodingBlock { dataReader in
        let decoder = JSONDecoder()
        let data = try dataReader.readBlob() // gets entire data chunk as an OSC blob
        let decoded = try decoder.decode(CustomType.self, from: data)
        return decoded
    }
}
