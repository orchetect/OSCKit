//
//  OSCAddress.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore
import SwiftASCII

// NOTE: This discussion block is duplicated for `OSCAddress.Pattern`

/// OSCAddress
///
/// [OSC 1.0 Spec](http://opensoundcontrol.org/spec-1_0.html):
///
/// - OSC server dispatches to all OSC Method subscribers that match the address pattern.
/// - Address path components are known as Containers, and the final path component is the Method name.
/// - Address patterns may or may not contain any wildcards. If no wildcards are contained, then the address matches if it matches verbatim.
/// - All the matching OSC Methods are invoked with the same argument data, namely, the OSC Arguments in the OSC Message.
/// - An OSC Address Pattern matches an OSC Address if:
///   1. The OSC Address and the OSC Address Pattern contain the same number of parts; and
///   2. Each part of the OSC Address Pattern matches the corresponding part of the OSC Address.
///
/// These are the matching rules for characters in the OSC Address Pattern:
/// - `?` in the OSC Address Pattern matches any single character
/// - `*` in the OSC Address Pattern matches any sequence of zero or more characters
/// - `[chars]` - a string of characters in square brackets in the OSC Address Pattern matches any character in the string. Inside square brackets, the minus sign (`-`) and exclamation point (`!`) have special meanings:
///   - Two characters separated by a minus sign indicate the range of characters between the given two in ASCII collating sequence. (A minus sign at the end of the string has no special meaning.)
///   - An exclamation point at the beginning of a bracketed string negates the sense of the list, meaning that the list matches any character not in the list. (An exclamation point anywhere besides the first character after the open bracket has no special meaning.)
/// - `{foo,bar}` - A comma-separated list of strings enclosed in curly braces in the OSC Address Pattern matches any of the strings in the list.
/// - Any other character in an OSC Address Pattern can match only the same character.
///
/// [OSC 1.1 Spec](http://opensoundcontrol.org/spec-1_1.html):
///
/// The 1.1 spec was never formalized, but the white-paper is available.
///
/// - Inherits OSC 1.0 pattern matching and adds the `//` operator
///
public struct OSCAddress: Hashable {
    
    internal let address: ASCIIString
    
    // MARK: - Init
    
    /// Create an OSC address from a raw `String` address.
    /// The string will be converted to an ASCII string, lossily converting or removing invalid non-ASCII characters if necessary.
    @_disfavoredOverload
    public init(_ address: String) {
        
        self.address = address.asciiStringLossy
        
    }
    
    /// Create an OSC address from a raw `ASCIIString` address.
    public init(_ address: ASCIIString) {
        
        self.address = address
        
    }
    
    /// Create an OSC address from individual path components.
    /// The path component strings will be converted to ASCII strings, lossily converting or removing invalid non-ASCII characters if necessary.
    /// Empty path components is equivalent to the address of "/".
    public init(pathComponents: [String]) {
        
        self.address = ("/" + pathComponents.joined(separator: "/")).asciiStringLossy
        
    }
    
    /// Create an OSC address from individual path components.
    /// The path component strings will be converted to ASCII strings, lossily converting or removing invalid non-ASCII characters if necessary.
    /// Empty path components is equivalent to the address of "/".
    @_disfavoredOverload
    public init(pathComponents: [ASCIIString]) {
        
        self.address = ASCIICharacter("/") + pathComponents.joined(separator: "/")
        
    }
     
}

extension OSCAddress: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    
    public init(stringLiteral: Self.StringLiteralType) {
        
        address = ASCIIString(stringLiteral)
        
    }
    
}

extension OSCAddress: CustomStringConvertible {
    
    public var description: String {
        
        address.stringValue
        
    }
    
}

extension OSCAddress {
    
    // MARK: - Address Components
    
    public var asciiStringValue: ASCIIString {
        
        address
        
    }
    
    public var stringValue: String {
        
        address.stringValue
        
    }
    
    /// Returns the address as individual path components (strings between `/` separators).
    public var pathComponents: [Substring]? {
        
        let addressString = address.stringValue
        
        guard addressString.prefix(1) == "/",
              addressString.count > 1,
              addressString.suffix(1) != "/"
        else { return nil }
        
        let addressStringAfterInitialSlash = addressString.suffix(
            from: addressString.index(after: addressString.startIndex)
        )
        
        return addressStringAfterInitialSlash
            .split(separator: "/",
                   omittingEmptySubsequences: false)
        
    }
    
    // MARK: - Pattern
    
    /// Returns the OSC address converted to a tokenized pattern form.
    internal var pattern: [Pattern] {
        
        pathComponents?
            .map { Pattern(string: String($0)) ?? .init() }
        ?? []
        
    }
    
}
