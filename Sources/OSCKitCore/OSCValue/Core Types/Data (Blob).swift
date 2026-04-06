//
//  Data (Blob).swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data
#endif

@_documentation(visibility: internal)
extension Data: OSCValue {
    public static let oscValueToken: OSCValueToken = .blob
}

@_documentation(visibility: internal)
extension Data: OSCValueCodable {
    static let oscTag: Character = "b"
    public static let oscTagIdentity: OSCValueTagIdentity = .tag(oscTag)
}

@_documentation(visibility: internal)
extension Data: OSCValueEncodable {
    public static let oscEncoding = OSCValueStaticTagEncoder<Self> { value throws(OSCEncodeError) in
        let lengthData = value.count.int32.toData(.bigEndian)
        let blobData = OSCMessageEncoder.fourNullBytePadded(value)
        
        return (
            tag: oscTag,
            data: lengthData + blobData
        )
    }
}

@_documentation(visibility: internal)
extension Data: OSCValueDecodable {
    public static let oscDecoding = OSCValueStaticTagDecoder<Self> { decoder throws(OSCDecodeError) in
        try decoder.readOSCBlob().toData()
    }
}
