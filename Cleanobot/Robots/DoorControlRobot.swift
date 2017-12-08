//
//  DoorControlRobot.swift
//  Robots
//
//  Created by Pete Bennett on 03/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class DoorControlRobot: InvisibleRobot {
    override func canMove(fence: FenceType) -> Bool {
        return false // never moves
    }
    override func getImageString() -> String {  // Always overwritten
        return "doorImage"
    }
}
