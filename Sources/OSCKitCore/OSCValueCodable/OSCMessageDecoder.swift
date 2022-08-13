//
//  OSCMessageDecoder.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
@_implementationOnly import SwiftASCII

/// `OSCMessage` decoder.
public enum OSCMessageDecoder {
    /// Decodes OSC message raw data.
    public static func decode(rawData: Data) throws ->
        (addressPattern: String, values: OSCValues)
    {
        // validation: length
        if rawData.count % 4 != 0 { // isn't a multiple of 4 bytes (as per OSC spec)
            throw OSCDecodeError.malformed("Length not a multiple of 4 bytes.")
        }
        
        // validation: check header
        guard rawData.appearsToBeOSCMessage else {
            throw OSCDecodeError.malformed("Does not start with an address pattern.")
        }
        
        var decoder = OSCValueDecoder(data: rawData)
        
        // OSC address
        
        guard let extractedAddressPattern = try? decoder
            .read4ByteAlignedNullTerminatedASCIIString()
        else {
            throw OSCDecodeError.malformed("Address pattern string could not be parsed.")
        }
        
        // OSC-type chunk
        
        guard let extractedOSCtags = (
            try? decoder.read4ByteAlignedNullTerminatedASCIIString()
        )?
            .map({ Character(extendedGraphemeClusterLiteral: $0) })
        else {
            throw OSCDecodeError.malformed("Couldn't extract OSC-type chunk.")
        }
        
        // set up value array
        var extractedValues: OSCValues = []
        
        var currentTagIndex = 0
        while currentTagIndex < extractedOSCtags.count {
            let char = extractedOSCtags[currentTagIndex]
            
            switch char {
            case ",", "\0":
                // ignore
                currentTagIndex += 1
                
            default:
                let types = OSCSerialization.shared.tagIdentities(for: char)
                    .compactMap { $0 as? (any OSCValue.Type) }
                
                guard !types.isEmpty else {
                    throw OSCDecodeError.malformed(
                        "No concrete type found to decode OSC type tag \(char)."
                    )
                }
                
                var isTypeDecoded = false
                for type in types {
                    guard !isTypeDecoded else { continue }
                    
                    let decoded = try Self.decode(
                        forType: type,
                        char: char,
                        charStream: extractedOSCtags[currentTagIndex...],
                        decoder: &decoder
                    )
                    
                    currentTagIndex += decoded.tagCount
                    extractedValues += decoded.value
                    
                    // prevent multiple decode attempts for the same value
                    isTypeDecoded = true
                }
            }
        }
        
        return (extractedAddressPattern, extractedValues)
    }
    
    private static func decode<T: OSCValue & OSCValueDecodable>(
        forType: T.Type,
        char: Character,
        charStream: Array<Character>.SubSequence,
        decoder: inout OSCValueDecoder
    ) throws -> (tagCount: Int, value: any OSCValue) {
        switch T.oscDecoding {
        case let d as OSCValueAtomicDecoder<T>:
            let decoded = try d.block(&decoder)
            return (tagCount: 1, value: decoded)
            
        case let d as OSCValueVariableDecoder<T>:
            let decoded = try d.block(char, &decoder)
            return (tagCount: 1, value: decoded)
            
        case let d as OSCValueVariadicDecoder<T>:
            let decoded = try d.block(Array(charStream), &decoder)
            return decoded
            
        default:
            throw OSCDecodeError.malformed(
                "No decoder is implemented for OSC type tag \(char)."
            )
        }
    }
}
