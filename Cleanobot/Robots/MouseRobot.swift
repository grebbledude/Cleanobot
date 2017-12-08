//
//  MouseRobot.swift
//  Robots
//
//  Created by Pete Bennett on 11/10/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import UIKit
class MouseRobot: InstructableRobot {
    var mSpecialMove = false
    override func canMove(fence: FenceType) -> Bool {
        let specialMove = mSpecialMove
        mSpecialMove = false
        switch fence {
        case .edge:
            animateBump()
            return false
        case .electrified:
            destroy(cause: .electrocuted)
            return false
        case .normal:
            if specialMove {
                return true
            }
            animateBump()
            return false
        case .none:
            return true
        }
    }
    override func interact(with robot: Robot) -> Bool {
        switch robot {
        case is InstructableRobot:
            animateBump()
            return false
        case is RubbishRobot:
            return true
        case is ExitRobot:
            
            animateBump()
            return false
            
        default:
            robot.turn(towards: self)
            return false
            
        }
    }
    override func getIcon() -> String {
        return "GreyMouse" //
    }
    
    override func getImageString() -> String {
        return "GreyMouse"
        
    }
    override func animateMove(from: BoardSquare, to: BoardSquare) {
        UIView.animate(withDuration: mBoard!.getSpeed(), delay: 0.0,options: UIViewAnimationOptions.curveEaseOut,animations: {
            let targetFrame = to.getFrame()
            self.mXConstraint!.constant = targetFrame.minX
            self.mYConstraint!.constant = targetFrame.minY
            self.mView!.superview!.layoutIfNeeded()
        },completion: nil)
        
    }
    override func doActivate() -> Bool {
        mSpecialMove = true  // Can burrow under fences
        return true
    }
}
