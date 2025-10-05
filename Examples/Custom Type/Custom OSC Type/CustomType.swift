//
//  CustomType.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore

// NOTE:
// In this basic example, we've chosen to use the underlying OSC Type "blob", which is essentially raw data, as our
// underlying data storage chunk within an OSC message, since our type conforms to Codable and it's easily converted
// to/from Data.
//
// Since we've chosen to use JSONEncoder, and JSON is technically text (string) block, we could have also chosen
// to use the OSC Type "string" as the underlying data storage within an OSC message. There are no particular benefits
// or drawbacks of either choice, and is strictly implementation semantics.

struct CustomType: Equatable, Hashable, Codable, Sendable {
    let id: Int
    let name: String
}

extension CustomType: OSCValue {
    // Our underlying type when encoded in OSC will be a blob (raw Data)
    static let oscValueToken: OSCValueToken = .blob
}

extension CustomType: OSCValueCodable {
    // Define the custom type's OSC Type Tag as "j".
    // Note that this MUST NOT use an existing OSC Type Tag already defined in the OSC spec.
    // When registering your custom type with the `OSCSerialization` singleton, it will reject registering a type that
    // uses an OSC Type Tag that already exists.
    // For a reference of existing OSC Type Tags, see the OSC 1.0 spec online.
    static let oscTag: Character = "j"
    
    // establishes that the tag is static and will never change based on its data payload
    static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

extension CustomType: OSCValueEncodable {
    static let oscEncoding = OSCValueStaticTagEncoder<Self> { value throws(OSCEncodeError) in
        // Encode our Codable type instance into raw data
        let encoder = JSONEncoder()
        let jsonData: Data
        do { jsonData = try encoder.encode(value) }
        catch { throw .valueEncodingError(error.localizedDescription) }
        
        // OSCValueEncodingBlock makes it our responsibility to make sure OSB blob (data) is encoded correctly,
        // including a 4-byte big-endian Int32 length header and trailing null-byte padding to an alignment of 4 bytes.
        // We can ask the Data (blob) encoder to do the work for us:
        let blobData = try Data.oscEncoding.block(jsonData).data
        return (tag: oscTag, data: blobData)
    }
}

extension CustomType: OSCValueDecodable {
    static let oscDecoding = OSCValueStaticTagDecoder<Self> { dataReader throws(OSCDecodeError) in
        let decoder = JSONDecoder()
        
        // Gets entire data chunk from the OSC blob, stripping the length bytes and null padding suffix
        // and returning the actual data content
        let data = try dataReader.readBlob()
        
        // Decode into a new instance of our Codable type
        let decoded: CustomType
        do { decoded = try decoder.decode(CustomType.self, from: data) }
        catch { throw .valueDecodingError(error.localizedDescription) }
        return decoded
    }
}
