/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Foundation/String and Foundation.swift
///
/// Borrowed from OTCore 1.4.10 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import Foundation

extension StringProtocol {
    /// Convenience function to return a new string with whitespaces and newlines trimmed off start
    /// and end.
    @inlinable
    package var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension StringProtocol {
    package var quoted: String {
        "\"" + self + "\""
    }
}
