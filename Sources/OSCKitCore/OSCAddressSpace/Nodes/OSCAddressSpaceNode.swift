//
//  OSCAddressSpaceNode.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

/// Protocol adopted by the internal `OSCAddressSpace` `Node` class.
protocol OSCAddressSpaceNode {
    associatedtype MethodID: Equatable & Hashable & Sendable
    
    var nodeType: OSCAddressSpaceNodeType<MethodID> { get set }
    nonisolated var name: String { get }
    var children: [Self] { get }
}

// MARK: - Collection Methods

extension Collection where Element: OSCAddressSpaceNode {
    /// Internal:
    /// Filters collection elements that match the given path component OSC address pattern.
    func filter(
        matching pattern: OSCAddressPattern.Component
    ) -> [Element] {
        filter { pattern.evaluate(matching: $0.name) }
    }
}
