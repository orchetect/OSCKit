//
//  Data (Blob).swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Data: OSCValue {
    public static let oscValueToken: OSCValueToken = .blob
}

extension Data: OSCValueCodable {
    static let oscTag: Character = "b"
    public static let oscTagIdentity: OSCValueTagIdentity = .atomic(oscTag)
}

extension Data: OSCValueEncodable {
    public typealias OSCValueEncodingBlock = OSCValueAtomicEncoder<OSCEncoded>
    public static let oscEncoding = OSCValueEncodingBlock { value in
        let lengthData = value.count.int32.toData(.bigEndian)
        let blobData = OSCMessageEncoder.fourNullBytePadded(value)
        
        return (
            tag: oscTag,
            data: lengthData + blobData
        )
    }
}

extension Data: OSCValueDecodable {
    public typealias OSCValueDecodingBlock = OSCValueAtomicDecoder<OSCDecoded>
    public static let oscDecoding = OSCValueDecodingBlock { decoder in
        try decoder.readBlob()
    }
}
