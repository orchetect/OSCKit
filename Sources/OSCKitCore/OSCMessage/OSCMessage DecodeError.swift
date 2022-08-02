//
//  OSCMessage DecodeError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

extension OSCMessage {
    public enum DecodeError: Error {
        /// Malformed data. `verboseError` contains the specific reason.
        case malformed(_ verboseError: String)
        
        /// An unexpected OSC-value type was encountered in the data.
        /// `tagCharacter` contains the OSC Type Tag encountered.
        case unexpectedType(tag: Character)
    }
}
