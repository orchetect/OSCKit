// ----------------------------------------------
// ----------------------------------------------
// Protocols/Protocols.swift
//
// Borrowed from swift-extensions 1.4.10 under MIT license.
// https://github.com/orchetect/swift-extensions
// Methods herein are unit tested at their source
// so no unit tests are necessary.
// ----------------------------------------------
// ----------------------------------------------

// MARK: - ByteOrder

/// Enum describing endianness when stored in data form.
package enum ByteOrder {
    case platformDefault
    case littleEndian
    case bigEndian
}

#if canImport(CoreFoundation)
import CoreFoundation

extension ByteOrder {
    /// Returns the current system hardware's byte order endianness.
    package static let system: ByteOrder =
        CFByteOrderGetCurrent() == CFByteOrderBigEndian.rawValue
            ? .bigEndian
            : .littleEndian
}
#endif
