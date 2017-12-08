//
//  OokRobot.swift
//  Robots
//
//  Created by Pete Bennett on 14/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class OokRobot: Robot {
    override func canMove(fence: FenceType) -> Bool {
        return false // never moves
    }
    override func getImageString() -> String {  // Always overwritten
        return "ookGreen"
    }
}
