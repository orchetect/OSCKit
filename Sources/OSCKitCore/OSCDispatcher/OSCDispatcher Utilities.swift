//
//  OSCDispatcher Utilities.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Foundation
@_implementationOnly import OTCore

// MARK: - Node Utility Methods

extension OSCDispatcher {
    func createMethodNode<S>(
        path: S,
        replaceExisting: Bool = true
    ) -> Node
        where S: BidirectionalCollection,
        S.Element: StringProtocol
    {
        var pathRef = root
        
        for idx in path.indices {
            let isLast = idx == path.indices.last!
            
            if let existingNode = pathRef.children
                .first(where: { $0.name == path[idx] })
            {
                if isLast, replaceExisting {
                    let newNode = Node(path[idx])
                    pathRef.children.append(newNode)
                    pathRef = newNode
                } else {
                    pathRef = existingNode
                }
            } else {
                let newNode = Node(path[idx])
                pathRef.children.append(newNode)
                pathRef = newNode
            }
        }
        
        return pathRef
    }
    
    @discardableResult
    func removeMethodNode<S>(
        path: S,
        forceNonEmptyMethodRemoval: Bool = false
    ) -> Bool
        where S: BidirectionalCollection,
        S.Element: StringProtocol
    {
        guard !path.isEmpty,
              let nodes = findPathNodes(path: path, includeRoot: true)
        else { return false }
        
        let method = nodes.last!
        let parent = nodes.dropLast().last
        
        if method.children.isEmpty {
            parent?.children.remove(method)
        } else {
            if forceNonEmptyMethodRemoval {
                parent?.children.remove(method)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func findMethodNode<S>(path: S) -> Node?
        where S: BidirectionalCollection,
        S.Element: StringProtocol
    {
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
    
    func findPathNodes<S>(
        path: S,
        includeRoot: Bool = false
    ) -> [Node]?
        where S: BidirectionalCollection,
        S.Element: StringProtocol
    {
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

// MARK: - Pattern Utility Methods

extension OSCDispatcher {
    func findPatternMatches(
        node: Node,
        pattern: OSCAddress.Pattern
    ) -> [Node] {
        node.children.filter { pattern.evaluate(matching: $0.name) }
    }
}

// MARK: - Category Methods

extension RangeReplaceableCollection where Element == OSCDispatcher.Node {
    @_disfavoredOverload
    mutating func remove(_ element: Element) {
        removeAll(where: { $0 == element })
    }
}
