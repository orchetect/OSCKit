//
//  OSCAddressSpace Utilities.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore

// MARK: - Node Utility Methods

extension OSCAddressSpace {
    func createMethodNode<S>(
        path: S,
        block: MethodBlock? = nil,
        replaceExisting: Bool = true
    ) -> Node where S: BidirectionalCollection, S.Element: StringProtocol {
        var pathRef = root
        
        for idx in path.indices {
            let isLast = idx == path.indices.last!
            
            if let existingNode = pathRef.children
                .first(where: { $0.name == path[idx] })
            {
                if isLast, replaceExisting {
                    let newNode = Node(path[idx], block)
                    pathRef.children.append(newNode)
                    pathRef = newNode
                } else {
                    pathRef = existingNode
                }
            } else {
                let newNode = Node(path[idx], block)
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
    ) -> Bool where S: BidirectionalCollection, S.Element: StringProtocol {
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
    
    func findMethodNode<S>(
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
    
    func findPathNodes<S>(
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
}

// MARK: - Component Utility Methods

extension OSCAddressSpace {
    func findPatternMatches(
        node: Node,
        pattern: OSCAddressPattern.Component
    ) -> [Node] {
        node.children.filter { pattern.evaluate(matching: $0.name) }
    }
    
    func findNodes(patternMatching address: OSCAddressPattern) -> [Node] {
        let patternComponents = address.components
        guard !patternComponents.isEmpty else { return [] }
        
        var nodes: [Node] = [root]
        var idx = 0
        repeat {
            nodes = nodes.reduce(into: [Node]()) {
                let m = findPatternMatches(node: $1, pattern: patternComponents[idx])
                $0.append(contentsOf: m)
            }
            idx += 1
        } while idx < patternComponents.count
        
        return nodes
    }
}

// MARK: - Category Methods

extension RangeReplaceableCollection where Element == OSCAddressSpace.Node {
    @_disfavoredOverload
    mutating func remove(_ element: Element) {
        removeAll(where: { $0 == element })
    }
}
