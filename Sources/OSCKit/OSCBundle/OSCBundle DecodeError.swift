//
//  OSCBundle DecodeError.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

extension OSCBundle {
    public enum DecodeError: Error {
        /// Malformed data. `verboseError` contains the specific reason.
        case malformed(_ verboseError: String)
    }
}
