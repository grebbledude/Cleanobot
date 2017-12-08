//
//  Queue.swift
//  Robots
//
//  Created by Pete Bennett on 13/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
public struct Queue<T> {
    
    fileprivate var list = LinkedList<T>()
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    

    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    

    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        
        _ = list.remove(node: element)
        
        return element.value
    }
    
    public func peek() -> T? {
        return list.first?.value
    }
}
