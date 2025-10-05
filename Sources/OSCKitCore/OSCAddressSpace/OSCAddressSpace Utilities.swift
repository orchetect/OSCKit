//
//  OSCAddressSpace Utilities.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
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
            let isLast = idx == path.indices.last! // guaranteed non-nil
            
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
    @discardableResult @_disfavoredOverload
    func removeMethodNode<S>(
        path: S
    ) -> Bool where S: BidirectionalCollection, S.Element: StringProtocol {
        guard !path.isEmpty,
              let nodes = nodePath(path: path, includeRoot: true)
        else { return false }
        
        return removeMethodNode(path: nodes)
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
    func removeMethodNode(
        path: [Node]
    ) -> Bool {
        guard let lastPathComponentNode = path.last
        else { return false }
        
        let parentNode = path.dropLast().last
        
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
    /// Remove a method node with the given method ID if it is a method, or convert it to a container
    /// if it has children.
    ///
    /// To ensure tree integrity, a method node should only be removed if:
    ///   1) it is marked as a method
    ///   2) is has zero children; if children are present, downgrade node to be a container
    ///
    /// - Returns: `true` if the operation was successful, `false` if unsuccessful or the path does
    ///   not exist.
    @discardableResult
    func removeMethodNode(methodID: MethodID) -> Bool {
        guard let nodes = nodePath(methodID: methodID, includeRoot: true)
        else { return false }
        
        return removeMethodNode(path: nodes)
    }
    
    /// Internal:
    /// Returns the `Node` for the last path component of the given path if it is a method.
    /// Returns `nil` if the node does not exist or if the node is a container.
    func methodNode<S>(
        path: S
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
    /// - May be a partial path.
    /// - Returns `nil` if the node does not exist.
    func node<S>(
        path: S
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
    /// - May be a partial path.
    /// - Returns `nil` if the complete path does not exist.
    func nodePath<S>(
        path: S,
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
    
    /// Internal:
    /// Returns an array representing the path comprised of `Node` references for each path
    /// component.
    /// - May be a partial path; all nodes are assigned a method ID regardless whether they are
    ///   a container or a method.
    /// - Returns `nil` if the complete path does not exist.
    func nodePath(
        methodID: MethodID,
        includeRoot: Bool = false
    ) -> [Node]? {
        var nodes: [Node] = []
        if includeRoot { nodes.append(root) }
        
        func visit(node: Node, path: [Node], isRoot: Bool) -> [Node]? {
            let nodePath = if !isRoot || (isRoot && includeRoot) {
                path + [node]
            } else {
                path
            }
            
            if node.id == methodID {
                return nodePath
            }
            for child in node.children {
                if let path = visit(node: child, path: nodePath, isRoot: false) {
                    return path
                }
            }
            return nil
        }
        
        return visit(node: root, path: [], isRoot: true)
    }
    
    /// Internal:
    /// Returns the method ID corresponding to the node at the given path.
    func methodID<S>(
        path: S
    ) -> MethodID? where S: BidirectionalCollection, S.Element: StringProtocol {
        guard let nodes = nodePath(path: path, includeRoot: true)
        else { return nil }
        
        return nodes.last?.id
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
