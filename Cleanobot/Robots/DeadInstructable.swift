//
//  DeadInstructable.swift
//  Robots
//
//  Created by Pete Bennett on 20/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class DeadInstructable : InstructableRobot {
    override func canMove(fence: FenceType) -> Bool {  // never move or do anything
        return false
    }

}
