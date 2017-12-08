//
//  SweeperRobot.swift
//  Robots
//
//  Created by Pete Bennett on 01/09/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class SweeperRobot: Robot {
    private var mCanTurn = true
    override func getImageString() -> String {
        return "sweeperImage"
    }
    override func interact(with robot: Robot) -> Bool {
        if let _ = robot as? InstructableRobot {
            _ = BroomView(parent: robot.view)
            if let robbie = robot as? Cleanomat {
                robbie.doDamage(damage: 2)
                return false
            } else {
                robot.destroy(cause: .damage)
                return false
            }
        }
        if let _ = robot as? RubbishRobot {
            return true
        }
        return false
        
    }
    override func moveAfterAlternativeAction() -> Bool {
        if mCanTurn {
            mDirection = C.turn(direction: mDirection, turnDir: .opposite)
            mCanTurn = false
            animateTurn(Float.pi , fastTurn: true)
            if mPosition.getFenceType(in: mDirection) == .none {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    override func canMove(fence: FenceType) -> Bool {
        mCanTurn = true
        return super.canMove(fence: fence)
    }
}
