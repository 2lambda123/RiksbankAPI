//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

extension XMLNode {
    
    func node(at path: String...) -> XMLNode? {
        node(at: path)
    }
    
    func node(at path: [String]) -> XMLNode? {
        var node = self
        var components = path
        while !components.isEmpty {
            guard let nextNode = node.children?.first(where: {
                $0.localName == components.first
            }) else {
                return nil
            }
            node = nextNode
            components.removeFirst()
        }
        return node
    }
    
    func child(named name: String) -> XMLNode? {
        node(at: name)
    }
    
    func children(at path: String...) -> [XMLNode] {
        children(at: path)
    }
    
    func children(at path: [String]) -> [XMLNode] {
        return node(at: path)?.children ?? []
    }
    
    func valueOfChild(named name: String) -> String? {
        child(named: name)?.stringValue
    }
}
