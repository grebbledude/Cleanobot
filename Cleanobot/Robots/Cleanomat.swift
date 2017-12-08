//
//  Cleanomat.swift
//  Robots
//
//  Created by Pete Bennett on 12/08/2017.
//  Copyright © 2017 Pete Bennett. All rights reserved.
//

import Foundation
class Cleanomat: InstructableRobot {

    var mRubbishCount = 0
    weak var mRubbishRobot: RubbishRobot?
    override func canMove(fence: FenceType) -> Bool {
        if doHoover() {
            return false
        
        }
        switch fence {
        case .edge:
            mBoard?.getController().reduceHealth(by:  1, cause: .damage)
            animateBump()
        case .electrified:
            mBoard?.getController().reduceHealth(by:  99, cause: .electrocuted)
            animateBump()
        case .normal:
            mBoard?.getController().reduceHealth(by:  1, cause: .damage)
            animateBump()
        case .none:
            break
        }
        return super.canMove(fence: fence)
    }
    override func interact(with robot: Robot) -> Bool {
        if let _ = robot as? InstructableRobot {
            animateBump()
            return false
        }
        switch robot {
        case let rub as RubbishRobot:
            mRubbishRobot = rub
            mRubbishCount = rub.getVolume()
            return true
        case is ExitRobot:
            let rubbish = mBoard!.countRubbish()
            if mBoard!.getController().foundDoor(rubbish: rubbish) {
                return true
            } else {
                return false
            }
        default:
            animateBump()
            robot.turn(towards: self)
            return false
            
        }
    }

    override func getIcon() -> String {
        return "robbieSmall" //
    }
    
    override func getImageString() -> String {  
        return "robbieLarge"

    }
    override func moveAfterInstruction() -> Bool {
        if doHoover() {
            _ = mInstructions.dequeue()
            return false
        }
        return super.moveAfterInstruction()
    }
    override func destroy(cause: CauseOfDeath) {
        mBoard!.getController().reduceHealth(by:  10000, cause: cause)  // Enough to kill!
    }
    override func doActivate() -> Bool {
        return doNothing()   //  treats activate as a .nop
    }

    func doHoover() -> Bool {
        if let rubbish = mRubbishRobot {
            let count = rubbish.getVolume()
            mBoard!.getController().reduceCapacity(by:  1)
            if count == 1 {
                rubbish.kill()
            } else {
                rubbish.setVolume(volume: count - 1)
            }
            return true
        }
        return false
    }
    func doDamage(damage: Int) {
        
        mBoard!.getController().reduceHealth(by:  damage, cause: .damage)
    }
    
}
