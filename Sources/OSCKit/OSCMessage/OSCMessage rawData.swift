//
//  OSCMessage.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

// MARK: - OSCMessage

/// OSC Message.
extension OSCMessage {
    
    /// Initialize by parsing raw OSC message data bytes.
    public init(from rawData: Data) throws {
        
        // cache raw data
        
        self.rawData = rawData
        
        // parse a raw OSC packet and populates the struct's properties
        
        let len = rawData.count
        var ppos: Int = 0 // parse byte position
        var remainingData: Data
        
        // validation: length
        if len % 4 != 0 { // isn't a multiple of 4 bytes (as per OSC spec)
            throw DecodeError.malformed("Length not a multiple of 4 bytes.")
        }
        // validation: check header
        guard rawData.appearsToBeOSCMessage else {
            throw DecodeError.malformed("Does not start with an address.")
        }
        
        // OSC address
        
        guard let addressPull = rawData.extractNull4ByteTerminatedASCIIString() else {
            throw DecodeError.malformed("Address string could not be parsed.")
        }
        
        let extractedAddress = addressPull.asciiStringValue
        ppos += addressPull.byteLength
        
        // test for presence of values
        
        remainingData = rawData.subdata(in: ppos..<rawData.count)
        
        // OSC-type chunk
        
        var extractedOSCtypes: ASCIIString
        
        guard let oscTypesPull = remainingData.extractNull4ByteTerminatedASCIIString() else {
            throw DecodeError.malformed("Couldn't extract OSC-type chunk.")
        }
        
        extractedOSCtypes = oscTypesPull.asciiStringValue
        ppos += oscTypesPull.byteLength
        
        // set up value array
        var extractedValues: [Value] = []
        
        for char in extractedOSCtypes.stringValue {
            
            remainingData = rawData.subdata(in: ppos..<rawData.count)
            
            switch char {
                
                // core types
                
            case "i":
                if let pull = remainingData.extractInt32() {
                    extractedValues.append(.int32(pull.int32Value))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("Int32 value couldn't be read.")
                }
                
            case "f":
                if let pull = remainingData.extractFloat32() {
                    extractedValues.append(.float32(pull.float32Value))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("Float32 value couldn't be read.")
                }
                
            case "s":
                if let pull = remainingData.extractNull4ByteTerminatedASCIIString() {
                    extractedValues.append(.string(pull.asciiStringValue))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("String value couldn't be read.")
                }
                
            case "b":
                if let pull = remainingData.extractBlob() {
                    extractedValues.append(.blob(pull.blobValue))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("Blob data couldn't be read.")
                }
                
                // extended types
                
            case "h": // 64 bit big-endian two's complement integer
                if let pull = remainingData.extractInt64() {
                    extractedValues.append(.int64(pull.int64Value))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("Int64 value couldn't be read.")
                }
                
            case "t": // 64 bit big-endian two's complement integer
                if let pull = remainingData.extractInt64() {
                    extractedValues.append(.timeTag(pull.int64Value))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("TimeTag value couldn't be read.")
                }
                
            case "d":
                if let pull = remainingData.extractDouble() {
                    extractedValues.append(.double(pull.doubleValue))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("Double value couldn't be read.")
                }
                
            case "S":
                if let pull = remainingData.extractNull4ByteTerminatedASCIIString() {
                    extractedValues.append(.stringAlt(pull.asciiStringValue))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("StringAlt value couldn't be read.")
                }
                
            case "c":
                if let pull = remainingData.extractInt32() {
                    let asciiCharNum = Int(pull.int32Value)
                    guard let asciiChar = ASCIICharacter(asciiCharNum) else {
                        throw DecodeError.malformed("Character value couldn't be read. Could not form a Unicode scalar from the value.")
                    }
                    extractedValues.append(.character(asciiChar))
                    ppos += pull.byteLength
                } else {
                    throw DecodeError.malformed("Character value couldn't be read.")
                }
                
            case "m":
                if let pull = remainingData.extract(byteLength: 4) {
                    extractedValues.append(
                        .midi(portID: pull[0],
                              status: pull[1],
                              data1: pull[2],
                              data2: pull[3])
                    )
                    ppos += 4
                } else {
                    throw DecodeError.malformed("MIDI value couldn't be read.")
                }
                
            case "T":
                extractedValues.append(.bool(true))
                
            case "F":
                extractedValues.append(.bool(false))
                
            case "N":
                extractedValues.append(.null)
                
            case ",", "\0":
                break // ignore
                
            default:
                throw DecodeError.unexpectedType(tag: char)
                
            }
        }
        
        // update public properties
        address = .init(extractedAddress)
        values = extractedValues
        
    }
    
    /// Internal: generate raw OSC bytes from struct's properties.
    @usableFromInline
    internal static func generateRawData(address: OSCAddress,
                                         values: [Value]) -> Data {
        
        // returns a raw OSC packet constructed out of the struct's properties
        
        // max UDP IPv4 packet size is 65507 bytes,
        // 1kb is reasonable buffer for typical OSC messages
        var data = Data()
        data.reserveCapacity(1000)
        
        var buildDataTypes: [ASCIICharacter] = []
        buildDataTypes.reserveCapacity(values.count)
        buildDataTypes += "," // prime the types chunk
        
        var buildValues = Data()
        buildValues.reserveCapacity(1000)
        
        // add OSC address
        let addressData = address.address.rawData
        data.append(addressData.fourNullBytePadded)
        
        // iterate data types in values array to prepare OSC-type string
        for value in values {
            switch value {
                // core types
            case .int32(let val):
                buildDataTypes += "i"
                buildValues += val.toData(.bigEndian)
                
            case .float32(let val):
                buildDataTypes += "f"
                buildValues += val.toData(.bigEndian)
                
            case .string(let val):
                buildDataTypes += "s"
                buildValues += val.rawData.fourNullBytePadded
                
            case .blob(let val):
                buildDataTypes += "b"
                // blob: An int32 size count, followed by that many 8-bit bytes of arbitrary binary data, followed by 0-3 additional zero-bytes to make the total number of bits a multiple of 32.
                buildValues += val.count.int32.toData(.bigEndian)
                buildValues += val.fourNullBytePadded
                
                // extended types
            case .int64(let val):
                buildDataTypes += "h"
                buildValues += val.toData(.bigEndian)
                
            case .timeTag(let val):
                buildDataTypes += "t"
                buildValues += val.toData(.bigEndian)
                
            case .double(let val):
                buildDataTypes += "d"
                buildValues += val.toData(.bigEndian)
                
            case .stringAlt(let val):
                buildDataTypes += "S"
                buildValues += val.rawData.fourNullBytePadded
                
            case .character(let val):
                buildDataTypes += "c"
                buildValues += val.asciiValue.int32.toData(.bigEndian)
                
            case .midi(let val):
                buildDataTypes += "m"
                buildValues += [val.portID, val.status, val.data1, val.data2].data
                
            case .bool(let val):
                buildDataTypes += val ? "T" : "F"
                
            case .null:
                buildDataTypes += "N"
                
            }
        }
        
        // assemble OSC-type and values chunk
        
        var dataTypesRawData = Data()
        
        dataTypesRawData
            .reserveCapacity(buildDataTypes.count.roundedUp(toMultiplesOf: 4))
        
        dataTypesRawData = buildDataTypes
            .reduce(Data(), { $0 + $1.rawData })
            .fourNullBytePadded
        
        data += dataTypesRawData
        
        data += buildValues
        
        // return data
        return data
        
    }
    
}
