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
        id: MethodID,
        block: MethodBlock? = nil
    ) -> Node? where S: BidirectionalCollection, S.Element: StringProtocol {
        guard !path.isEmpty else { return nil }
        
        var pathRef: Node? = nil // start at root
        
        for idx in path.indices {
            let isLast = idx == path.indices.last! // guaranteed non-nil
            
            let peers = (pathRef?.children ?? root)
            
            func appendPeer(_ newNode: Node) {
                if let pathRef {
                    pathRef.children.append(newNode)
                } else {
                    root.append(newNode)
                }
            }
            
            if let existingNode = peers
                .first(where: { $0.name == path[idx] })
            {
                pathRef = existingNode
                if isLast {
                    existingNode.nodeType = .method(id: id, block: block)
                }
            } else {
                let newNode = Node(
                    name: path[idx],
                    type: isLast ? .method(id: id, block: block) : .container
                )
                appendPeer(newNode)
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
              let nodes = nodePath(path: path)
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
        
        func removeParentChild(_ child: Node) {
            if let parentNode = path.dropLast().last {
                parentNode.children.removeAll(where: { $0 == child })
            } else {
                // root
                root.removeAll(where: { $0 == child })
            }
        }
        
        // remove the node if
        //   1) it's marked as a method, and
        //   2) it has no children
        if lastPathComponentNode.isMethod {
            if lastPathComponentNode.children.isEmpty {
                removeParentChild(lastPathComponentNode)
            } else {
                lastPathComponentNode.convert(to: .container)
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
        guard let nodes = nodePath(methodID: methodID)
        else { return false }
        
        return removeMethodNode(path: nodes)
    }
    
    /// Internal:
    /// Returns the `Node` for the last path component of the given path if it is a method.
    /// Returns `nil` if the node does not exist or if the node is a container.
    func methodNode<S>(
        path: S
    ) -> Node? where S: BidirectionalCollection, S.Element: StringProtocol {
        var pathRef: Node? = nil // start at root
        for idx in path.indices {
            guard let node = (pathRef?.children ?? root)
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
        var pathRef: Node? = nil // start at root
        for idx in path.indices {
            guard let node = (pathRef?.children ?? root)
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
    ) -> [Node]? where S: BidirectionalCollection, S.Element: StringProtocol {
        var nodes: [Node] = []
        var pathRef: Node? = nil // start at root
        for idx in path.indices {
            guard let node = (pathRef?.children ?? root)
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
    ) -> [Node]? {
        // Context ==`nil` represents root.
        func visit(context: (node: Node, path: [Node])?) -> [Node]? {
            var nodePath: [Node]
            if let context {
                nodePath = context.path + [context.node]
            } else {
                nodePath = []
            }
            
            if let lastNode = nodePath.last,
               case let .method(id: lastNodeID, block: _) = lastNode.nodeType,
               lastNodeID == methodID
            {
                return nodePath
            }

            for child in (context?.node.children ?? root) {
                if let path = visit(context: (node: child, path: nodePath)) {
                    return path
                }
            }
            
            return nil
        }
        
        return visit(context: nil)
    }
    
    /// Internal:
    /// Returns the method ID corresponding to the node at the given path.
    func methodID<S>(
        path: S
    ) -> MethodID? where S: BidirectionalCollection, S.Element: StringProtocol {
        guard let nodes = nodePath(path: path)
        else { return nil }
        
        guard let lastNode = nodes.last,
              case let .method(id: id, block: _) = lastNode.nodeType
        else { return nil }
        
        return id
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
        
        var isRoot = true
        var nodes: [Node] = []
        
        var idx = patternComponents.startIndex
        while idx < patternComponents.endIndex {
            let isLast = idx == patternComponents.indices.last
            
            let peers = isRoot ? root : nodes.lazy.flatMap { $0.children }
            
            let matches = peers.filter(matching: patternComponents[idx])

            if isLast {
                nodes = matches.filter(\.isMethod)
            } else {
                nodes = matches
            }
            
            idx += 1
            isRoot = false
        }
        
        return nodes
    }
}
