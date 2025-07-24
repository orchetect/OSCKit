//
//  OSCTCPFramingMode.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Packet framing modes for TCP-based OSC sockets.
public enum OSCTCPFramingMode {
    /// OSC 1.0 mode: Packet length header.
    ///
    /// > Note:
    /// >
    /// > While the OSC 1.0 Spec does not specifically determine this framing method, it was widely adopted by
    /// > manufacturers of software and hardware using OSC 1.0 over TCP.
    case osc1_0
    
    /// OSC 1.1 mode: SLIP (RFC 1055) with a double END character encoding.
    ///
    /// > OSC 1.1 Specification:
    /// >
    /// > Stream-oriented protocols such as TCP and serial byte streams need a framing mechanism to establish message
    /// > boundaries. These streams are now required to employ SLIP (RFC 1055) with a double END character encoding.
    /// > This choice has been used extensively for years on the Make Controller board and in our micro-OSC work and we
    /// > have established its efficiency and superiority over the OSC 1.0 size-count-preamble recommendation when
    /// > recovering from damaged stream data.
    ///
    /// See [RFC 1055 Specification](https://www.rfc-editor.org/rfc/rfc1055.txt)
    case osc1_1
    
    /// None: Send OSC packet bytes as-is.
    @available(*, unavailable, message: "Not yet implemented.")
    case none
    // TODO: 'none' is implemented in the codebase, however there is an issue with OSCTCPServer where more than one received packet may be contained in the data received. A solution needs to be found to either parse out multiple consecutive OSC bundles/messages from raw data, or somehow intuit packet byte offsets within the data.
}

extension OSCTCPFramingMode: Equatable { }

extension OSCTCPFramingMode: Hashable { }

extension OSCTCPFramingMode: CaseIterable {
    // TODO: Manual allCases implementation is only necessary because the 'none' case is marked unavailable, preventing Swift from automatically synthesizing allCases
    public static var allCases: [OSCTCPFramingMode] {
        [.osc1_0, .osc1_1]
    }
}

extension OSCTCPFramingMode: Sendable { }
