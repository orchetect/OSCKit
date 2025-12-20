//
//  OSCAddressSpaceNodeType.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

/// Node type.
/// A container does not carry a method ID since it is not a method.
/// A container may become a method if it is also registered as one.
enum OSCAddressSpaceNodeType<MethodID> where MethodID: Equatable & Hashable & Sendable {
    /// Container only.
    case container
    
    /// Method, as well as a container if children are present.
    case method(id: MethodID, block: OSCAddressSpace.MethodBlock?)
}

extension OSCAddressSpaceNodeType: Sendable { }

// MARK: - Properties

extension OSCAddressSpaceNodeType {
    var isMethod: Bool {
        switch self {
        case .container: return false
        case .method(id: _): return true
        }
    }
}
