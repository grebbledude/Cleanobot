//
//  Node.swift
//  Robots
//
//  Created by Pete Bennett on 13/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
public class Node <Type> {
    var value: Type
    var next: Node?
    weak var previous: Node?
    
    init(value: Type) {
        self.value = value
    }
}
