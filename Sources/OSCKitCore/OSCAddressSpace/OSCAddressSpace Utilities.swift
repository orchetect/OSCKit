//
//  OSCAddressSpace Utilities.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Node Utility Methods

extension OSCAddressSpace {
    /// Internal:
    /// Create a method node by creating its path node tree recursively as needed.
    ///
    /// If the method node already exists as either a container or method, it will be updated to be
    /// marked as a method and its block closure will be replaced.
    ///
    /// Children, if any, are unaffected.
    func createMethodNode<S>(
        path: S,
        block: MethodBlock? = nil
    ) -> Node where S: BidirectionalCollection, S.Element: StringProtocol {
        var pathRef = root
        
        for idx in path.indices {
            let isLast = idx == path.indices.last!
            
            if let existingNode = pathRef.children
                .first(where: { $0.name == path[idx] })
            {
                pathRef = existingNode
                if isLast {
                    pathRef.nodeType = .method
                    pathRef.block = block
                }
            } else {
                let newNode = Node(
                    name: path[idx],
                    type: isLast ? .method : .container,
                    block: block
                )
                pathRef.children.append(newNode)
                pathRef = newNode
            }
        }
        
        return pathRef
    }
    
    /// Internal:
    /// Remove a method node if it is a method, or convert it to a container if it has children.
    ///
    /// To ensure tree integrity, a method node should only be removed if:
    ///   1) it is marked as a method
    ///   2) is has zero children; if children are present, downgrade node to be a container
    ///
    /// - Returns: `true` if the operation was successful, `false` if unsuccessful or the path does
    ///   not exist.
    @discardableResult
    func removeMethodNode<S>(
        path: S
    ) -> Bool where S: BidirectionalCollection, S.Element: StringProtocol {
        guard !path.isEmpty,
              let nodes = nodePath(for: path, includeRoot: true)
        else { return false }
        
        let lastPathComponentNode = nodes.last!
        let parentNode = nodes.dropLast().last
        
        // remove the node if
        //   1) it's marked as a method, and
        //   2) it has no children
        if lastPathComponentNode.isMethod {
            if lastPathComponentNode.children.isEmpty {
                parentNode?.children.remove(lastPathComponentNode)
            } else {
                lastPathComponentNode.convertToContainer()
            }
        } else {
            // not a method node; nothing can be done
            return false
        }
        
        return true
    }
    
    /// Internal:
    /// Returns the `Node` for the last path component of the given path if it is a method.
    /// Returns `nil` if the node does not exist or if the node is a container.
    func methodNode<S>(
        at path: S
    ) -> Node? where S: BidirectionalCollection, S.Element: StringProtocol {
        var pathRef = root
        for idx in path.indices {
            guard let node = pathRef.children
                .first(where: { $0.isMethod && $0.name == path[idx] })
            else {
                return nil
            }
            pathRef = node
        }
        return pathRef
    }
    
    /// Internal:
    /// Returns the `Node` for the last path component of the given path.
    /// May be a partial path.
    /// Returns `nil` if the node does not exist.
    func node<S>(
        at path: S
    ) -> Node? where S: BidirectionalCollection, S.Element: StringProtocol {
        var pathRef = root
        for idx in path.indices {
            guard let node = pathRef.children
                .first(where: { $0.name == path[idx] })
            else {
                return nil
            }
            pathRef = node
        }
        return pathRef
    }
    
    /// Internal:
    /// Returns an array representing the path comprised of `Node` references for each path
    /// component.
    /// May be a partial path.
    /// Returns `nil` if the complete path does not exist.
    func nodePath<S>(
        for path: S,
        includeRoot: Bool = false
    ) -> [Node]? where S: BidirectionalCollection, S.Element: StringProtocol {
        var nodes: [Node] = []
        var pathRef = root
        if includeRoot { nodes.append(pathRef) }
        for idx in path.indices {
            guard let node = pathRef.children
                .first(where: { $0.name == path[idx] })
            else { return nil }
            pathRef = node
            nodes.append(node)
        }
        return nodes
    }
}

// MARK: - Component Utility Methods

extension OSCAddressSpace {
    /// Internal:
    /// Returns all registered local OSC method nodes whose path matches the given OSC address
    /// pattern.
    func methodNodes(patternMatching address: OSCAddressPattern) -> [Node] {
        let patternComponents = address.components
        guard !patternComponents.isEmpty else { return [] }
        
        var nodes: [Node] = [root]
        var idx = patternComponents.startIndex
        while idx < patternComponents.endIndex {
            let isLast = idx == patternComponents.indices.last
            nodes = nodes.reduce(into: []) {
                let m = $1.children(matching: patternComponents[idx])
                if isLast {
                    $0.append(contentsOf: m.filter(\.isMethod))
                } else {
                    $0.append(contentsOf: m)
                }
            }
            idx += 1
        }
        
        return nodes
    }
}

// MARK: - Category Methods

extension RangeReplaceableCollection where Element == OSCAddressSpace.Node {
    /// Internal convenience:
    /// Remove an element from the collection.
    @_disfavoredOverload
    mutating func remove(_ element: Element) {
        removeAll(where: { $0 == element })
    }
}
