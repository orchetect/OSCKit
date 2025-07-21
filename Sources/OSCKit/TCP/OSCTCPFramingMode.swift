//
//  OSCTCPFramingMode.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// TCP packet framing modes for TCP-based OSC sockets.
public enum OSCTCPFramingMode {
    /// OSC 1.0 mode: Size-count-preamble.
    ///
    /// > Note:
    /// >
    /// > While the OSC 1.0 Spec does not specifically determine this framing method, it was widely adopted for OSC 1.0
    /// > TCP packet framing.
    case osc1_0
    
    /// OSC 1.1 mode: SLIP (RFC1055) with a double END character encoding.
    ///
    /// > OSC Delivery Specification 1.1:
    /// >
    /// > Stream-oriented protocols such as TCP and serial byte streams need a framing mechanism to establish message
    /// > boundaries. These streams are now required to employ SLIP (RFC1055) with a double END character encoding. This
    /// > choice has been used extensively for years on the Make Controller board and in our micro-OSC work and we have
    /// > established its efficiency and superiority over the OSC 1.0 size-count-preamble recommendation when recovering
    /// > from damaged stream data.
    case osc1_1
}

extension OSCTCPFramingMode: Equatable { }

extension OSCTCPFramingMode: Hashable { }

extension OSCTCPFramingMode: Sendable { }
