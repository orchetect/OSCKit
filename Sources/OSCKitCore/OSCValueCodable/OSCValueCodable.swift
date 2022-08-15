//
//  OSCValueCodable.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

public protocol OSCValueCodable: OSCValueEncodable & OSCValueDecodable {
    static var oscTagIdentity: OSCValueTagIdentity { get }
}
