//
//  OSCTimeTagMode.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Specifies an OSC server's time tag behavior.
///
/// Time tag information is not altered; this simply dictates how the server reacts to time tag
/// information.
///
/// > OSC 1.0 Spec:
/// >
/// > With regards OSC Bundle Time Tag:
/// >
/// > An OSC server must have access to a representation of the correct current absolute time. OSC
/// > does not provide any mechanism for clock synchronization. If the time represented by the OSC
/// > Time Tag is before or equal to the current time, the OSC Server should invoke the methods
/// > immediately. Otherwise the OSC Time Tag represents a time in the future, and the OSC server
/// > must store the OSC Bundle until the specified time and then invoke the appropriate OSC
/// > Methods. When bundles contain other bundles, the OSC Time Tag of the enclosed bundle must be
/// > greater than or equal to the OSC Time Tag of the enclosing bundle.
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
