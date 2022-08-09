//
//  OSCValueCodable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public protocol OSCValueCodable: OSCValueEncodable & OSCValueDecodable {
    static var oscTagIdentity: OSCValueTagIdentity { get }
}
