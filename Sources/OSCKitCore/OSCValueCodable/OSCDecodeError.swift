//
//  OSCDecodeError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

public enum OSCDecodeError: Error {
    /// Malformed data. `verboseError` contains the specific reason.
    case malformed(_ verboseError: String)
        
    /// An unexpected OSC-value type was encountered in the data.
    /// `tag` contains the OSC Type Tag encountered.
    case unexpectedType(tag: Character)
}
