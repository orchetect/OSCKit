//
//  OSCBundle.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

// MARK: - OSCBundle

/// OSC Bundle object.
///
/// - `timeTag`: Int64 OSC time-tag
/// - `elements`: Array of `OSCBundle` and/or `OSCMessage` objects
/// - `rawData`: Set or get to parse or encode the contents.
public struct OSCBundle: OSCObject {
    
    // MARK: - Properties
    
    /// Timetag.
    /// Default value 1: means "immediate" in OSC spec.
    public let timeTag: Int64
    
    /// Element type.
    public typealias Element = OSCObject
    
    /// Elements contained within the bundle. These can be `OSCBundle` or `OSCMessage` objects.
    public let elements: [OSCPayload]
    
    
    // MARK: - init
    
    @inlinable
    public init(elements: [OSCPayload],
                timeTag: Int64 = 1) {
        
        self.timeTag = timeTag
        self.elements = elements
        self.rawData = Self.generateRawData(from: elements,
                                            timeTag: timeTag)
        
    }
    
    /// Initialize by parsing raw OSC bundle data bytes.
    public init(from rawData: Data) throws {
        
        // cache raw data
        
        self.rawData = rawData
        
        // parse a raw OSC packet and populates the struct's properties
        
        let len = rawData.count
        var ppos: Int = 0 // parse byte position
        
        // validation: length. all bundles must include the header (8 bytes) and timetag (8 bytes).
        if len < 16 {
            throw DecodeError.malformed("Data length too short. (Length is \(len))")
        }
        
        // validation: check header
        if rawData.subdata(in: Range(ppos...ppos+7)) != OSCBundle.header {
            throw DecodeError.malformed("Bundle header is not present or is malformed.")
        }
        
        // set up object array
        var extractedElements = [OSCPayload]()
        
        ppos += 8
        
        guard let extractedTimeTag = rawData
                .subdata(in: ppos..<ppos+8)
                .toInt64(from: .bigEndian) else {
                    throw DecodeError.malformed("Could not convert timetag to Int64.")
                }
        
        ppos += 8
        
        while ppos < len {
            
            //int32 size chunk
            if rawData.count - (ppos+3) < 0 {
                throw DecodeError.malformed("Data bytes ended earlier than expected.")
            }
            guard let elementSize = rawData
                    .subdata(in: ppos..<ppos+4)
                    .toInt32(from: .bigEndian)?.int else {
                        throw DecodeError.malformed("Could not convert element size to Int32.")
                    }
            
            ppos += 4
            
            // test for bundle or message
            if rawData.count - (ppos+elementSize) < 0 {
                throw DecodeError.malformed("Data bytes ended earlier than expected.")
            }
            
            let elementContents = rawData.subdata(in: ppos..<ppos+elementSize)
            
            guard let oscObject = elementContents.appearsToBeOSC else {
                throw DecodeError.malformed("Unrecognized bundle element encountered.")
            }
            
            switch oscObject {
            case .bundle:
                let newBundle = try OSCBundle(from: elementContents)
                extractedElements.append(.bundle(newBundle))
                
            case .message:
                let newMessage = try OSCMessage(from: elementContents)
                extractedElements.append(.message(newMessage))
                
            }
            
            ppos += elementSize
            
        }
        
        // update public properties
        timeTag = extractedTimeTag
        elements = extractedElements
        
    }
    
    
    // MARK: - rawData
    
    public let rawData: Data
    
    /// Internal: generate raw OSC bytes from struct's properties
    @usableFromInline
    internal static func generateRawData(from elements: [OSCPayload],
                                         timeTag: Int64) -> Data {
        
        // returns a raw OSC packet constructed out of the struct's properties
        
        // max UDP IPv4 packet size is 65507 bytes,
        // 10kb is reasonable buffer for typical OSC bundles
        var data = Data()
        data.reserveCapacity(10000)
        
        data.append(OSCBundle.header) // prime the header
        
        data.append(timeTag.toData(.bigEndian)) // add timetag
        
        for element in elements {
            
            let raw = element.rawData
            
            // element length
            data.append(raw.count.int32.toData(.bigEndian))
            
            // element data
            data.append(raw)
            
        }
        
        return data
        
    }
    
}


// MARK: - Equatable

extension OSCBundle: Equatable {
    
    public static func == (lhs: OSCBundle, rhs: OSCBundle) -> Bool {
        
        // don't factor timeTag into equality
        
        guard lhs.elements.count == rhs.elements.count else { return false }
        
        for (lhsIndex, rhsIndex) in zip(lhs.elements.indices, rhs.elements.indices) {
            
            switch lhs.elements[lhsIndex] {
            case .bundle(let lhsElementTyped):
                guard case .bundle(let rhsElementTyped) = rhs.elements[rhsIndex]
                else { return false }
                
                if lhsElementTyped != rhsElementTyped { return false }
                
            case .message(let lhsElementTyped):
                guard case .message(let rhsElementTyped) = rhs.elements[rhsIndex]
                else { return false }
                
                if lhsElementTyped != rhsElementTyped { return false }
                
            }
            
        }
        
        return true
        
    }
    
}


// MARK: - Hashable

extension OSCBundle: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        
        // don't factor timeTag into hash
        
        elements.forEach {
            
            switch $0 {
            case .bundle(let elementTyped):
                hasher.combine(elementTyped)
                
            case .message(let elementTyped):
                hasher.combine(elementTyped)
                
            }
            
        }
        
    }
    
}


// MARK: - CustomStringConvertible

extension OSCBundle: CustomStringConvertible {
    
    public var description: String {
        
        elements.count < 1
        ? "OSCBundle(timeTag: \(timeTag))"
        : "OSCBundle(timeTag: \(timeTag), elements: \(elements))"
        
    }
    
    /// Same as `description` but elements are separated with new-line characters.
    public var descriptionPretty: String {
        
        let elementsString =
        elements
            .map { "\($0)" }
            .joined(separator: "\n  ")
        
        return elements.count < 1
        ? "OSCBundle(timeTag: \(timeTag))"
        : "OSCBundle(timeTag: \(timeTag)) Elements:\n  \(elementsString)"
            .trimmed
        
    }
    
}


// MARK: - Header

extension OSCBundle {
    
    /// Constant caching an OSCBundle header
    public static let header: Data =
    "#bundle"
        .toData(using: .nonLossyASCII)!
        .fourNullBytePadded
    
}

extension Data {
    
    /// A fast function to test if Data() begins with an OSC bundle header
    /// (Note: Does NOT do extensive checks to ensure data block isn't malformed)
    @inlinable
    var appearsToBeOSCBundle: Bool {
        
        self.starts(with: OSCBundle.header)
        
    }
    
}
