//
//  OSCAddressSpace Utilities.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore

// MARK: - Node Utility Methods

extension OSCAddressSpace {
    func createMethodNode(
        path: some BidirectionalCollection<some StringProtocol>,
        replaceExisting: Bool = true
    ) -> Node {
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
    func removeMethodNode(
        path: some BidirectionalCollection<some StringProtocol>,
        forceNonEmptyMethodRemoval: Bool = false
    ) -> Bool {
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
    
    func findMethodNode(
        path: some BidirectionalCollection<some StringProtocol>
    ) -> Node? {
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
    
    func findPathNodes(
        path: some BidirectionalCollection<some StringProtocol>,
        includeRoot: Bool = false
    ) -> [Node]? {
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
    func findPatternMatches(
        node: Node,
        pattern: OSCAddressPattern.Component
    ) -> [Node] {
        node.children.filter { pattern.evaluate(matching: $0.name) }
    }
}

// MARK: - Category Methods

extension RangeReplaceableCollection where Element == OSCAddressSpace.Node {
    @_disfavoredOverload
    mutating func remove(_ element: Element) {
        removeAll(where: { $0 == element })
    }
}
