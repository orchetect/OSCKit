//
//  OSCMessageDecoder.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data
#endif

/// Internal:
/// ``OSCMessage`` decoding methods.
///
/// This is not meant to be instanced but instead provides static helper methods for OSC message
/// decoding.
enum OSCMessageDecoder {
    /// Decodes OSC message raw data.
    static func decode(
        rawData: Data
    ) throws(OSCDecodeError) -> (addressPattern: String, values: OSCValues) {
        // validation: length
        if rawData.count % 4 != 0 { // isn't a multiple of 4 bytes (as per OSC spec)
            throw .malformed("Length not a multiple of 4 bytes.")
        }
        
        // validation: check header
        guard rawData.appearsToBeOSCMessage else {
            throw .malformed("Does not start with an address pattern.")
        }
        
        return try rawData.withPointerDataParser { decoder throws(OSCDecodeError) in
            // OSC address
            
            guard let extractedAddressPattern = try? decoder.readOSC4ByteAlignedNullTerminatedASCIIString()
            else {
                throw .malformed("Address pattern string could not be parsed.")
            }
            
            // OSC-type chunk
            
            guard var extractedOSCtags = (try? decoder.readOSC4ByteAlignedNullTerminatedASCIIString())?
                .map({ Character(extendedGraphemeClusterLiteral: $0) })
            else {
                throw .malformed("Couldn't extract OSC-type chunk.")
            }
            
            // set up value array
            var extractedValues: OSCValues = []
            
            var currentTagIndex = 0
            while currentTagIndex < extractedOSCtags.count {
                var char = extractedOSCtags[currentTagIndex]
                
                switch char {
                case ",", "\0":
                    // ignore
                    currentTagIndex += 1
                    
                default:
                    let tagsToAdvance = try decodeValue(
                        initialChar: &char,
                        currentTagIndex: &currentTagIndex,
                        tags: &extractedOSCtags,
                        extractedValues: &extractedValues,
                        decoder: &decoder
                    )
                    currentTagIndex += tagsToAdvance
                }
            }
            
            return (extractedAddressPattern, extractedValues)
        }
    }
    
    /// Decode a series of values.
    /// Returns number of tag(s) to advance.
    static func decodeValue(
        initialChar: inout Character,
        currentTagIndex: inout Int,
        tags: inout [Character],
        extractedValues: inout OSCValues,
        decoder: inout OSCValueDecoder
    ) throws(OSCDecodeError) -> Int {
        let concreteTypes = OSCSerialization.shared.concreteTypes(for: initialChar)
            .compactMap { $0 as? (any OSCValue.Type) }
        
        guard !concreteTypes.isEmpty else {
            throw .malformed(
                "No concrete type found to decode OSC type tag: \(initialChar)"
            )
        }
        
        var tagsToAdvance = 0
        
        var isTypeDecoded = false
        for concreteType in concreteTypes {
            guard !isTypeDecoded else { continue }
            
            if let decoded = try Self.decode(
                forType: concreteType,
                char: initialChar,
                charStream: tags[currentTagIndex...],
                decoder: &decoder
            ) {
                tagsToAdvance = decoded.tagCount
                extractedValues += decoded.value
                
                // prevent multiple decode attempts for the same value
                isTypeDecoded = true
            }
        }
        
        guard isTypeDecoded else {
            throw .internalInconsistency(
                "No decoder found to decode OSC type tag: \(initialChar). Only decoder types supplied by OSCKit can be used."
            )
        }
        
        return tagsToAdvance
    }
    
    /// Internal:
    /// Executes the concrete type's specialized OSC decoder block.
    private static func decode<T: OSCValue & OSCValueDecodable>(
        forType: T.Type,
        char: Character,
        charStream: Array<Character>.SubSequence,
        decoder: inout OSCValueDecoder
    ) throws(OSCDecodeError) -> (tagCount: Int, value: any OSCValue)? {
        switch T.oscDecoding {
        case let d as OSCValueStaticTagDecoder<T>:
            let decoded = try d.block(&decoder)
            return (tagCount: 1, value: decoded)
            
        case let d as OSCValueVariableTagDecoder<T>:
            let decoded = try d.block(char, &decoder)
            return (tagCount: 1, value: decoded)
            
        case let d as OSCValueVariadicTagDecoder<T>:
            return try d.block(Array(charStream), &decoder)
            
        default:
            throw .malformed(
                "No decoder is implemented for OSC type tag: \(char)"
            )
        }
    }
}
