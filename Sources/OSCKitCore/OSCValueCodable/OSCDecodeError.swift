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
    
    /// Internal inconsistency; decoding logic is in an unexpected state and cannot continue.
    /// `verboseError` contains the specific reason.
    case internalInconsistency(_ verboseError: String)
}
