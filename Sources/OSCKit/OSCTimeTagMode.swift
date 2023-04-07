//
//  OSCTimeTagMode.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Specifies an OSC server's time tag behavior.
///
/// Time tag information is not altered; this simply dictates how the server reacts to time tag
/// information.
public enum OSCTimeTagMode {
    /// Adopt OSC 1.0 spec behavior where time tags may be used to schedule received OSC bundles to
    /// be dispatched at a future time.
    case osc1_0
    
    /// Ignore time tags present in OSC bundles.
    /// All received OSC bundles are handled immediately when received and no scheduling will occur.
    ///
    /// > OSC 1.1 Spec:
    /// >
    /// > "We also have discovered that the OSC 1.0 semantics are not very useful for the common
    /// > case of unidirectional OSC messaging. This is because the sender of OSC messages cannot
    /// > know how far ahead in time to schedule OSC messages because it cannot learn of the network
    /// > latency statistics seen by the receiver.
    /// >
    /// > Instead of outlawing [common implementations by the OSC community] or other future
    /// > scenarios we have decided to embrace all of them by simply not specifying time tag
    /// > semantics at all in OSC 1.1. The specification simply provides a place in the stream for a
    /// > time-tag, defines units for it and we still require that the least significant bit is
    /// > reserved to mean 'immediately'."
    case ignore
}
