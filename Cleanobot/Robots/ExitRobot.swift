//
//  exitRobot.swift
//  Robots
//
//  Created by Pete Bennett on 12/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class ExitRobot: Robot {
    override func canMove(fence: FenceType) -> Bool {
        return false // never moves
    }
    override func getImageString() -> String {  // Always overwritten
        return "doorImage"
    }
}
