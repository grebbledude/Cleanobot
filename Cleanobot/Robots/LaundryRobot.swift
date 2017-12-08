//
//  LaundryRobot.swift
//  Robots
//
//  Created by Pete Bennett on 22/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class LaundryRobot: Robot {

    override func getImageString() -> String {
        return "laundryImage"
    }
    override func interact(with robot: Robot) -> Bool {
        if let _ = robot as? InstructableRobot {
            robot.destroy(cause: .cleaner)
            return true
        }
        return false
        
    }
    override func moveAfterAlternativeAction() -> Bool {
        return moveAfterTurn(direction: .right)
    }
    
}
